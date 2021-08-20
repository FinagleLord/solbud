
contract Auth {
    
    // --- events ---
    event RoleSet(address who, bytes4 signature, bool canCall);

    event TempRoleSet(address who, bytes4 signature);
    
    event AuthoritySet(address authority);
    
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
    function giveTempRole (address who, bytes4 signature) external auth {
        hasTempRole[who][signature] = true;
        emit TempRoleSet(who, signature);
    }
    
    function giveRole (address who, bytes4 signature, bool canCall) external auth {
        hasRole[who][signature] = canCall;
        emit RoleSet(who, signature, canCall);
    }
    
    function giveAuthority (address who) external auth {
        authority = who;
        emit AuthoritySet(who);
    }
}
