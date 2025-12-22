# -----------------------
# Stage 1: API (leve)
# -----------------------
FROM python:3.11 AS api

# Variáveis de ambiente para performance
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100

WORKDIR /app

# Instala dependências do sistema necessárias para compilar libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copia requirements primeiro para aproveitar cache
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install -r requirements.txt \
    && pip install torch==2.5.1+cpu --extra-index-url https://download.pytorch.org/whl/cpu

# Copia o restante do código
COPY . .

# Porta padrão para FastAPI/Uvicorn
EXPOSE 8000

# Comando para rodar a API
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]

# -----------------------
# Stage 2: Agentes avançados
# -----------------------
FROM api AS agents

# Copia requirements específicos dos agentes
COPY requirements-agents.txt .
RUN pip install -r requirements-agents.txt \
    && pip install torch==2.5.1+cpu --extra-index-url https://download.pytorch.org/whl/cpu
