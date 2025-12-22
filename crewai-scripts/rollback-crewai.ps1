# Script de rollback para CrewAI no Kubernetes
# Salve este arquivo como rollback-crewai.ps1 na raiz do projeto

Write-Host "⚠️ Iniciando rollback do CrewAI..." -ForegroundColor Yellow

# 1. Deletar todos os recursos dentro do namespace crewai
kubectl delete all --all -n crewai

# 2. Deletar PersistentVolumeClaims (PVCs)
kubectl delete pvc --all -n crewai

# 3. Deletar ConfigMaps e Secrets (se existirem)
kubectl delete configmap --all -n crewai
kubectl delete secret --all -n crewai

# 4. Deletar PodDisruptionBudgets
kubectl delete pdb --all -n crewai

# 5. Deletar o Ingress
kubectl delete ingress --all -n crewai

# 6. Finalmente, deletar o namespace
kubectl delete namespace crewai

Write-Host "`n✅ Rollback concluído. Todos os recursos do CrewAI foram removidos." -ForegroundColor Green
