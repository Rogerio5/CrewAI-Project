# Script de monitoramento para CrewAI no Kubernetes
# Salve este arquivo como monitor-crewai.ps1 na raiz do projeto

Write-Host "📡 Iniciando monitoramento do CrewAI..." -ForegroundColor Green
Write-Host "Pressione CTRL + C para parar." -ForegroundColor Yellow

while ($true) {
    Clear-Host

    Write-Host "📦 Status dos Pods:" -ForegroundColor Cyan
    kubectl get pods -n crewai

    Write-Host "`n🔌 Serviços disponíveis:" -ForegroundColor Cyan
    kubectl get svc -n crewai

    Write-Host "`n🌐 Ingress configurado:" -ForegroundColor Cyan
    kubectl get ingress -n crewai

    Write-Host "`n🛡️ PodDisruptionBudgets:" -ForegroundColor Cyan
    kubectl get pdb -n crewai

    Write-Host "`n⏳ Atualizando a cada 10 segundos..." -ForegroundColor Magenta
    Start-Sleep -Seconds 10
}
