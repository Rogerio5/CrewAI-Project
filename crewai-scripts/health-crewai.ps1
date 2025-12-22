# Script de health-check para CrewAI no Kubernetes
# Salve este arquivo como health-crewai.ps1 na raiz do projeto

Write-Host "🩺 Iniciando health-check da API e dos Agentes..." -ForegroundColor Green

# Função para testar endpoints
function Test-Endpoint {
    param (
        [string]$ServiceName,
        [int]$Port
    )

    $svcIP = kubectl get svc $ServiceName -n crewai -o jsonpath="{.spec.clusterIP}"
    if (-not $svcIP) {
        Write-Host "❌ Serviço $ServiceName não encontrado." -ForegroundColor Red
        return
    }

    $healthUrl = "http://$svcIP:$Port/health"
    $readyUrl  = "http://$svcIP:$Port/ready"

    Write-Host "`n📦 Testando $ServiceName..." -ForegroundColor Cyan

    try {
        $healthResponse = Invoke-WebRequest -Uri $healthUrl -UseBasicParsing -TimeoutSec 5
        Write-Host "✅ /health respondeu com status $($healthResponse.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Falha ao acessar /health em $ServiceName" -ForegroundColor Red
    }

    try {
        $readyResponse = Invoke-WebRequest -Uri $readyUrl -UseBasicParsing -TimeoutSec 5
        Write-Host "✅ /ready respondeu com status $($readyResponse.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Falha ao acessar /ready em $ServiceName" -ForegroundColor Red
    }
}

# Testar API
Test-Endpoint -ServiceName "crewai-api-service" -Port 80

# Testar Agentes
Test-Endpoint -ServiceName "crewai-agents-service" -Port 80

Write-Host "`n🩺 Health-check concluído!" -ForegroundColor Green
