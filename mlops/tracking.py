import os
import mlflow
from datetime import datetime
from observability.metrics import response_time, request_count

def log_agent_run(agent_name: str, version: str, params: dict, metrics: dict, artifacts: dict = None):
    """
    Registra execução de um agente no MLflow e atualiza métricas Prometheus.
    
    Args:
        agent_name (str): Nome do agente.
        version (str): Versão do agente.
        params (dict): Parâmetros usados na execução.
        metrics (dict): Métricas coletadas (ex: tempo de resposta).
        artifacts (dict, opcional): Artefatos para salvar e logar no MLflow.
    
    Returns:
        str: ID do run registrado no MLflow.
    """
    # Garante que a pasta artifacts exista
    os.makedirs("artifacts", exist_ok=True)

    # Define experimento no MLflow
    mlflow.set_experiment("CrewAI-Agents")
    with mlflow.start_run(run_name=f"{agent_name}-{version}"):
        # Parâmetros
        for k, v in params.items():
            mlflow.log_param(k, v)
        mlflow.log_param("agent_name", agent_name)
        mlflow.log_param("agent_version", version)

        # Métricas
        for k, v in metrics.items():
            try:
                mlflow.log_metric(k, float(v))
            except Exception:
                # Evita crash se algum valor não for numérico
                mlflow.log_param(f"invalid_metric_{k}", str(v))

        # Tags úteis
        mlflow.set_tag("timestamp", datetime.utcnow().isoformat())
        mlflow.set_tag("stage", "production")

        # Artefatos opcionais
        if artifacts:
            for name, content in artifacts.items():
                path = os.path.join("artifacts", name)
                with open(path, "w", encoding="utf-8") as f:
                    f.write(content)
                mlflow.log_artifact(path)

        # 🔥 Métricas Prometheus personalizadas
        owner = params.get("owner", "desconhecido")

        # Histogram → usa observe()
        if "response_time_seconds" in metrics:
            response_time.labels(owner=owner).observe(metrics["response_time_seconds"])

        # Counter → usa inc()
        request_count.labels(owner=owner).inc()

        # Retorna ID do run
        run_id = mlflow.active_run().info.run_id
        return run_id
