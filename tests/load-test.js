import http from 'k6/http';
import { check, sleep } from 'k6';
import { Trend, Counter } from 'k6/metrics';

// 🔹 Métricas customizadas
let tempoResposta = new Trend('tempo_resposta');
let erros = new Counter('erros');

// 🔹 Configurações globais
export let options = {
  thresholds: {
    http_req_duration: ['p(95)<500'],     // 95% das requisições abaixo de 500ms
    http_req_failed: ['rate<0.01'],       // menos de 1% de falhas
    tempo_resposta: ['avg<300'],          // tempo médio abaixo de 300ms
    erros: ['count<10'],                  // menos de 10 erros totais
  },
  scenarios: {
    health_check: {
      executor: 'constant-vus',
      vus: 10,
      duration: '30s',
      exec: 'healthCheck',
    },
    listar_documentos: {
      executor: 'ramping-vus',
      startVUs: 5,
      stages: [
        { duration: '30s', target: 20 },
        { duration: '30s', target: 40 },
        { duration: '30s', target: 0 },
      ],
      exec: 'listDocuments',
    },
    criar_documento: {
      executor: 'per-vu-iterations',
      vus: 10,
      iterations: 5,
      exec: 'createDocument',
    },
  },
};

// 🔹 Cenário 1: Health Check
export function healthCheck() {
  let res = http.get('https://sua-api.com/health');
  tempoResposta.add(res.timings.duration);
  check(res, { 'status 200': (r) => r.status === 200 }) || erros.add(1);
  sleep(1);
}

// 🔹 Cenário 2: Listar documentos
export function listDocuments() {
  let res = http.get('https://sua-api.com/api/documents');
  tempoResposta.add(res.timings.duration);
  check(res, {
    'status 200': (r) => r.status === 200,
    'resposta contém lista': (r) => r.body.includes('documents'),
  }) || erros.add(1);
  sleep(1);
}

// 🔹 Cenário 3: Criar documento
export function createDocument() {
  let payload = JSON.stringify({
    title: `Teste-${__VU}-${Date.now()}`,
    content: 'Conteúdo gerado pelo teste de carga',
  });
  let headers = { 'Content-Type': 'application/json' };
  let res = http.post('https://sua-api.com/api/documents', payload, { headers });
  tempoResposta.add(res.timings.duration);
  check(res, { 'status 201': (r) => r.status === 201 }) || erros.add(1);
  sleep(1);
}
