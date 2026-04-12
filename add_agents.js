// Missing 8 agents to add to server.js
const missing = [
  {id:18,name:'Vulcan',role:'Proof-Stack / Validation',status:'idle'},
  {id:19,name:'Polaris',role:'Biometric Auth / Build',status:'active'},
  {id:20,name:'Lyra',role:'Marketplace',status:'idle'},
  {id:21,name:'Draco',role:'Sovereign Protocol',status:'active'},
  {id:22,name:'Phoenix',role:'Auto-Recovery',status:'idle'},
  {id:23,name:'Auriga',role:'Auto-Recovery Backup',status:'idle'},
  {id:24,name:'Perseus',role:'Network Perimeter',status:'active'},
  {id:25,name:'Quaoar',role:'Zero-Trust Security',status:'idle'},
];
console.log(JSON.stringify(missing, null, 2));
