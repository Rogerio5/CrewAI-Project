# Script de logs para CrewAI no Kubernetes
# Salve este arquivo como logs-crewai.ps1 na raiz do projeto

Write-Host "📜 Iniciando coleta de logs da API e dos Agentes..." -ForegroundColor Green
Write-Host "Pressione CTRL + C para parar." -ForegroundColor Yellow

# Função para coletar logs em tempo real
function Get-CrewAILogs {
    param (
        [string]$DeploymentName
    )

    $pods = kubectl get pods -n crewai -l app=$DeploymentName -o jsonpath="{.items[*].metadata.name}"
    foreach ($pod in $pods.Split(" ")) {
        Write-Host "`n📦 Logs do Pod: $pod" -ForegroundColor Cyan
        kubectl logs -f $pod -n crewai
    }
}

# Coletar logs da API
Get-CrewAILogs -DeploymentName "crewai-api"

# Coletar logs dos Agentes
Get-CrewAILogs -DeploymentName "crewai-agents"
