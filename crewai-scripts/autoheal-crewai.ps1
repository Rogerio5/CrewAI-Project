# Script de auto-healing para CrewAI no Kubernetes
# Salve este arquivo como autoheal-crewai.ps1 na raiz do projeto

Write-Host "🛠️ Iniciando auto-healing dos Pods no namespace crewai..." -ForegroundColor Green
Write-Host "Pressione CTRL + C para parar." -ForegroundColor Yellow

while ($true) {
    # Obter lista de pods com status não saudável
    $pods = kubectl get pods -n crewai --no-headers | Where-Object { ($_ -match "Error") -or ($_ -match "CrashLoopBackOff") -or ($_ -match "ImagePullBackOff") }

    if ($pods) {
        foreach ($line in $pods) {
            $podName = ($line -split "\s+")[0]
            Write-Host "`n⚠️ Pod com falha detectado: $podName" -ForegroundColor Red

            # Deletar pod problemático para forçar recriação
            kubectl delete pod $podName -n crewai
            Write-Host "🔄 Pod $podName reiniciado automaticamente." -ForegroundColor Cyan
        }
    } else {
        Write-Host "✅ Nenhum pod com falha detectado." -ForegroundColor Green
    }

    Write-Host "`n⏳ Verificando novamente em 30 segundos..." -ForegroundColor Magenta
    Start-Sleep -Seconds 30
}
