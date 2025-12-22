# Script de redeploy para CrewAI no Kubernetes
# Salve este arquivo como redeploy-crewai.ps1 na raiz do projeto

Write-Host "♻️ Iniciando REDEPLOY do CrewAI..." -ForegroundColor Yellow

# 1. Rollback completo (limpa todos os recursos)
Write-Host "`n⚠️ Limpando recursos antigos..." -ForegroundColor Red
kubectl delete all --all -n crewai
kubectl delete pvc --all -n crewai
kubectl delete configmap --all -n crewai
kubectl delete secret --all -n crewai
kubectl delete pdb --all -n crewai
kubectl delete ingress --all -n crewai
kubectl delete namespace crewai

# 2. Criar novamente o namespace
Write-Host "`n📂 Criando namespace crewai..." -ForegroundColor Cyan
kubectl apply -f k8s/namespace.yaml

# 3. Aplicar todos os manifests
Write-Host "`n🚀 Aplicando manifests da pasta k8s/..." -ForegroundColor Green
kubectl apply -f k8s/

# 4. Mostrar status dos pods
Write-Host "`n📦 Status dos Pods:" -ForegroundColor Cyan
kubectl get pods -n crewai

# 5. Mostrar status dos serviços
Write-Host "`n🔌 Serviços disponíveis:" -ForegroundColor Cyan
kubectl get svc -n crewai

# 6. Mostrar ingress
Write-Host "`n🌐 Ingress configurado:" -ForegroundColor Cyan
kubectl get ingress -n crewai

# 7. Mostrar PodDisruptionBudgets
Write-Host "`n🛡️ PodDisruptionBudgets:" -ForegroundColor Cyan
kubectl get pdb -n crewai

Write-Host "`n✅ Redeploy concluído com sucesso!" -ForegroundColor Green
