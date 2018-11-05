# funding-eth
基于以太坊的众筹项目


使用InvestorToFunding合约的方法 参考（实际进行了部分简化）


第一步，修改构造函数

import './InvestorToFunding.sol';


contract FundingFactory {
    ...
    //添加一个变量，默认i2为0x00000000000000000，必须实例化才可使用
    InvestorToFunding i2f;

    constructor() public {
        platformProvider = msg.sender;
        //实例化InvestorToFunding合约，返回一个地址。
        address i2fAddress = new InvestorToFunding();
        //将地址显示转换为InvestorToFunding类型，此时i2可以正常使用了
        i2f = InvestorToFunding(i2fAddress);
    }
    ...
}

第二步，传递到CrowFunding中，因为要在CrowFunding的invest函数中使用，添加到最后一个参数。

  ```go address fundingAddress = new CrowFunding(_projectName,..., _duration, msg.sender, i2f);```
   
   
第三步，修改CrowFunding的构造函数。
```go
InvestorToFunding i2f; //新增一个状态变量
 constructor(string _projectName, ...address _creator, InvestorToFunding _i2f) public {
        creator = _creator;
        i2f = _i2f;  //赋值给状态变量
  }
```

  
第四步，修改invest函数，在参与众筹的时候，将数据添加到所维护的mapping结构中。

    function invest() public payable {
        ...
        i2f.joinFunding(msg.sender, this); //<--调用添加方法，添加到mapping结构中
    }
    
    
第五步，在FundingFactory中添加方法，获取当前账户所参加的所有合约。

    function getInvestorFunding() public view returns(address[]) {
        return i2f.getFundingBy(msg.sender);
    }
