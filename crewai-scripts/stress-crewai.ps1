# Script de stress-test para CrewAI no Kubernetes
# Salve este arquivo como stress-crewai.ps1 na raiz do projeto

Write-Host "🔥 Iniciando stress-test da API e dos Agentes..." -ForegroundColor Red
Write-Host "Pressione CTRL + C para parar." -ForegroundColor Yellow

# Função para simular requisições em loop
function Invoke-StressTest {
    param (
        [string]$ServiceName,
        [int]$Port,
        [int]$Concurrency = 10
    )

    $svcIP = kubectl get svc $ServiceName -n crewai -o jsonpath="{.spec.clusterIP}"
    if (-not $svcIP) {
        Write-Host "❌ Serviço $ServiceName não encontrado." -ForegroundColor Red
        return
    }

    $url = "http://$svcIP:$Port/health"

    Write-Host "`n🚀 Iniciando stress-test em $ServiceName ($url)..." -ForegroundColor Cyan

    for ($i = 1; $i -le $Concurrency; $i++) {
        Start-Job -ScriptBlock {
            while ($true) {
                try {
                    Invoke-WebRequest -Uri $using:url -UseBasicParsing -TimeoutSec 2 | Out-Null
                } catch {
                    # Ignora erros de timeout
                }
            }
        } | Out-Null
    }
}

# Stress-test na API
Invoke-StressTest -ServiceName "crewai-api-service" -Port 80 -Concurrency 20

# Stress-test nos Agentes
Invoke-StressTest -ServiceName "crewai-agents-service" -Port 80 -Concurrency 20

Write-Host "`n🔥 Stress-test rodando em background. Use CTRL + C para parar." -ForegroundColor Red
Write-Host "📊 Monitore o HPA com: kubectl get hpa -n crewai --watch" -ForegroundColor Green
