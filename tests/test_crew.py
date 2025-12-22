import sys, os
import test_endpoints
from fastapi.testclient import TestClient

# --- Ajuste para garantir que o Python enxergue a raiz do projeto ---
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from api.main import app   # << mudou para app.main

client = TestClient(app)

def test_run_crew_response():
    payload = {"topic": "finance", "params": {"currency": "USD"}}
    response = client.post("/crew", json=payload)
    assert response.status_code == 200

    data = response.json()
    assert data["status"] == "ok"
    assert data["topic"] == "finance"
    assert "result" in data
    assert "run_id" in data
    assert "explanation" in data
    assert "Resposta final do LLM" in data["explanation"]

def test_metrics_logged(monkeypatch):
    metrics_captured = {}

    def fake_log_agent_run(agent_name, version, params, metrics, artifacts):
        nonlocal metrics_captured
        metrics_captured = metrics
        return "fake-run-id"

    monkeypatch.setattr("app.main.log_agent_run", fake_log_agent_run)

    payload = {"topic": "finance", "params": {"currency": "USD"}}
    response = client.post("/crew", json=payload)
    assert response.status_code == 200

    assert "BLEU" in metrics_captured
    assert "ROUGE-1" in metrics_captured
    assert "ROUGE-2" in metrics_captured
    assert "ROUGE-L" in metrics_captured
    assert "METEOR" in metrics_captured
