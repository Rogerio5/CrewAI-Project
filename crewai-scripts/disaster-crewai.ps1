# Script de disaster recovery para CrewAI no Kubernetes
# Salve este arquivo como disaster-crewai.ps1 na raiz do projeto

Write-Host "⚠️ Iniciando processo de Disaster Recovery do CrewAI..." -ForegroundColor Red

# Função para restaurar PVC a partir de snapshot
function Restore-PVC {
    param (
        [string]$SnapshotName,
        [string]$PVCName,
        [string]$StorageClass = "standard",
        [string]$Size = "5Gi"
    )

    Write-Host "`n📦 Restaurando PVC: $PVCName a partir do snapshot $SnapshotName" -ForegroundColor Cyan

    $yaml = @"
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $PVCName
  namespace: crewai
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: $StorageClass
  resources:
    requests:
      storage: $Size
  dataSource:
    name: $SnapshotName
    kind: VolumeSnapshot
    apiGroup: snapshot.storage.k8s.io
"@

    $yaml | kubectl apply -f -
    Write-Host "✅ PVC $PVCName restaurado a partir do snapshot $SnapshotName" -ForegroundColor Green
}

# Restaurar PVCs principais
Restore-PVC -SnapshotName "chroma-snapshot-YYYYMMDDHHmm" -PVCName "chroma-pvc" -Size "10Gi"
Restore-PVC -SnapshotName "mlflow-snapshot-YYYYMMDDHHmm" -PVCName "mlflow-pvc" -Size "5Gi"
Restore-PVC -SnapshotName "grafana-snapshot-YYYYMMDDHHmm" -PVCName "grafana-pvc" -Size "2Gi"

# Auto-healing: reinicia pods problemáticos
Write-Host "`n🛠️ Iniciando auto-healing dos Pods..." -ForegroundColor Yellow

while ($true) {
    $pods = kubectl get pods -n crewai --no-headers | Where-Object { ($_ -match "Error") -or ($_ -match "CrashLoopBackOff") -or ($_ -match "ImagePullBackOff") }

    if ($pods) {
        foreach ($line in $pods) {
            $podName = ($line -split "\s+")[0]
            Write-Host "`n⚠️ Pod com falha detectado: $podName" -ForegroundColor Red
            kubectl delete pod $podName -n crewai
            Write-Host "🔄 Pod $podName reiniciado automaticamente." -ForegroundColor Cyan
        }
    } else {
        Write-Host "✅ Nenhum pod com falha detectado." -ForegroundColor Green
    }

    Write-Host "`n⏳ Verificando novamente em 30 segundos..." -ForegroundColor Magenta
    Start-Sleep -Seconds 30
}
