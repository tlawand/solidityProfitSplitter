contract TestDeferredEquityPlan {
    uint fakenow = now;
    address humanResources;

    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract

    // Set the total shares and annual distribution
        uint totalShares = 1000;
        uint annualDistribution = 250;

    uint startTime = now; // permanently store the time this contract was initialized

    // Set the `unlockTime` to be 365 days from now
    uint unlockTime = fakenow + 365 days;

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
        require(unlockTime <= fakenow, "vesting period has not yet matured");
        require(distributedShares < totalShares, "insuffcient shares to vest");

        // Add 365 days to the `unlockTime`
        unlockTime += 365 days;

        // Calculate the shares distributed by using the function (now - startTime) / 365 days * the annual distribution
        // Make sure to include the parenthesis around (now - startTime) to get accurate results!
        distributedShares = (fakenow - startTime) / 365 days * annualDistribution;

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

    function fastforward() public {
        fakenow += 100 days;
    }

}
