# 🚀 Projeto CrewAI na Nuvem (Google Cloud)

Este README documenta o processo de implantação do projeto **CrewAI** na nuvem usando o **Google Cloud Platform (GCP)**, desde a criação inicial até a ativação em produção.

---

## 🧠 Visão Geral
O projeto foi criado inicialmente no **Minikube local** e depois estruturado para rodar na nuvem.  
Atualmente, o projeto `MeuProjetoCrewAI` já existe no GCP, mas está **parado** (sem recursos ativos).  
Quando ativado, ele usará **GKE (Google Kubernetes Engine)** para orquestração.

---

## 📌 Etapas já realizadas
- Criação da conta no Google Cloud com **US$ 300 de crédito grátis**  
- Criação do projeto `MeuProjetoCrewAI`  
- Publicação das imagens Docker no Docker Hub (`rogerio1994/...`)  
- Definição dos manifests Kubernetes:
  - Deployments
  - Services
  - Probes de saúde
  - PodDisruptionBudgets
  - Requests/Limits de CPU e memória
  - PVC para persistência (MLflow)

---

## 🚀 Ativação em Produção (quando decidir rodar)

### 1. Criar o cluster GKE
```bash
gcloud container clusters create crewai-cluster \
  --zone southamerica-east1-b \
  --num-nodes 3 \
  --machine-type e2-standard-2
```

---

### 2. Conectar `kubectl` ao cluster
```bash
gcloud container clusters get-credentials crewai-cluster \
  --zone southamerica-east1-b
```

---

### 3. Aplicar os manifests
```bash
kubectl create namespace crewai
kubectl apply -f k8s/
```

---

### 4. Configurar CI/CD
```bash
Build da imagem Docker

Push para Docker Hub

Deploy automático no GKE
```

---

### 5. Segurança
```bash
Usar Secrets para credenciais

Configurar RBAC para limitar permissões

Expor serviços via Ingress + TLS/HTTPS com cert-manager
```
---

### 6. Escalabilidade
```bash
Adicionar Horizontal Pod Autoscaler (HPA):
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: crewai-api-hpa
  namespace: crewai
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: crewai-api
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70

Monitorar com Prometheus + Grafana
```

---

### 7. Testes de carga
```bash
Usar Locust ou JMeter para validar latência e throughput

Ajustar HPA conforme resultados
```
📖 Observações
Este projeto está pronto para ser ativado a qualquer momento.
Enquanto não houver recursos ativos, não há cobrança automática.
A ativação pode ser feita conforme necessidade, aproveitando os créditos gratuitos.