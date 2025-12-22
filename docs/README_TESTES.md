# MLOPSSTOCKCREWAI - Infraestrutura, CI/CD e Testes de Carga

Este projeto integra práticas de **MLOps**, **CI/CD** e **testes de carga** para garantir qualidade, escalabilidade e observabilidade em produção.

---

## 🚀 CI/CD Pipeline

### 📄 Arquivo: `.github/workflows/ci-cd.yml`
- **Pull Request** → roda testes unitários com `pytest`.
- **Push na main** → roda testes, build da imagem Docker e deploy no Render.
- **Secrets necessários**:
  - `DOCKERHUB_USERNAME` → usuário DockerHub.
  - `DOCKERHUB_TOKEN` → token DockerHub.
  - `RENDER_API_KEY` → chave da API Render.
  - `RENDER_SERVICE_ID` → ID do serviço Render.

### 📄 Arquivo: `.github/workflows/load-test.yml`
- Executa testes de carga com **k6**.
- Gera relatórios:
  - `results/output.json` → dados brutos.
  - `results/summary.json` → resumo estatístico.
  - `results/report.html` → relatório visual com gráficos.
- Faz upload dos relatórios como artefatos.
- **Agendamentos configurados**:
  - `*/30 8-20 * * *` → contínuo, a cada 30 min em horário comercial.
  - `0 10 * * 1` → regressivo, toda segunda às 10h.

---

## 📊 Testes de Carga (k6)

### Relatórios
- `report.html` → relatório visual com gráficos de latência, throughput e erros.
- `summary.json` → resumo estatístico (p95, média, taxa de falhas).
- `output.json` → dados brutos para análise avançada.

### Thresholds definidos
- Latência p95 < **500ms**
- Taxa de erro < **1%**
- Tempo médio < **300ms**

### Interpretação
- Se **thresholds forem violados** → pipeline marca como falha.
- Se **latência subir** → ajustar réplicas via HPA.
- Se **taxa de erro aumentar** → investigar logs e aplicar rollback.

---

## 📈 Estratégia de Testes de Carga

- **Contínuos (*/30 8-20 * * *)**
  - Garantem que a API se mantém estável durante o dia.
  - Útil para detectar degradações em tempo real.

- **Regressivos (0 10 * * 1)**
  - Executados semanalmente.
  - Validam se mudanças recentes não quebraram performance.
  - Se falhar → rollback automático ou alerta para equipe.

---

## 🛠️ CI/CD integrado ao Kubernetes

Além do deploy no Render, o pipeline pode aplicar os manifests no Kubernetes:

```yaml
deploy-k8s:
  name: Deploy to Kubernetes
  needs: build
  runs-on: ubuntu-latest
  if: github.ref == 'refs/heads/main'
  steps:
    - name: Checkout código
      uses: actions/checkout@v4

    - name: Configurar kubectl
      run: |
        echo "${{ secrets.KUBE_CONFIG }}" > kubeconfig.yaml
        export KUBECONFIG=kubeconfig.yaml

    - name: Aplicar manifests
      run: |
        kubectl apply -f k8s/

Secrets necessários:

KUBE_CONFIG → arquivo de configuração do cluster Kubernetes