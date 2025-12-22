Write-Host "Inserindo documentos..."

# Maria
$maria = curl.exe -s -X POST http://localhost:8080/v1/objects `
  -H "Content-Type: application/json" `
  -d "{ \"class\": \"Document\", \"properties\": { \"text\": \"Maria Oliveira, 25 anos, email: maria@example.com\" } }"

# João
$joao = curl.exe -s -X POST http://localhost:8080/v1/objects `
  -H "Content-Type: application/json" `
  -d "{ \"class\": \"Document\", \"properties\": { \"text\": \"João Silva, 30 anos, email: joao@example.com\" } }"

# Carlos
$carlos = curl.exe -s -X POST http://localhost:8080/v1/objects `
  -H "Content-Type: application/json" `
  -d "{ \"class\": \"Document\", \"properties\": { \"text\": \"Carlos Souza, 40 anos, email: carlos@example.com\" } }"

Write-Host "Documentos inseridos."
