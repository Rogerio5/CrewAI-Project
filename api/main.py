from fastapi import FastAPI, Depends, HTTPException, status, Request
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import Optional, Dict
import uvicorn
import time
from jose import JWTError, jwt
from datetime import datetime, timedelta

# Rate limiting
from slowapi import Limiter
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

# Integrações externas (MLflow, avaliação, RAG)
from mlops.tracking import log_agent_run
from mlops.evaluation import evaluate_response
from crewai.rag_store import rag_ingest

# -----------------------
# Configurações de segurança
# -----------------------
SECRET_KEY = "troque_essa_chave"  # coloque uma chave forte aqui
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")
        return {"username": username}
    except JWTError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")

# -----------------------
# Inicialização da API
# -----------------------
app = FastAPI(
    title="Agente Inteligente - CrewAI",
    description="🚀 API do Agente Inteligente com RAG + LLM + MLflow + Hugging Face.",
    version="1.0.0",
    contact={"name": "Rogerio", "url": "https://github.com/Rogerio5", "email": "rogerio@dominio.com"},
    license_info={"name": "MIT", "url": "https://opensource.org/licenses/MIT"}
)

# -----------------------
# Middleware de CORS
# -----------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # pode restringir para domínios específicos
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# -----------------------
# Rate Limiting
# -----------------------
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter

@app.exception_handler(RateLimitExceeded)
def rate_limit_handler(request, exc):
    return JSONResponse(status_code=429, content={"error": "Too many requests"})

# -----------------------
# Schemas Pydantic
# -----------------------
class CrewRequest(BaseModel):
    topic: str
    params: Optional[Dict] = None

class CrewResponse(BaseModel):
    status: str
    topic: str
    result: str
    run_id: str
    explanation: str

class AlertWebhookRequest(BaseModel):
    labels: Dict
    annotations: Optional[Dict] = None

class AlertWebhookResponse(BaseModel):
    status: str
    received: Dict
    run_id: str

class AddDocRequest(BaseModel):
    topic: str
    text: str

class AddDocResponse(BaseModel):
    status: str
    doc_id: str
    owner: str

# -----------------------
# Métricas simplificadas
# -----------------------
response_time_seconds = 0.0
request_count_total = 0

def record_response_time(value: float):
    global response_time_seconds
    response_time_seconds = value

def increment_request_count():
    global request_count_total
    request_count_total += 1

# -----------------------
# Endpoint raiz
# -----------------------
@app.get("/", tags=["Status"], summary="Verificar se a API está rodando")
def root():
    return {"message": "CrewAI API está rodando 🚀"}

# -----------------------
# Endpoints principais
# -----------------------
@app.post("/token", tags=["Autenticação"], summary="Gerar token JWT")
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    if form_data.username != "admin" or form_data.password != "123":
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Credenciais inválidas")
    access_token = create_access_token(data={"sub": form_data.username})
    return {"access_token": access_token, "token_type": "bearer"}

@app.post("/crew", response_model=CrewResponse, tags=["Agente Inteligente"], summary="Executar agente CrewAI")
@limiter.limit("5/minute")  # máximo 5 chamadas por minuto
def run_crew(request: Request, payload: CrewRequest, user=Depends(get_current_user)):
    owner = user["username"]
    topic = payload.topic

    increment_request_count()
    start_time = time.time()

    context_used = ["doc1.txt", "doc2.txt"]
    embeddings_selected = ["embedding_123", "embedding_456"]
    similarity_scores = {"doc1.txt": 0.87, "doc2.txt": 0.76}
    llm_response = "Relatório gerado com insights financeiros."
    reference_response = "Relatório sobre finanças com insights detalhados."

    reasoning_steps = [
        f"Tópico recebido: {topic}",
        f"Contexto usado: {', '.join(context_used)}",
        f"Embeddings selecionados: {', '.join(embeddings_selected)}",
        f"Scores de similaridade: {similarity_scores}",
        f"Resposta final do LLM: {llm_response}"
    ]
    explanation = "\n".join(reasoning_steps)

    metrics_eval = evaluate_response(llm_response, reference_response)

    run_id = log_agent_run(
        agent_name="CrewAI-Agent",
        version="v1",
        params={"owner": owner, "topic": topic},
        metrics={
            "response_time_seconds": time.time() - start_time,
            "BLEU": metrics_eval["BLEU"],
            "ROUGE-1": metrics_eval["ROUGE-1"],
            "ROUGE-2": metrics_eval["ROUGE-2"],
            "ROUGE-L": metrics_eval["ROUGE-L"],
            "METEOR": metrics_eval["METEOR"]
        },
        artifacts={
            "payload.json": str(payload.dict()),
            "explanation.txt": explanation
        }
    )

    record_response_time(time.time() - start_time)

    return {
        "status": "ok",
        "topic": topic,
        "result": llm_response,
        "run_id": run_id,
        "explanation": explanation
    }

@app.post("/add-doc", response_model=AddDocResponse, tags=["Documentos"], summary="Inserir documento no índice RAG")
def add_doc(request: AddDocRequest, user=Depends(get_current_user)):
    owner = user["username"]
    doc_id = f"{owner}-{int(time.time())}"

    doc = {
        "id": doc_id,
        "text": request.text,
        "metadata": {"source": f"user:{owner}", "topic": request.topic}
    }

    try:
        rag_ingest([doc])
        return {"status": "ok", "doc_id": doc_id, "owner": owner}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro ao inserir documento: {e}")

@app.get("/metrics", tags=["Observabilidade"], summary="Expor métricas simplificadas")
def metrics():
    return {
        "request_count_total": request_count_total,
        "last_response_time_seconds": response_time_seconds
    }

@app.post("/alert-webhook", response_model=AlertWebhookResponse, tags=["Alertas"], summary="Receber alertas do Alertmanager")
@limiter.limit("10/minute")  # exemplo: máximo 10 chamadas por minuto
def alert_webhook(request: Request, data: AlertWebhookRequest, user=Depends(get_current_user)):
    run_id = log_agent_run(
        agent_name="Alert-CrewAI",
        version="v-alert",
        params=data.labels,
        metrics={"severity": data.labels.get("severity", "unknown")},
        artifacts={"alert.json": str(data.dict())}
    )
    return {"status": "ok", "received": data.dict(), "run_id": run_id}

# -----------------------
# Entry point para rodar via CLI (crewai-api)
# -----------------------
def run():
    uvicorn.run(app, host="0.0.0.0", port=8000)
