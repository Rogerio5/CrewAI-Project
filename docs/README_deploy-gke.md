# 🚀 Fluxo Completo de Deploy no Google Kubernetes Engine (GKE)

Este guia descreve todos os passos necessários para ativar a **Kubernetes Engine API**, criar um cluster GKE e colocar aplicações em produção de forma segura.

---

## 1. ✅ Pré-requisitos
- Conta Google autenticada no `gcloud`
- Projeto criado: `meuprojetocrewai`
- Google Cloud SDK instalado e funcionando no PowerShell
- `kubectl` instalado e configurado

---

## 2. 🔓 Ativar a Kubernetes Engine API
1. Acesse: [Ativar Kubernetes Engine API](https://console.developers.google.com/apis/api/container.googleapis.com?project=meuprojetocrewai)
2. Clique em **“Ativar”**
3. Se aparecer alerta de faturamento:
   - Clique em **“Ativar faturamento”**
   - Vincule uma conta de faturamento (pode usar créditos gratuitos)
4. Aguarde alguns minutos para a ativação propagar

---

## 3. ⚙️ Criar o cluster GKE
No terminal PowerShell, execute:

```powershell
gcloud container clusters create crewai-cluster `
  --zone=southamerica-east1-b `
  --num-nodes=3 `
  --machine-type=e2-medium `
  --enable-autoupgrade `
  --enable-autorepair
Cria um cluster com 3 nós pequenos, ideal para testes e produção leve.
```
---

### 4. 🔐 Conectar ao cluster
```bash
gcloud container clusters get-credentials crewai-cluster --zone southamerica-east1-b
```
Configura o kubectl para se comunicar com o cluster

---

### 5. 🧪 Testar conexão
bash```
kubectl get nodes
```
Se aparecerem os nós, está tudo pronto.
```

---
### 6. 🚚 Aplicar os manifests
```bash
kubectl apply -f k8s/
```
Sobe os serviços, deployments, ingress etc

---

### 7. 🛡️ Monitorar e escalar
```bash
Use o Console do Google Cloud para visualizar pods, serviços e métricas.

Configure autoscaling se necessário:
kubectl autoscale deployment seu-deployment --cpu-percent=50 --min=1 --max=5
```

---
### 8. 💰 Proteção contra cobranças
```bash
onfigure alertas de orçamento:

Acesse console.cloud.google.com/billing

Vá em Orçamento e alertas

Crie um alerta para não ultrapassar o limite mensal
```

---
### 9. 📌 Checklist rápido
```bash
[ ] Ativar Kubernetes Engine API

[ ] Vincular conta de faturamento (usar créditos gratuitos)

[ ] Criar cluster GKE

[ ] Conectar com kubectl

[ ] Testar com kubectl get nodes

[ ] Aplicar manifests (kubectl apply -f k8s/)

[ ] Configurar autoscaling

[ ] Criar alerta de orçamento
```

---
### 🔎 Observação
```bash
Ativar API ≠ cobrança automática

O free tier cobre um cluster pequeno por mês.

Só haverá custo se você escalar recursos além do limite gratuito.
```

---


