# 🤖 Projeto CrewAI

Este repositório reúne a implementação do **CrewAI**, incluindo configuração de ambiente Python, integração com Google Cloud SDK, Kubernetes, CI/CD automatizado com GitHub Actions e documentação completa para deploy em nuvem.  

![Capa do Projeto](https://copilot.microsoft.com/th/id/BCO.12345678-crew-ai-cover.png)

---

## 🏅 Badges

- 📦 Tamanho do repositório / Repository Size:  
  ![GitHub repo size](https://img.shields.io/github/repo-size/seuusuario/Projeto-CrewAI)

- 📄 Licença do projeto / Project License:  
  ![GitHub license](https://img.shields.io/github/license/seuusuario/Projeto-CrewAI)

- 🛠️ Status:  
  ![Status](https://img.shields.io/badge/status-finalizado-green)

---

## 📋 Índice / Table of Contents

- [Descrição / Description](#descrição--description)  
- [Status / Status](#status--status)  
- [Funcionalidades / Features](#funcionalidades--features)  
- [Estrutura do Projeto / Project-Structure](#estrutura-do-projeto--project-structure)  
- [Tecnologias / Technologies](#tecnologias--technologies)  
- [Execução / Run](#execução--run)  
- [CI/CD Pipeline](#cicd-pipeline)  
- [Testes de Carga](#testes-de-carga)  
- [Resultados e Visualizações / Results--visuals](#resultados-e-visualizações--results--visuals)  
- [Possíveis Melhorias Futuras / Future-Improvements](#possíveis-melhorias-futuras--future-improvements)  
- [Desenvolvedor / Developer](#desenvolvedor--developer)  
- [Licença / License](#licença--license)  
- [Conclusão / Conclusion](#conclusão--conclusion)  

---

## 📖 Descrição / Description

**PT:**  
O projeto **CrewAI** foi desenvolvido para demonstrar práticas modernas de deploy em nuvem, CI/CD e orquestração com Kubernetes. Inclui:  
- Ambiente Python isolado (`crewai-env`).  
- Configuração do Google Cloud SDK (`gcloud`) e `kubectl`.  
- Manifests Kubernetes (`k8s/`) prontos para deploy.  
- Pipeline CI/CD com GitHub Actions (build, testes, Docker, Render e Kubernetes).  
- Testes de carga automatizados (`load-test.yml`).  

**EN:**  
The **CrewAI** project demonstrates modern cloud deployment practices, CI/CD automation, and Kubernetes orchestration. It includes:  
- Isolated Python environment (`crewai-env`).  
- Google Cloud SDK (`gcloud`) and `kubectl` setup.  
- Kubernetes manifests (`k8s/`) ready for deployment.  
- CI/CD pipeline with GitHub Actions (build, tests, Docker, Render, and Kubernetes).  
- Automated load testing (`load-test.yml`).  

---

## 🚧 Status / Status

✅ **Finalizado e pronto para produção** / **Completed and production-ready**  
Deploy real em nuvem é **opcional** e pode ser feito futuramente.

---

## ⚙️ Funcionalidades / Features

| 🧩 Funcionalidade (PT)                  | 💡 Description (EN)                       |
|-----------------------------------------|-------------------------------------------|
| 🐍 Ambiente Python isolado              | 🐍 Isolated Python environment            |
| ☁️ Google Cloud SDK configurado          | ☁️ Google Cloud SDK configured            |
| 📦 Manifests Kubernetes (`k8s/`)        | 📦 Kubernetes manifests ready             |
| 🔄 CI/CD com GitHub Actions             | 🔄 CI/CD pipeline with GitHub Actions      |
| 🐳 Build e push de imagem Docker        | 🐳 Docker image build and push            |
| 🚀 Deploy automático no Render          | 🚀 Automatic deploy to Render             |
| ⚙️ Deploy em Kubernetes (opcional)      | ⚙️ Kubernetes deploy (optional)           |
| 📊 Testes de carga (`load-test.yml`)    | 📊 Load testing automation                |

---

## 📂 Estrutura do Projeto / Project Structure

Este projeto foi desenvolvido com foco em MLOps, orquestração com Kubernetes, deploy em nuvem e automação via CI/CD. Abaixo está a estrutura completa do repositório com comentários sobre cada pasta e arquivo:
```
MEUPROJETOCREWAI/
├── pycache/                  # Cache de compilação Python
├── .github/                     # Workflows do GitHub Actions (CI/CD e testes de carga)
│   ├── ci-cd.yml                 # Pipeline CI/CD completo (testes, build, deploy)
│   └── load-test.yml             # Testes de carga automatizados
├── .pytest_cache/               # Cache de testes Pytest
├── api/                         # Endpoints da API (FastAPI ou Flask)
├── artifacts/                   # Artefatos gerados (modelos, logs, etc.)
├── chromadb/                    # Integração com ChromaDB (vector store)
├── crewai/                      # Núcleo da aplicação CrewAI
├── crewai_agent.egg-info/       # Metadados do pacote Python
├── crewai-env/                  # Ambiente virtual Python
├── crewai-scripts/              # Scripts auxiliares para agentes e tarefas
├── data/                        # Dados brutos ou pré-processados
├── dist/                        # Distribuição do pacote (build local)
├── k8s/                         # Manifests Kubernetes para deploy
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── mlflow/                      # Configuração e tracking com MLflow
├── mlops/                       # Pipelines e automações MLOps
├── mlruns/                      # Experimentos salvos do MLflow
├── observability/               # Logs, métricas e monitoramento
├── scripts/                     # Scripts utilitários e de setup
├── tests/                       # Testes unitários e de integração
├── weaviate/                    # Integração com Weaviate (vector DB)
├── web/                         # Interface web (HTML/Bootstrap ou frontend)
│
├── .dockerignore                # Arquivos ignorados no build Docker
├── .gitignore                   # Arquivos ignorados pelo Git
├── .pypirc                      # Configuração de publicação PyPI
├── docker-compose.yml            # Orquestração local com Docker Compose
├── Dockerfile                   # Build da imagem Docker
├── get-pip.py                    # Script de instalação do pip
├── MANIFEST.in                   # Inclusão de arquivos no pacote Python
│
├── mlflow.db                     # Banco local do MLflow
├── publish-crewai-images.ps1    # Script para publicar imagens Docker
├── pyproject.toml                # Configuração do projeto Python
├── requirements.txt              # Dependências principais
├── requirements-agents.txt       # Dependências específicas dos agentes
├── setup_nltk.py                # Setup de pacotes NLTK
│
├── test_api.py                  # Testes da API
├── test_endpoints.py            # Testes de rotas
├── test_metrics.py              # Testes de métricas
├── test-chromadb.ps1            # Teste de integração com ChromaDB
├── tests.http                    # Testes de endpoints HTTP
│
├── README.md                     # Documentação principal
├── README_deploy-gke.md         # Guia de deploy no GKE
├── README_NUVEM.md              # Guia de deploy em nuvem
├── README_TESTES.md             # Guia de testes
├── README-FINALIZAÇÃO.md        # Encerramento do projeto
```
---

## 🧰 Tecnologias / Technologies

# 🤖 MEUPROJETOCREWAI

<p align="center">
  <img src="https://img.shields.io/badge/Python-3.11-blue?logo=python" />
  <img src="https://img.shields.io/badge/Docker-ready-blue?logo=docker" />
  <img src="https://img.shields.io/badge/Kubernetes-deploy-green?logo=kubernetes" />
  <img src="https://img.shields.io/badge/CI/CD-GitHub_Actions-yellow?logo=githubactions" />
  <img src="https://img.shields.io/badge/MLflow-tracking-orange?logo=mlflow" />
</p>

<p align="center">
  <img src="https://copilot.microsoft.com/th/id/BCO.crew-ai-cover.png" alt="Capa do Projeto CrewAI" width="800"/>
</p>

---

## 🚀 Projeto CrewAI
**MEUPROJETOCREWAI** é um projeto completo de MLOps e Cloud Deploy, integrando:
- Python 🐍  
- Docker 🐳  
- Kubernetes ☸️  
- MLflow 📊  
- CI/CD com GitHub Actions 🔄  

Documentação completa disponível em [`docs/`](docs/).

---

## ▶️ Execução / Run

### Local
```bash
python src/main.py
```
---

## Kubernetes (opcional)
```
kubectl apply -f k8s/
kubectl get pods
```

---

## 🔄 CI/CD Pipeline
```
O arquivo ci-cd.yml define o pipeline completo:

Testes com Pytest e NLTK.

Build Docker e push para DockerHub.

Deploy automático no Render.

Deploy opcional em Kubernetes via kubectl apply -f k8s/
```

## 📊 Testes de Carga

O arquivo load-test.yml permite rodar testes de carga automatizados para validar desempenho e escalabilidade.
Exemplo de execução:
```
k6 run load-test.yml
```

---

## 📈 Resultados e Visualizações / Results & Visuals

✔️ Testes unitários executados com sucesso.
✔️ Build Docker publicado no DockerHub.
✔️ Deploy automático no Render concluído.
✔️ Manifests Kubernetes aplicados (opcional).
✔️ Testes de carga validados.

---

## 🔮 Possíveis Melhorias Futuras / Future Improvements

Integração com monitoramento Prometheus/Grafana.
Autoscaling configurado no cluster Kubernetes.
Segurança avançada com RBAC e secrets.
Pipeline CI/CD expandido para múltiplos ambientes.

---

## 👨‍💻 Pessoa Desenvolvedor do Projeto / Project Developer

- [Rogerio](https://github.com/Rogerio5)
- [Ronaldo](https://github.com/Ronaldo94-GITHUB)

---

## 📜 Licença / License
Este projeto está sob licença MIT. Para mais detalhes, veja o arquivo LICENSE.

This project is under the MIT license. For more details, see the LICENSE file

---

## 🏁 Conclusão / Conclusion

O projeto CrewAI demonstra práticas modernas de desenvolvimento e deploy em nuvem, CI/CD automatizado e orquestração com Kubernetes.
Está finalizado e pronto para produção, com documentação clara e pipelines configurados.
O deploy real em nuvem é opcional e pode ser realizado futuramente conforme necessidade
