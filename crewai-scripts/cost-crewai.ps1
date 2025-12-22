# Script de cost-analysis para CrewAI no Kubernetes
# Salve este arquivo como cost-crewai.ps1 na raiz do projeto

Write-Host "💰 Iniciando análise de custos do cluster CrewAI..." -ForegroundColor Green

# Criar pasta de relatórios
$timestamp = Get-Date -Format "yyyyMMddHHmm"
$reportDir = "cost-report-$timestamp"
New-Item -ItemType Directory -Path $reportDir | Out-Null

# Preços estimados (ajuste conforme seu provedor cloud)
$cpuPricePerCoreHour = 0.05   # USD por core/hora
$memPricePerGBHour   = 0.01   # USD por GB/hora
$storagePricePerGBMonth = 0.10 # USD por GB/mês

# Função para calcular custo de pods
function Calculate-PodCost {
    $pods = kubectl get pods -n crewai -o json | ConvertFrom-Json
    foreach ($pod in $pods.items) {
        $podName = $pod.metadata.name
        foreach ($container in $pod.spec.containers) {
            $cpu = $container.resources.requests.cpu
            $mem = $container.resources.requests.memory

            if ($cpu -and $mem) {
                $cpuCores = [double]($cpu -replace "m","") / 1000
                $memGB = [double]($mem -replace "Mi","") / 1024

                $cpuCostHour = $cpuCores * $cpuPricePerCoreHour
                $memCostHour = $memGB * $memPricePerGBHour
                $totalCostHour = $cpuCostHour + $memCostHour

                Add-Content "$reportDir\pods-cost.txt" "Pod $podName → CPU: $cpuCores cores, Mem: $memGB GB → ~$($totalCostHour.ToString("F4")) USD/h"
            }
        }
    }
}

# Função para calcular custo de storage
function Calculate-StorageCost {
    $pvcs = kubectl get pvc -n crewai -o json | ConvertFrom-Json
    foreach ($pvc in $pvcs.items) {
        $pvcName = $pvc.metadata.name
        $size = $pvc.spec.resources.requests.storage
        $sizeGB = [double]($size -replace "Gi","")

        $costMonth = $sizeGB * $storagePricePerGBMonth
        Add-Content "$reportDir\storage-cost.txt" "PVC $pvcName → $sizeGB GB → ~$($costMonth.ToString("F2")) USD/mês"
    }
}

# Executar cálculos
Calculate-PodCost
Calculate-StorageCost

Write-Host "`n✅ Cost-analysis concluído! Relatórios salvos em: $reportDir" -ForegroundColor Green
