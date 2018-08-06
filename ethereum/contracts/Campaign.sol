pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;
    
    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    constructor(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        // example of mapping - note that we can't iterate through addresses
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
            // only have to initialize value types; mapping is a reference type
        });
        
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public {
        Request storage request = requests[index];
        
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        
        require(!request.complete);
        require(request.approvalCount > (approversCount / 2));
        
        request.recipient.transfer(request.value);
        request.complete = true;
        
    }

    function getSummary() public view returns (
        uint, uint, uint, uint, address
    ) {
        return (
            minimumContribution,
            this.balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
}

contract MeetingContract {
    struct Meeting {
        string title;           // title of meeting
        string description;     // description of meeting
        string start;           // start day and time
        string end;             // end day and time
        string status;          // current status (pending, active, ended)
        address host;           // host ether address
        address server;         // server ether address
        uint8 quality;          // 180p, 240p, 360p, 480p, 720p, 960p, 1080p, 2160p
        uint8 maxParticipants;  // maximum number of participants
        bool successful;        // did meeting fail or was it successful
        string url;             // url of the host - could use ENS name service
        bool invitationOnly;    // are only users with ethereum addresses - and were invited - are allowed access
        string hashedPassword;  // if meeting is authenticated, need password, 
        // use keccak256 to make sure password matches what was hashed off-chain
        mapping(address => bool) active; // is the user active in the meeting
        mapping(address => bool) participant; // is this address a participant
    }

    struct Server {
        address recipient;
        uint maxConnections;    // rough estimate of maximum number of meeting connections a server can provide
        bool available;         // probably just calculate this if active meetings.maxParticipants < maxConnections
        string url;             // url where meetings will he held - could be ip address and port
        uint8[] ports;          // possibly just port range
    }

    struct Client {
        address clientAddress;  // ethereum client address (possibly optional)
        string name;            // whatever name a client wants to use to display
    }

    Meeting[] meetings;
    Client[] clients;
    Server[] servers;

    // createMeeting
    // startMeeting
    // stopMeeting
    // pauseMeeting
    // joinMeeting
    // checkPassword
    // reviewMeeting - Uber-style star rating

    // estimateMaxLength - estimates maximum length of a meeting based on funds in user wallet
    // payDownPayment - pay downpayment for 50% of meeting fee
    // payServer - pay server fee for hosting meeting at end of meeting
    // refundHost - refund if host does not run meeting, or meeting ended < 90% complete
    // split difference between contract and server if meeting takes less than scheduled time 
    // & is less than 10% of scheduled time - otherwise refund host meeting fee minus cost to schedule / refund

}