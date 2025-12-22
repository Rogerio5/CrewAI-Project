import requests
import time

BASE_URL = "http://localhost:8000"

def get_token(username="admin", password="123"):
    print("\n🔐 Gerando token JWT...")
    resp = requests.post(
        f"{BASE_URL}/token",
        data={"username": username, "password": password},
        headers={"Content-Type": "application/x-www-form-urlencoded"}
    )
    resp.raise_for_status()
    token = resp.json()["access_token"]
    print("✅ Token gerado:", token)
    return token

def add_doc(token, topic, text):
    print("\n📄 Inserindo documento no Weaviate...")
    start = time.time()
    resp = requests.post(
        f"{BASE_URL}/add-doc",
        json={"topic": topic, "text": text},
        headers={"Authorization": f"Bearer {token}"}
    )
    if resp.status_code == 404:
        print("⚠️ Endpoint /add-doc não existe na API atual.")
        return
    resp.raise_for_status()
    elapsed = round(time.time() - start, 2)
    print("✅ Documento inserido:", resp.json(), f"(⏱️ {elapsed}s)")

def run_crew(token, topic, query):
    print("\n🤖 Executando RAG no endpoint /crew...")
    start = time.time()
    resp = requests.post(
        f"{BASE_URL}/crew",
        json={"topic": topic, "query": query},
        headers={"Authorization": f"Bearer {token}"}
    )
    resp.raise_for_status()
    elapsed = round(time.time() - start, 2)
    data = resp.json()
    print("✅ Execução RAG concluída:")
    print("   - Resultado:", data.get("result"))
    print("   - Run ID:", data.get("run_id"))
    print("   - Explicação:\n", data.get("explanation"))
    print(f"⏱️ Tempo de resposta: {elapsed}s")

def test_rate_limit(token):
    print("\n🚦 Testando Rate Limiting (/crew 6 vezes)...")
    headers = {"Authorization": f"Bearer {token}"}
    for i in range(1, 7):
        resp = requests.post(
            f"{BASE_URL}/crew",
            json={"topic": f"teste-{i}"},
            headers=headers
        )
        if resp.status_code == 429:
            print(f"[{i}] BLOQUEADO (Rate Limit)")
        else:
            print(f"[{i}] OK")

def get_metrics():
    print("\n📊 Consultando métricas Prometheus...")
    resp = requests.get(f"{BASE_URL}/metrics")
    resp.raise_for_status()
    print("✅ Métricas Prometheus:\n", resp.text)

def send_alert(token):
    print("\n🚨 Enviando alerta para Alertmanager...")
    resp = requests.post(
        f"{BASE_URL}/alert-webhook",
        json={
            "labels": {"alert": "HighCPU", "severity": "critical"},
            "annotations": {"description": "CPU acima de 90%"}
        },
        headers={"Authorization": f"Bearer {token}"}
    )
    resp.raise_for_status()
    print("✅ Alerta enviado:", resp.json())

if __name__ == "__main__":
    try:
        # 1. Gerar token
        token = get_token()

        # 2. Inserir documento (se existir endpoint /add-doc)
        add_doc(token, "finanças", "Relatório sobre mercado financeiro global")

        # 3. Executar RAG
        run_crew(token, "finanças", "Quais são os principais riscos do mercado financeiro?")

        # 4. Testar Rate Limiting
        test_rate_limit(token)

        # 5. Consultar métricas
        get_metrics()

        # 6. Disparar alerta
        send_alert(token)

        print("\n🎉 Fluxo de testes concluído com sucesso!")

    except requests.exceptions.RequestException as e:
        print("❌ Erro de requisição:", e)
    except Exception as e:
        print("❌ Erro inesperado:", e)
