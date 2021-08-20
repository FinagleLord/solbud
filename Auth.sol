pragma solidity ^0.8.6;

contract Auth {
    // --- events ---
    event RoleChange(address who, bytes4 signature, bool canCall);
    event AuthorityChange(address authority);
    
    // --- storage ---
    mapping(address => mapping(address => mapping(bytes4 => bool))) public hasRole;
    address public authority;

    // --- modifiers ---
    modifier auth() {
        require(msg.sender == authority || hasRole[msg.sender][address(this)][msg.sig]);
        _;
    }
    
    // --- public logic ---
    function setRole (address who, address destination, bytes4 signature, bool canCall) external auth {
        hasRole[who][destination][signature] = canCall;
        emit RoleChange(who, signature, canCall);
    }
    
    function setAuthority (address who) external auth {
        authority = who;
        emit AuthorityChange(who);
    }
}
