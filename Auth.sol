pragma solidity ^0.8.6;

contract Auth {
    
    // --- events ---
    event RolePushed(address who, string signature);
    
    event RolePulled(address who, string signature);

    event TempRolePushed(address who, string signature);
    
    event AuthorityPushed(address authority);
    
    // --- storage ---
    mapping(address => mapping(bytes4 => bool)) public hasRole;

    mapping(address => mapping(bytes4 => bool)) public hasTempRole;    

    address public authority;
    
    uint private unlocked = 1;
    
    // --- modifiers ---
    modifier auth() {
        require(msg.sender == authority || hasRole[msg.sender][msg.sig]);
        _;
        hasTempRole[msg.sender][msg.sig] =  false;
    }
    
    modifier lock() {
        require(unlocked > 0, "locked");
        unlocked = 0;
        _;
        unlocked = 1;
    }
    
    // --- auth controlled logic ---
    function pushTempRole (address who, string calldata signature) external auth {
        bytes4 sig = bytes4(keccak256(bytes(signature)));
        hasTempRole[who][sig] = true;
        emit TempRolePushed(who, signature);
    }
    
    function pushRole (address who, string calldata signature) external auth {
        bytes4 sig = bytes4(keccak256(bytes(signature)));
        hasRole[who][sig] = true;
        emit RolePushed(who, signature);
    }
    
    function pullRole (address who, string calldata signature) external auth {
        bytes4 sig = bytes4(keccak256(bytes(signature)));
        hasRole[who][sig] = false;
        emit RolePulled(who, signature);
    }
    
    function pushAuthority (address who) external auth {
        authority = who;
        emit AuthorityPushed(who);
    }
}
