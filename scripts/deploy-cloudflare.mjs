import { readFile } from 'node:fs/promises';

const token = process.env.CLOUDFLARE_API_TOKEN;
const accountId = process.env.CLOUDFLARE_ACCOUNT_ID;
const workerName = 'ege-gfm-2027';
if (!token || !accountId) throw new Error('Configurer les secrets GitHub CLOUDFLARE_API_TOKEN et CLOUDFLARE_ACCOUNT_ID.');
const html = await readFile(new URL('../index.html', import.meta.url), 'utf8');
const script = 'const EGE_HTML = ' + JSON.stringify(html) + ';\n' +
  'export default {async fetch(request) {' +
  'const url = new URL(request.url);' +
  'if (request.method !== "GET" || (url.pathname !== "/" && url.pathname !== "/index.html")) return new Response("Not Found", {status:404});' +
  'return new Response(EGE_HTML, {headers:{"content-type":"text/html; charset=utf-8","cache-control":"no-store","x-content-type-options":"nosniff"}});' +
  '}}';
const form = new FormData();
form.set('metadata', new Blob([JSON.stringify({main_module:'worker.js',compatibility_date:'2026-11-11',bindings:[]})], {type:'application/json'}));
form.set('worker.js',new Blob([script],{type:'application/javascript+module'}),'worker.js');
const prefix = `https://api.cloudflare.com/client/v4/accounts/${accountId}/workers`;
const headers = {Authorization:`Bearer ${token}`};
const deployment = await fetch(`${prefix}/scripts/${workerName}`, {method:'PUT',headers,body:form});
const result = await deployment.json();
if (!deployment.ok || !result.success) throw new Error('Cloudflare: '+JSON.stringify(result.errors||result).slice(0,900));
const subdomain = await fetch(`${prefix}/scripts/${workerName}/subdomain`, {method:'POST',headers:{...headers,'Content-Type':'application/json'},body:JSON.stringify({enabled:true,previews_enabled:false})});
const subResult = await subdomain.json();
if (!subdomain.ok || !subResult.success) throw new Error('Cloudflare subdomain: '+JSON.stringify(subResult.errors||subResult).slice(0,900));
console.log('Publié: ege-gfm-2027');
