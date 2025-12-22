Write-Host "Query básica: todos os usuários + documentos"

curl.exe -s -X POST http://localhost:8080/v1/graphql `
  -H "Content-Type: application/json" `
  -d "{ \"query\": \"{ Get { User { nome email idade documento { ... on Document { text } } } } }\" }" `
  | Out-File -Encoding utf8 .\results\resultado-basic.json

Write-Host "Resultado salvo em results/resultado-basic.json"
