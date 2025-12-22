# Script de métricas para CrewAI no Kubernetes
# Salve este arquivo como metrics-crewai.ps1 na raiz do projeto

Write-Host "📊 Iniciando coleta de métricas de CPU e memória dos Pods..." -ForegroundColor Green
Write-Host "Pressione CTRL + C para parar." -ForegroundColor Yellow

while ($true) {
    Clear-Host

    Write-Host "📦 Métricas dos Pods (CPU/Memória):" -ForegroundColor Cyan
    kubectl top pods -n crewai

    Write-Host "`n📦 Métricas dos Nodes (CPU/Memória):" -ForegroundColor Cyan
    kubectl top nodes

    Write-Host "`n📈 Status do HPA:" -ForegroundColor Cyan
    kubectl get hpa -n crewai

    Write-Host "`n⏳ Atualizando a cada 10 segundos..." -ForegroundColor Magenta
    Start-Sleep -Seconds 10
}
