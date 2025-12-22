# Script de benchmark para CrewAI no Kubernetes
# Salve este arquivo como benchmark-crewai.ps1 na raiz do projeto

Write-Host "📊 Iniciando benchmark da API e dos Agentes..." -ForegroundColor Green

function Benchmark-Service {
    param (
        [string]$ServiceName,
        [int]$Port,
        [int]$Requests = 50
    )

    $svcIP = kubectl get svc $ServiceName -n crewai -o jsonpath="{.spec.clusterIP}"
    if (-not $svcIP) {
        Write-Host "❌ Serviço $ServiceName não encontrado." -ForegroundColor Red
        return
    }

    $url = "http://$svcIP:$Port/health"
    Write-Host "`n🚀 Benchmark em $ServiceName ($url)" -ForegroundColor Cyan

    $times = @()

    for ($i = 1; $i -le $Requests; $i++) {
        $start = Get-Date
        try {
            Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5 | Out-Null
            $end = Get-Date
            $elapsed = ($end - $start).TotalMilliseconds
            $times += $elapsed
            Write-Host "✔️ Request $i: $elapsed ms" -ForegroundColor Green
        } catch {
            Write-Host "❌ Request $i falhou" -ForegroundColor Red
        }
    }

    if ($times.Count -gt 0) {
        $avg = [math]::Round(($times | Measure-Object -Average).Average,2)
        $max = [math]::Round(($times | Measure-Object -Maximum).Maximum,2)
        $min = [math]::Round(($times | Measure-Object -Minimum).Minimum,2)

        Write-Host "`n📊 Resultados para $ServiceName:" -ForegroundColor Yellow
        Write-Host "   ➡️ Média: $avg ms"
        Write-Host "   ➡️ Máximo: $max ms"
        Write-Host "   ➡️ Mínimo: $min ms"
    }
}

# Benchmark na API
Benchmark-Service -ServiceName "crewai-api-service" -Port 80 -Requests 50

# Benchmark nos Agentes
Benchmark-Service -ServiceName "crewai-agents-service" -Port 80 -Requests 50

Write-Host "`n✅ Benchmark concluído!" -ForegroundColor Green
