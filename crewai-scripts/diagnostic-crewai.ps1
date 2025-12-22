# Script de diagnóstico para CrewAI no Kubernetes
# Salve este arquivo como diagnostic-crewai.ps1 na raiz do projeto

Write-Host "🩺 Iniciando diagnóstico dos Pods com erro no namespace crewai..." -ForegroundColor Green

# Obter lista de pods com status não saudável
$pods = kubectl get pods -n crewai --no-headers | Where-Object { ($_ -match "Error") -or ($_ -match "CrashLoopBackOff") -or ($_ -match "ImagePullBackOff") }

if (-not $pods) {
    Write-Host "✅ Nenhum pod com erro encontrado." -ForegroundColor Green
    exit
}

foreach ($line in $pods) {
    $podName = ($line -split "\s+")[0]
    Write-Host "`n📦 Diagnosticando Pod: $podName" -ForegroundColor Cyan

    # Descrever pod
    Write-Host "🔍 Descrição do Pod:" -ForegroundColor Yellow
    kubectl describe pod $podName -n crewai

    # Coletar logs
    Write-Host "`n📜 Logs do Pod:" -ForegroundColor Yellow
    kubectl logs $podName -n crewai --tail=50
}
