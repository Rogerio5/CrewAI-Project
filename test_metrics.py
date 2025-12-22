import os
import mlflow
from datetime import datetime
from observability.metrics import response_time, request_count

def log_agent_run(agent_name: str, version: str, params: dict, metrics: dict, artifacts: dict = None):
    os.makedirs("artifacts", exist_ok=True)  # cria a pasta se não existir

    mlflow.set_experiment("CrewAI-Agents")
    with mlflow.start_run(run_name=f"{agent_name}-{version}"):
        # Parâmetros
        for k, v in params.items():
            mlflow.log_param(k, v)
        mlflow.log_param("agent_name", agent_name)
        mlflow.log_param("agent_version", version)

        # Métricas
        for k, v in metrics.items():
            mlflow.log_metric(k, float(v))

        # Tags úteis
        mlflow.set_tag("timestamp", datetime.utcnow().isoformat())
        mlflow.set_tag("stage", "production")

        # Artefatos opcionais
        if artifacts:
            for name, content in artifacts.items():
                path = os.path.join("artifacts", name)  # salva com o nome exato
                with open(path, "w", encoding="utf-8") as f:
                    f.write(content)
                mlflow.log_artifact(path)

        # 🔥 Métricas Prometheus personalizadas
        owner = params.get("owner", "desconhecido")
        if "response_time_seconds" in metrics:
            response_time.labels(owner=owner).set(metrics["response_time_seconds"])
        request_count.labels(owner=owner).inc()

        run_id = mlflow.active_run().info.run_id
        return run_id
