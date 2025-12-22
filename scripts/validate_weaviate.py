import weaviate

# Conecta ao serviço Weaviate (suba com docker-compose antes)
client = weaviate.Client("http://localhost:8080")

# 1. Cria schema simples (se não existir)
class_obj = {
    "class": "Document",
    "properties": [
        {"name": "topic", "dataType": ["text"]},
        {"name": "text", "dataType": ["text"]}
    ]
}

# Evita recriar se já existe
schema = client.schema.get()
if not any(c["class"] == "Document" for c in schema["classes"]):
    client.schema.create_class(class_obj)
    print("✅ Classe 'Document' criada no Weaviate")
else:
    print("ℹ️ Classe 'Document' já existe")

# 2. Insere documentos
docs = [
    {"topic": "finanças", "text": "Relatório sobre mercado financeiro global"},
    {"topic": "IA", "text": "Tendências em inteligência artificial para 2026"}
]

for i, doc in enumerate(docs, start=1):
    client.data_object.create(doc, "Document")
    print(f"✅ Documento {i} inserido:", doc)

# 3. Faz uma busca contextual
query = "Quais são os principais riscos do mercado financeiro?"
res = client.query.get("Document", ["topic", "text"]).with_near_text({"concepts": [query]}).with_limit(2).do()

print("\n🔎 Resultado da busca:")
for item in res["data"]["Get"]["Document"]:
    print(f"- Tópico: {item['topic']}")
    print(f"  Texto: {item['text']}\n")
