# Script de scaling-test para CrewAI no Kubernetes
# Salve este arquivo como scaling-crewai.ps1 na raiz do projeto

Write-Host "📈 Iniciando teste de escalabilidade do CrewAI..." -ForegroundColor Green

# Função para simular carga
function Simulate-Load {
    param (
        [string]$ServiceName,
        [int]$Port,
        [int]$Concurrency = 20,
        [int]$DurationSec = 60
    )

    $svcIP = kubectl get svc $ServiceName -n crewai -o jsonpath="{.spec.clusterIP}"
    if (-not $svcIP) {
        Write-Host "❌ Serviço $ServiceName não encontrado." -ForegroundColor Red
        return
    }

    $url = "http://$svcIP:$Port/health"
    Write-Host "`n🚀 Simulando carga em $ServiceName ($url) por $DurationSec segundos..." -ForegroundColor Cyan

    $jobs = @()
    for ($i = 1; $i -le $Concurrency; $i++) {
        $jobs += Start-Job -ScriptBlock {
            $endTime = (Get-Date).AddSeconds($using:DurationSec)
            while ((Get-Date) -lt $endTime) {
                try {
                    Invoke-WebRequest -Uri $using:url -UseBasicParsing -TimeoutSec 2 | Out-Null
                } catch {
                    # Ignora erros
                }
            }
        }
    }

    # Esperar todos os jobs terminarem
    $jobs | ForEach-Object { $_ | Wait-Job | Remove-Job }
    Write-Host "✅ Carga simulada concluída para $ServiceName" -ForegroundColor Green
}

# 1. Escalar para cima (simular alta carga)
Simulate-Load -ServiceName "crewai-api-service" -Port 80 -Concurrency 50 -DurationSec 120
Simulate-Load -ServiceName "crewai-agents-service" -Port 80 -Concurrency 50 -DurationSec 120

Write-Host "`n📊 Verifique o HPA escalando para cima com:" -ForegroundColor Yellow
Write-Host "   kubectl get hpa -n crewai --watch" -ForegroundColor Cyan

# 2. Pausa para estabilizar
Write-Host "`n⏳ Aguardando 2 minutos para estabilização..." -ForegroundColor Magenta
Start-Sleep -Seconds 120

# 3. Escalar para baixo (sem carga)
Write-Host "`n🔽 Agora sem carga, o HPA deve reduzir réplicas automaticamente." -ForegroundColor Cyan
Write-Host "📊 Continue monitorando com: kubectl get hpa -n crewai --watch" -ForegroundColor Yellow
