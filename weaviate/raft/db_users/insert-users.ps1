Write-Host "Inserindo usuários..."

# Substitua <ID_MARIA>, <ID_JOAO>, <ID_CARLOS> pelos IDs retornados no script anterior

curl.exe -X POST http://localhost:8080/v1/objects `
  -H "Content-Type: application/json" `
  -d "{ \"class\": \"User\", \"properties\": { \"nome\": \"Maria Oliveira\", \"email\": \"maria@example.com\", \"idade\": 25, \"documento\": [{ \"beacon\": \"weaviate://localhost/Document/<ID_MARIA>\" }] } }"

curl.exe -X POST http://localhost:8080/v1/objects `
  -H "Content-Type: application/json" `
  -d "{ \"class\": \"User\", \"properties\": { \"nome\": \"João Silva\", \"email\": \"joao@example.com\", \"idade\": 30, \"documento\": [{ \"beacon\": \"weaviate://localhost/Document/<ID_JOAO>\" }] } }"

curl.exe -X POST http://localhost:8080/v1/objects `
  -H "Content-Type: application/json" `
  -d "{ \"class\": \"User\", \"properties\": { \"nome\": \"Carlos Souza\", \"email\": \"carlos@example.com\", \"idade\": 40, \"documento\": [{ \"beacon\": \"weaviate://localhost/Document/<ID_CARLOS>\" }] } }"

Write-Host "Usuários inseridos."
