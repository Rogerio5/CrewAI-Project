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

def test_add_doc(token):
    """Valida inserção de documento via endpoint /add-doc"""
    headers = {"Authorization": f"Bearer {token}"}
    payload = {"topic": "finanças", "text": "Relatório sobre mercado financeiro global"}

    resp = requests.post(f"{BASE_URL}/add-doc", json=payload, headers=headers)
    assert resp.status_code == 200

    data = resp.json()
    assert data["status"] == "ok"
    assert "doc_id" in data
    assert data["owner"] == "admin"

def test_add_doc_invalid_token():
    """Valida que requisição sem token retorna erro"""
    payload = {"topic": "finanças", "text": "Documento sem autenticação"}
    resp = requests.post(f"{BASE_URL}/add-doc", json=payload)
    assert resp.status_code == 401
