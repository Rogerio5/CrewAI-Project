Write-Host "🔄 Resetando ChromaDB..."

# 1. Encerrar todos os processos Python
Write-Host "🛑 Encerrando processos Python..."
Get-Process python -ErrorAction SilentlyContinue | ForEach-Object {
    Stop-Process -Id $_.Id -Force
    Write-Host "Processo Python encerrado: $($_.Id)"
}

# 2. Apagar pasta data\chroma
$chromaPath = "data\chroma"
if (Test-Path $chromaPath) {
    Write-Host "🗑️ Removendo pasta $chromaPath..."
    Remove-Item -Recurse -Force $chromaPath
    Write-Host "✅ Pasta $chromaPath removida com sucesso."
} else {
    Write-Host "⚠️ Pasta $chromaPath não encontrada, nada para remover."
}

Write-Host "✨ Reset concluído. O PersistentClient vai recriar a pasta limpa ao iniciar a API."
