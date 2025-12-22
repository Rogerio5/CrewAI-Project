# Script de deploy para CrewAI no Kubernetes
# Salve este arquivo como deploy-crewai.ps1 na raiz do projeto

Write-Host "🚀 Iniciando deploy do CrewAI no Kubernetes..." -ForegroundColor Green

# 1. Criar/atualizar namespace
kubectl apply -f k8s/namespace.yaml

# 2. Aplicar todos os manifests
kubectl apply -f k8s/

# 3. Mostrar status dos pods
Write-Host "`n📦 Status dos Pods:" -ForegroundColor Cyan
kubectl get pods -n crewai

# 4. Mostrar status dos serviços
Write-Host "`n🔌 Serviços disponíveis:" -ForegroundColor Cyan
kubectl get svc -n crewai

# 5. Mostrar ingress
Write-Host "`n🌐 Ingress configurado:" -ForegroundColor Cyan
kubectl get ingress -n crewai

# 6. Mostrar PodDisruptionBudgets
Write-Host "`n🛡️ PodDisruptionBudgets:" -ForegroundColor Cyan
kubectl get pdb -n crewai

Write-Host "`n✅ Deploy concluído com sucesso!" -ForegroundColor Green
