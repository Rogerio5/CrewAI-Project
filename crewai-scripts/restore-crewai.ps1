# Script de restore para CrewAI no Kubernetes
# Salve este arquivo como restore-crewai.ps1 na raiz do projeto

Write-Host "♻️ Iniciando restore dos PVCs (ChromaDB, MLflow, Grafana)..." -ForegroundColor Green

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

# Restore ChromaDB
Restore-PVC -SnapshotName "chroma-snapshot-YYYYMMDDHHmm" -PVCName "chroma-pvc" -Size "10Gi"

# Restore MLflow
Restore-PVC -SnapshotName "mlflow-snapshot-YYYYMMDDHHmm" -PVCName "mlflow-pvc" -Size "5Gi"

# Restore Grafana
Restore-PVC -SnapshotName "grafana-snapshot-YYYYMMDDHHmm" -PVCName "grafana-pvc" -Size "2Gi"

Write-Host "`n♻️ Restore concluído com sucesso!" -ForegroundColor Green
