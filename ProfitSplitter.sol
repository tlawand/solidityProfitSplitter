pragma solidity ^0.5.0;

contract AssociateProfitSplitter {
    address payable public employeeOne;
    address payable public employeeTwo;
    address payable public employeeThree;

    address owner;

    constructor(address payable _one, address payable _two, address payable _three) public {
        employeeOne = _one;
        employeeTwo = _two;
        employeeThree = _three;
        
        owner = msg.sender; // since constructor runs at the time of deploying the contract,
                                    // we can set owner as msg.sender (this will only be set once)
    }

    function balance() public view returns(uint) {
        return address(this).balance;
    }

    function deposit() public payable {
        uint amount = msg.value / 3; // divide amount by 3 (to split equally to employees)
        require(owner == msg.sender, "permission denied"); // make sure only owner can call function
        
        // transfer the amount to each employee
        employeeOne.transfer(amount);
        employeeTwo.transfer(amount);
        employeeThree.transfer(amount);

        // take care of a potential remainder by sending back to HR (`msg.sender`)
        msg.sender.transfer(msg.value - amount * 3);
    }

    function() external payable {
        // Enforce that the `deposit` function is called in the fallback function!
        deposit();
    }
}


// lvl 2: tiered split
contract TieredProfitSplitter {
    address payable employeeOne; // ceo
    address payable employeeTwo; // cto
    address payable employeeThree; // bob

    constructor(address payable _one, address payable _two, address payable _three) public {
        employeeOne = _one;
        employeeTwo = _two;
        employeeThree = _three;
    }

    // Should always return 0! Use this to test your `deposit` function's logic
    function balance() public view returns(uint) {
        return address(this).balance;
    }

    function deposit() public payable {
        uint points = msg.value / 100; // Calculates rudimentary percentage by dividing msg.value into 100 units
        uint total;
        uint amount;
        
        // Calculate and transfer the distribution percentage
        
        // Step 1: Set amount to equal `points` * the number of percentage points for this employee
        // Step 2: Add the `amount` to `total` to keep a running total
        // Step 3: Transfer the `amount` to the employee

        amount = points * 60;
        total += amount;
        employeeOne.transfer(amount);
        
        amount = points * 25;
        total += amount;
        employeeTwo.transfer(amount);
        
        amount = points * 15;
        total += amount;
        employeeThree.transfer(amount);
        
        employeeOne.transfer(msg.value - total); // ceo gets the remaining wei
    }

    function() external payable {
        deposit();
    }
}


// lvl 3: equity plan
contract DeferredEquityPlan {
    address humanResources;

    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract

    // Set the total shares and annual distribution
        uint totalShares = 1000;
        uint annualDistribution = 250;

    uint startTime = now; // permanently store the time this contract was initialized

    // Set the `unlockTime` to be 365 days from now
    uint unlockTime = now + 365 days;

    uint public distributedShares; // starts at 0

    constructor(address payable _employee) public {
        humanResources = msg.sender;
        employee = _employee;
    }

    function distribute() public {
        require(msg.sender == humanResources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");

        // Add "require" statements to enforce that:
        // 1: `unlockTime` is less than or equal to `now`
        // 2: `distributedShares` is less than the `totalShares`
        require(unlockTime <= now, "vesting period has not yet matured");
        require(distributedShares < totalShares, "insuffcient shares to vest");

        // Add 365 days to the `unlockTime`
        unlockTime += 365 days;

        // Calculate the shares distributed by using the function (now - startTime) / 365 days * the annual distribution
        // Make sure to include the parenthesis around (now - startTime) to get accurate results!
        distributedShares = (now - startTime) / 365 days * annualDistribution;

        // double check in case the employee does not cash out until after 5+ years
        if (distributedShares > 1000) {
            distributedShares = 1000;
        }
    }

    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public {
        require(msg.sender == humanResources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}
