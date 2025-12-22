Write-Host "=== Fluxo completo automatizado ==="

Write-Host "1. Aplicando schema..."
curl.exe -X POST http://localhost:8080/v1/schema `
  -H "Content-Type: application/json" `
  -d "@schema.json"

Write-Host "2. Inserindo documentos..."
.\insert-documents.ps1

Write-Host "3. Inserindo usuários..."
.\insert-users.ps1

Write-Host "4. Rodando query básica..."
.\query-basic.ps1

Write-Host "5. Rodando query avançada..."
.\query-advanced.ps1

Write-Host "=== Finalizado. Resultados salvos em db_users/results ==="
