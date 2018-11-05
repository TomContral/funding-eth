pragma solidity ^0.4.24;
    import './Untitled.sol';

    //01.实现构造函数并测试成功
   contract fundingFactory{
        address[] public crowFundingArray;//所有众筹项目地址的集合
        mapping(address=>address[]) public creatorFundingMap;//当前账户发起的所有众筹项目的地址的集合
        address public platformProvider ;//众筹平台的提供者，合约仅部署一次。

   constructor()public{
        platformProvider=msg.sender;

   }
   //02.创建新的合约
     function createFunding(string _fundingName,uint _supportBalance,uint _targetBalance,uint _endTime) public {
        //a. 创建一个新合约
        address fundingAddress = new CrowFunding(_fundingName,_supportBalance,_targetBalance,_endTime);
        //b. 添加到合约集合中
        crowFundingArray.push(fundingAddress);

        //c. 添加到我所创建合约的集合中
        creatorFundingMap[msg.sender].push(fundingAddress);
    }


}
