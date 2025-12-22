import time
import logging
from datetime import datetime
from crewai import Crew
from crewai.tasks import tasks_pipeline
from crewai.agents import pesquisador, redator, validador
from crewai.tools import bootstrap_rag
from mlops.tracking import log_agent_run

logger = logging.getLogger("CrewAI-Orchestrator")
logging.basicConfig(level=logging.INFO)

# Inicializa o índice RAG
bootstrap_rag()

crew = Crew(
    agents=[pesquisador, redator, validador],
    tasks=tasks_pipeline,
    verbose=True
)

def execute_agent(topic: str = "Tendências em Inteligência Artificial"):
    """
    Executa a pipeline de agentes CrewAI para um tema específico.
    Registra execução no MLflow com versão, métricas e artefatos personalizados.
    """
    agent_name = "CrewAI-Orchestrator"
    version = "v2.1.0-personalizada"
    params = {
        "topic": topic,
        "max_tokens": 2048,
        "temperature": 0.2,
        "agents": ["pesquisador", "redator", "validador"],
        "owner": "Rogerio"
    }

    start = time.time()
    try:
        result = crew.run(inputs={"topic": topic})
    except Exception as e:
        logger.error(f"Erro na execução da crew: {e}")
        result = f"Erro: {e}"
    elapsed = time.time() - start

    metrics = {
        "response_time_seconds": elapsed,
        "tokens_used": getattr(result, "tokens", 0) if hasattr(result, "tokens") else 0,
        "agents_count": len(params["agents"])
    }

    artifacts = {
        "report": str(result),
        "metadata": f"Executado em {datetime.utcnow().isoformat()} UTC",
        "topic": topic,
        "owner_note": "Pipeline personalizada por Rogerio"
    }

    # Log no MLflow com tags extras
    run_id = log_agent_run(agent_name, version, params, metrics, artifacts)

    logger.info(f"[{agent_name}] Execução concluída em {elapsed:.3f}s | Run ID: {run_id}")
    return {"run_id": run_id, "result": artifacts["report"]}

if __name__ == "__main__":
    output = execute_agent()
    print(f"Run ID: {output['run_id']}")
    print(f"Resultado:\n{output['result']}")
