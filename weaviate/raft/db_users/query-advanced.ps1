Write-Host "Query avançada: usuários com idade > 30 e email contendo '@example.com'"

curl.exe -s -X POST http://localhost:8080/v1/graphql `
  -H "Content-Type: application/json" `
  -d "{ \"query\": \"{ Get { User(where: {operator: And, operands: [{path: [\\\"idade\\\"], operator: GreaterThan, valueInt: 30}, {path: [\\\"email\\\"], operator: Like, valueText: \\\"*example.com\\\"}]}) { nome email idade documento { ... on Document { text } } } } }\" }" `
  | Out-File -Encoding utf8 .\results\resultado-advanced.json

Write-Host "Resultado salvo em results/resultado-advanced.json"
