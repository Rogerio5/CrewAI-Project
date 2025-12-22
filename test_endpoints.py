import pytest
import requests

BASE_URL = "http://localhost:8000"

@pytest.fixture(scope="session")
def token():
    """Gera token JWT válido para os testes"""
    resp = requests.post(
        f"{BASE_URL}/token",
        data={"username": "admin", "password": "123"},
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    resp.raise_for_status()
    return resp.json()["access_token"]

def test_token(token):
    """Valida se o token foi gerado corretamente"""
    assert token is not None
    assert isinstance(token, str)

def test_crew_execution(token):
    """Testa execução do endpoint /crew"""
    headers = {"Authorization": f"Bearer {token}"}
    resp = requests.post(
        f"{BASE_URL}/crew",
        json={"topic": "finanças", "query": "Quais são os principais riscos do mercado financeiro?"},
        headers=headers
    )
    assert resp.status_code == 200
    data = resp.json()
    assert "result" in data
    assert "run_id" in data
    assert "explanation" in data

def test_rate_limit(token):
    """Testa rate limiting (máx. 5 chamadas/min)"""
    headers = {"Authorization": f"Bearer {token}"}
    status_codes = []
    for i in range(6):
        resp = requests.post(
            f"{BASE_URL}/crew",
            json={"topic": f"teste-{i}"},
            headers=headers
        )
        status_codes.append(resp.status_code)
    # As primeiras devem ser 200, a última deve ser 429
    assert all(code == 200 for code in status_codes[:5])
    assert status_codes[-1] == 429

def test_metrics():
    """Testa endpoint /metrics"""
    resp = requests.get(f"{BASE_URL}/metrics")
    assert resp.status_code == 200
    data = resp.json()
    assert "request_count_total" in data
    assert "last_response_time_seconds" in data

def test_alert_webhook(token):
    """Testa envio de alerta para /alert-webhook"""
    headers = {"Authorization": f"Bearer {token}"}
    resp = requests.post(
        f"{BASE_URL}/alert-webhook",
        json={"labels": {"alert": "HighCPU", "severity": "critical"}},
        headers=headers
    )
    assert resp.status_code == 200
    data = resp.json()
    assert data["status"] == "ok"
    assert "run_id" in data
