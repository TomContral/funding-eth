pragma solidity ^0.4.24;

//01.实现构造函数并测试成功
contract CrowFunding{
    address public manager; //项目发起人，负责创建合约、花费申请、花费执行
    string public  fundingName;//众筹项目名称
    uint  public supportBalance; //众筹支持金额
    uint public targetBalance; //众筹项目目标筹集金额
    uint public  endTime;     //众筹截止日期，到此时间时若筹不齐金额则众筹失败
    address []public investors ;//参与众筹的ren
    mapping(address => bool) public investorExistMap;//标记一个人是否参与了当前众筹


constructor(string _fundingName,uint _supportBalance,uint _targetBalance,uint _endTime)public{

      manager=msg.sender;
      fundingName=_fundingName;
      supportBalance=_supportBalance;
      targetBalance= _targetBalance;
      endTime= now+_endTime;

}
//02.添加投资方法invest以及相关属性
  function play () public payable{
       require (msg.value==supportBalance);//if 传递的数值等于众筹支持金额
       investors.push(msg.sender);   //把支持者添加进数组中
       investorExistMap[msg.sender]=true;  //在map中将该支持者标记为ture
   }

//03.完成退款及两个辅助函数
  function  tuikuan() onlyManager public {
      for (uint i=0;i<investors.length;i++){
          investors[i].transfer(supportBalance);
      }
  }

  function getBalance()public view returns(uint){
            return address(this).balance;
  }

    //返回所有的投资人
   function getInvestors()public view returns(address[]){
         return  investors;

   }
   //04.花费申请结构定义及方法定义

   enum RequestStatus {Voting,Approved,Completed}


   struct Requst{
       string purpose;//买什么？

       uint cost;//需要多少钱？
       address shopAddress;//向谁购买
       uint voteCount;//多少人赞成了，超半数则批准支出
       mapping(address=>bool)investorVotedMap;//赞成人的标记集合，防止一人重复投票多次
       RequestStatus status;//这个申请的当前状态：投票中？？已批准？ 已完成？

   }
   Requst[] public requests;//请求可能有多个，所以定义一个数组

    function createRequest(string _purpose,uint _cost,address _shopAddress) onlyManager public{
      Requst memory request=Requst({
      purpose:_purpose,
      cost:_cost,
      shopAddress:_shopAddress,
      voteCount:0,
      status:RequestStatus.Voting
      });
      requests.push(request);
     //将新的请求添加至数组中
   }

   //进行投票
   function approveRequst(uint index)public{
      require(investorExistMap[msg.sender]); //先判断是否是参与者
      Requst storage request=requests[index];//确定应用对象
      require(!request.investorVotedMap[msg.sender]);  //确认未投票（判断为false）
      require(request.status==RequestStatus.Voting);//确认投票未关闭
      request.voteCount++;                      //赞成数加1
      request.investorVotedMap[msg.sender]=true;//将投票完成的人员标记为true
   }

 //对投票结果进行判定并完成花费

 function finalizeRequest (uint index)onlyManager public{
      Requst storage request=requests[index];//确定应用对象

      require(address(this).balance>request.cost);
      require(request.voteCount*2>requests.length);
      request.shopAddress.transfer(request.cost);
      request.status=RequestStatus.Completed;

 }
 //权限控制
   modifier onlyManager(){
     require(msg.sender==manager);
       _;
   }

 //返回投资人数量
function getInvestorsCount() public view returns (uint) {
        return investors.length;
    }

        //返回众筹剩余时间
    function getRemainTime() public view returns (uint) {
        return (endTime - now) / 60 / 60 / 24;
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }

    function getRequestDetailByIndex(uint index) public view returns (string, uint, address, bool, uint, uint){
        //确保访问不越界

        require(index < requests.length);

        Requst storage req = requests[index];

        bool isVoted = req.investorVotedMap[msg.sender];
        return (req.purpose, req.cost, req.shopAddress, isVoted, req.voteCount, uint(req.status));
    }

}



