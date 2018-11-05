
pragma solidity ^0.4.24;
    import './funding.sol';

    //01.实现构造函数并测试成功
   contract fundingFactory{
        address[] public crowFundingArray;//所有众筹项目地址的集合
        mapping(address=>address[]) public creatorFundingMap;//当前账户发起的所有众筹项目的地址的集合
        address public platformProvider ;//众筹平台的提供者，合约仅部署一次。
        InvestorToFunding investorToFunding;    //添加一个变量，默认i2为0x00000000000000000，必须实例化才可使用


   constructor()public{
        platformProvider=msg.sender;
        address investorToFunding=new InvestorToFunding();//实例化InvestorToFunding合约，返回一个地址。


   }
   //02.创建新的合约
     function createFunding(string _fundingName,uint _supportBalance,uint _targetBalance,uint _endTime) public {
        //a. 创建一个新合约
        address fundingAddress = new CrowFunding(_fundingName,_supportBalance,_targetBalance,_endTime,msg.sender,investorToFunding);
        //b. 添加到合约集合中
        crowFundingArray.push(fundingAddress);

        //c. 添加到我所创建合约的集合中
        creatorFundingMap[msg.sender].push(fundingAddress);
    }

    //03.辅助函数
        //返回该众筹平台所有的合约
function getAllFunding () public returns(address[]){
    return crowFundingArray;
}
   //返回当前账户所创建的所有合约
   function getCreatorFunding ()public returns(address[]){
       return creatorFundingMap[msg.sender];
   }
   //获取当前账户所参加的所有合约
      function getInvestorFunding() public view returns(address[]) {
        return investorToFunding.getFundingBy(msg.sender);
    }
}
   //我参与的合约
    contract InvestorToFunding{
    mapping(address=>address[]) InvestorToFundingMap;
   //添加指定参与人所参与的数组

    function joinFunding (address inverstor,address fundingAddress)public{
        InvestorToFundingMap[inverstor].push(fundingAddress);
    }
    //返回指定参与人所参与的合约数组
    function getFundingBy (address inverstor)public view returns(address[]){
       return  InvestorToFundingMap[inverstor];

    }


}
