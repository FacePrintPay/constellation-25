const http=require('http'),fs=require('fs');
const L=process.env.HOME+'/agent_logs';
if(!fs.existsSync(L))fs.mkdirSync(L,{recursive:true});
const A=[
[1,'Earth','Base ops'],[2,'Moon','Memory'],[3,'Sun','Optimize'],
[4,'Mercury','Routing'],[5,'Venus','UI/UX'],[6,'Mars','Engineering'],
[7,'Jupiter','Orchestrate'],[8,'Saturn','Data'],[9,'Uranus','R&D'],
[10,'Neptune','Compliance'],[11,'Cygnus','Patterns'],[12,'Orion','Content'],
[13,'Andromeda','Media'],[14,'Pleiades','Distribution'],[15,'Sirius','CI/CD'],
[16,'CanisMajor','Sovereignty'],[17,'Hydra','Pipelines']
];
A.forEach(a=>console.log(a[0]+'. '+a[1].padEnd(12)+a[2]));
console.log('PATHOS ONLINE | '+A.length+' agents | port 3100');
http.createServer((q,r)=>{
r.setHeader('Content-Type','application/json');
r.end(JSON.stringify({status:'online',agents:A.length}));
}).listen(3100,'127.0.0.1');
fs.appendFileSync(L+'/pathos.log',new Date().toISOString()+' ONLINE\n');
