let fs= require('fs')
let solc =require('solc')

 let source=fs.readFileSync('./constracts/fundingFactory.sol','utf-8')
 //console.log('source :', source)

 let  output=solc.compile(source,1)
//console.log('output :', output)

module.exports=output.contracts[':fundingFactory']
