# Teste completo do Chromadb (Weaviate) dentro do cluster CrewAI
# Etapas: Criar schema -> Inserir objeto -> Consultar objetos -> Validar schema

# 1. Criar schema (classe Document)
Write-Host ">>> Criando schema Document..."
kubectl exec -it crewai-api-b55fc9cc9-bslfq -n crewai -- curl.exe -X POST `
-H "Content-Type: application/json" -H "Host: localhost" `
-d "{\"classes\":[{\"class\":\"Document\",\"description\":\"Classe para armazenar textos\",\"vectorizer\":\"none\",\"properties\":[{\"name\":\"text\",\"dataType\":[\"string\"]}]}]}" `
http://chromadb-service/v1/schema

# 2. Inserir objeto na classe Document
Write-Host ">>> Inserindo objeto na classe Document..."
kubectl exec -it crewai-api-b55fc9cc9-bslfq -n crewai -- curl.exe -X POST `
-H "Content-Type: application/json" -H "Host: localhost" `
-d "{\"class\":\"Document\",\"properties\":{\"text\":\"Olá CrewAI, testando Chromadb!\"}}" `
http://chromadb-service/v1/objects

# 3. Consultar objetos existentes
Write-Host ">>> Consultando objetos..."
kubectl exec -it crewai-api-b55fc9cc9-bslfq -n crewai -- curl.exe -H "Host: localhost" http://chromadb-service/v1/objects

# 4. Validar schema criado
Write-Host ">>> Validando schema..."
kubectl exec -it crewai-api-b55fc9cc9-bslfq -n crewai -- curl.exe -H "Host: localhost" http://chromadb-service/v1/schema
