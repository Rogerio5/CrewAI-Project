# Script de auditoria para CrewAI no Kubernetes
# Salve este arquivo como audit-crewai.ps1 na raiz do projeto

Write-Host "📋 Iniciando auditoria do cluster CrewAI..." -ForegroundColor Green

# Criar pasta de relatórios
$timestamp = Get-Date -Format "yyyyMMddHHmm"
$reportDir = "audit-report-$timestamp"
New-Item -ItemType Directory -Path $reportDir | Out-Null

# Função para salvar saída de comandos em arquivos
function Save-Report {
    param (
        [string]$Command,
        [string]$FileName
    )

    Write-Host "📝 Coletando: $FileName" -ForegroundColor Cyan
    Invoke-Expression $Command | Out-File "$reportDir\$FileName.txt"
}

# Coletar informações principais
Save-Report -Command "kubectl get pods -n crewai -o wide" -FileName "pods"
Save-Report -Command "kubectl get svc -n crewai -o wide" -FileName "services"
Save-Report -Command "kubectl get ingress -n crewai" -FileName "ingress"
Save-Report -Command "kubectl get pvc -n crewai" -FileName "pvcs"
Save-Report -Command "kubectl get hpa -n crewai" -FileName "hpa"
Save-Report -Command "kubectl get pdb -n crewai" -FileName "pdbs"
Save-Report -Command "kubectl get configmap -n crewai" -FileName "configmaps"
Save-Report -Command "kubectl get secret -n crewai" -FileName "secrets"

# Detalhes dos pods problemáticos
Write-Host "🔍 Coletando detalhes dos pods com erro..." -ForegroundColor Yellow
$pods = kubectl get pods -n crewai --no-headers | Where-Object { ($_ -match "Error") -or ($_ -match "CrashLoopBackOff") -or ($_ -match "ImagePullBackOff") }
foreach ($line in $pods) {
    $podName = ($line -split "\s+")[0]
    kubectl describe pod $podName -n crewai | Out-File "$reportDir\pod-$podName-describe.txt"
    kubectl logs $podName -n crewai --tail=100 | Out-File "$reportDir\pod-$podName-logs.txt"
}

Write-Host "`n✅ Auditoria concluída! Relatórios salvos em: $reportDir" -ForegroundColor Green
