pragma solidity 0.6.12;

// SPDX-License-Identifier: MIT

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


interface StandardToken {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface IController {
    function withdrawETH(uint256 amount) external;
    function depositForStrategy(uint256 amount, address addr) external;
    function buyForStrategy(
        uint256 amount,
        address rewardToken,
        address recipient
    ) external;

    function sendExitToken(
        address user,
        uint256 amount
    ) external;

    function getStrategy(address vault) external view returns (address);
}

interface IStrategy {
    function getLastEpochTime() external view returns(uint256);
}

contract StakeAndYield is Ownable {
    uint256 constant STAKE = 1;
    uint256 constant YIELD = 2;
    uint256 constant BOTH = 3;

    uint256 public PERIOD = 24 hours;
    uint256 public EXIT_PERIOD = 90 days;

    uint256 public lastUpdateTime;
    uint256 public rewardRate;
    uint256 public rewardRateYield;

    uint256 public rewardTillNowPerToken = 0;
    uint256 public yieldRewardTillNowPerToken = 0;

    uint256 public _totalSupply = 0;
    uint256 public _totalSupplyYield = 0;

    uint256 public _totalYieldWithdrawed = 0;
    uint256 public _totalExit = 0;
    uint256 public _totalBurned = 0;

    // false: withdraw from YEARN and then pay the user
    // true: pay the user before withdrawing from YEARN
    bool public allowEmergencyWithdraw = false;

    IController public controller;

    address public operator;

    struct User {
        uint256 balance;
        uint256 stakeType;

        uint256 paidReward;
        uint256 yieldPaidReward;

        uint256 paidRewardPerToken;
        uint256 yieldPaidRewardPerToken;

        uint256 withdrawable;
        uint256 withdrawableExit;
        uint256 withdrawTime;

        bool exit;

        uint256 exitStartTime;
        uint256 exitAmountTillNow;
    }

    using SafeMath for uint256;

    mapping (address => User) public users;

    uint256 public lastUpdatedBlock;

    uint256 public periodFinish = 0;

    uint256 public scale = 1e18;

    uint256 public daoShare;
    address public daoWallet;

    bool public exitable;

    StandardToken public stakedToken;
    StandardToken public rewardToken;
    StandardToken public yieldRewardToken;

    event Deposit(address user, uint256 amount, uint256 stakeType);
    event Withdraw(address user, uint256 amount, uint256 stakeType);
    event Exit(address user, uint256 amount, uint256 stakeType);
    event Unfreeze(address user, uint256 amount, uint256 stakeType);
    event EmergencyWithdraw(address user, uint256 amount);
    event RewardClaimed(address user, uint256 amount, uint256 stakeType);

    constructor (
        address _stakedToken,
        address _rewardToken,
        address _yieldRewardToken,
        uint256 _daoShare,
        address _daoWallet,
        address _controller,
        bool _exitable
    ) public {
        stakedToken = StandardToken(_stakedToken);
        rewardToken = StandardToken(_rewardToken);
        yieldRewardToken = StandardToken(_yieldRewardToken);
        controller = IController(_controller);
        daoShare = _daoShare;
        daoWallet = _daoWallet;
        exitable = _exitable;

        operator = msg.sender;
    }

    modifier onlyOwnerOrController(){
        require(msg.sender == owner() ||
            msg.sender == address(controller) ||
            msg.sender == operator
            ,
            "!ownerOrController"
        );
        _;
    }

    modifier updateReward(address account, uint256 stakeType) {
        if(users[account].balance > 0){
            stakeType = users[account].stakeType;
        }
        
        if (account != address(0)) {
            sendReward(
                account,
                earned(account, STAKE),
                earned(account, YIELD)
            );
        }
        if(stakeType == STAKE || stakeType == BOTH){
            rewardTillNowPerToken = rewardPerToken(STAKE);
            lastUpdateTime = lastTimeRewardApplicable();
            if (account != address(0)) {
                users[account].paidRewardPerToken = rewardTillNowPerToken;
            }
        }

        if(stakeType == YIELD || stakeType == BOTH){
            yieldRewardTillNowPerToken = rewardPerToken(YIELD);
            lastUpdateTime = lastTimeRewardApplicable();
            if (account != address(0)) {
                users[account].yieldPaidRewardPerToken = yieldRewardTillNowPerToken;
            }
        }
        _;
    }

    function setDaoWallet(address _daoWallet) public onlyOwner {
        daoWallet = _daoWallet;
    }

    function setDaoShare(uint256 _daoShare) public onlyOwner {
        daoShare = _daoShare;
    }

    function setExitPeriod(uint256 period) public onlyOwner {
        EXIT_PERIOD = period;
    }

    function setOperator(address _addr) public onlyOwner{
        operator = _addr;
    }

    function setPeriod(uint256 period) public onlyOwner{
        PERIOD = period;
    }

    function withdrawToBurn() public onlyOwner{
        stakedToken.transfer(
            msg.sender,
            _totalExit.sub(_totalBurned)
        );
        _totalBurned = _totalExit;
    }

    function earned(address account, uint256 stakeType) public view returns(uint256) {
        User storage user = users[account];

        uint256 paidPerToken = stakeType == STAKE ? 
            user.paidRewardPerToken : user.yieldPaidRewardPerToken;

        return balanceOf(account, stakeType).mul(
            rewardPerToken(stakeType).
            sub(paidPerToken)
        ).div(1e18);
    }


    function earned(address account) public view returns(uint256){
        return earned(account, STAKE) + earned(account, YIELD);
    }

    function deposit(uint256 amount, uint256 stakeType, bool _exit) public {
        depositFor(msg.sender, amount, stakeType, _exit);
    }

    function depositFor(address _user, uint256 amount, uint256 stakeType, bool _exit)
        updateReward(_user, stakeType)
        public {
        
        require(stakeType==STAKE || stakeType ==YIELD || stakeType==BOTH, "Invalid stakeType");
        User storage user = users[_user];
        require(user.balance == 0 || user.stakeType==stakeType, "Invalid Stake Type");

        if(user.exit || (user.balance == 0 && _exit)){
            updateExit(_user);
        }else if(user.balance == 0 && !_exit){
            user.exit = false;
        }

        stakedToken.transferFrom(address(msg.sender), address(this), amount);

        user.stakeType = stakeType;
        user.balance = user.balance.add(amount);

        if(stakeType == STAKE){
            _totalSupply = _totalSupply.add(amount);
        }else if(stakeType == YIELD){
            _totalSupplyYield = _totalSupplyYield.add(amount);
        }else{
            _totalSupplyYield = _totalSupplyYield.add(amount);
            _totalSupply = _totalSupply.add(amount);
        }
        
        emit Deposit(_user, amount, stakeType);
    }

    function updateExit(address _user) private{
        require(exitable, "Not exitable");
        User storage user = users[_user];
        user.exit = true;
        user.exitAmountTillNow = exitBalance(_user);
        user.exitStartTime = block.timestamp;
    }

    function sendReward(address userAddress, uint256 amount, uint256 yieldAmount) private {
        User storage user = users[userAddress];
        uint256 _daoShare = amount.mul(daoShare).div(scale);
        uint256 _yieldDaoShare = yieldAmount.mul(daoShare).div(scale);

        if(amount > 0){
            rewardToken.transfer(userAddress, amount.sub(_daoShare));
            if(_daoShare > 0)
                rewardToken.transfer(daoWallet, _daoShare);
            user.paidReward = user.paidReward.add(
                amount
            );
        }

        if(yieldAmount > 0){
            yieldRewardToken.transfer(userAddress, yieldAmount.sub(_yieldDaoShare));
            
            if(_yieldDaoShare > 0)
                yieldRewardToken.transfer(daoWallet, _yieldDaoShare);   
            
            user.yieldPaidReward = user.yieldPaidReward.add(
                yieldAmount
            );
        }
        
        if(amount > 0 || yieldAmount > 0){
            emit RewardClaimed(userAddress, amount, yieldAmount);
        }
    }

    function sendExitToken(address _user, uint256 amount) private {
        controller.sendExitToken(
            _user,
            amount
        );
    }

    function claim() updateReward(msg.sender, 0) public {
        // updateReward handles everything
    }

    function setExit(bool _val) public{
        User storage user = users[msg.sender];
        require(user.exit != _val, "same exit status");
        require(user.balance > 0, "0 balance");

        user.exit = _val;
        user.exitStartTime = now;
        user.exitAmountTillNow = 0;
    }

    function unfreezeAllAndClaim() public{
        unfreeze(users[msg.sender].balance);
    }

    function unfreeze(uint256 amount) updateReward(msg.sender, 0) public {
        User storage user = users[msg.sender];
        uint256 stakeType = user.stakeType;

        require(
            user.balance >= amount,
            "withdraw > deposit");

        if (amount > 0) {
            uint256 exitAmount = exitBalance(msg.sender);
            uint256 remainingExit = 0;
            if(exitAmount > amount){
                remainingExit = exitAmount.sub(amount);
                exitAmount = amount;
            }

            if(user.exit){
                user.exitAmountTillNow = remainingExit;
                user.exitStartTime = now;
            }

            uint256 tokenAmount = amount.sub(exitAmount);
            user.balance = user.balance.sub(amount);
            if(stakeType == STAKE){
                _totalSupply = _totalSupply.sub(amount);
            }else if (stakeType == YIELD){
                _totalSupplyYield = _totalSupplyYield.sub(amount);
            }else{
                _totalSupply = _totalSupply.sub(amount);
                _totalSupplyYield = _totalSupplyYield.sub(amount);
            }

            if(allowEmergencyWithdraw || stakeType==STAKE){
                if(tokenAmount > 0){
                    stakedToken.transfer(address(msg.sender), tokenAmount);
                    emit Withdraw(msg.sender, tokenAmount, stakeType);
                }
                if(exitAmount > 0){
                    sendExitToken(msg.sender, exitAmount);
                    emit Exit(msg.sender, exitAmount, stakeType);
                }
            }else{
                user.withdrawable += tokenAmount;
                user.withdrawableExit += exitAmount;

                user.withdrawTime = now;

                _totalYieldWithdrawed += amount;
                emit Unfreeze(msg.sender, amount, stakeType);
            }
            _totalExit += exitAmount;
        }
    }

    function withdrawUnfreezed() public{
        User storage user = users[msg.sender];
        require(user.withdrawable > 0 || user.withdrawableExit > 0, 
            "amount is 0");
        
        uint256 lastEpochTime = IStrategy(
            controller.getStrategy(address(this))
        ).getLastEpochTime();
        require(user.withdrawTime < lastEpochTime,
            "Can't withdraw yet");

        if(user.withdrawable > 0){
            stakedToken.transfer(address(msg.sender), user.withdrawable);
            emit Withdraw(msg.sender, user.withdrawable, YIELD);
            user.withdrawable = 0;    
        }

        if(user.withdrawableExit > 0){
            sendExitToken(msg.sender, user.withdrawableExit);
            emit Exit(msg.sender, user.withdrawableExit, YIELD);
            user.withdrawableExit = 0;    
        }
    }

    // just Controller and admin should be able to call this
    function notifyRewardAmount(uint256 reward, uint256 stakeType) public onlyOwnerOrController  updateReward(address(0), stakeType){
        if (block.timestamp >= periodFinish) {
            if(stakeType == STAKE){
                rewardRate = reward.div(PERIOD);    
            }else{
                rewardRateYield = reward.div(PERIOD);
            }
        } else {
            uint256 remaining = periodFinish.sub(block.timestamp);
            if(stakeType == STAKE){
                uint256 leftover = remaining.mul(rewardRate);
                rewardRate = reward.add(leftover).div(PERIOD);    
            }else{
                uint256 leftover = remaining.mul(rewardRateYield);
                rewardRateYield = reward.add(leftover).div(PERIOD);
            }
            
        }
        lastUpdateTime = block.timestamp;
        periodFinish = block.timestamp.add(PERIOD);
    }

    function balanceOf(address account, uint256 stakeType) public view returns(uint256) {
        User storage user = users[account];
        if(user.stakeType == BOTH || user.stakeType==stakeType)
            return user.balance;
        return 0;
    }

    function exitBalance(address account) public view returns(uint256){
        User storage user = users[account];
        if(!user.exit || user.balance==0){
            return 0;
        }
        uint256 portion = (block.timestamp - user.exitStartTime).div(EXIT_PERIOD);
        portion = portion >= 1 ? 1 : portion;
        
        uint256 balance = user.exitAmountTillNow.add(
                user.balance.mul(portion)
        );
        return balance > user.balance ? user.balance : balance;
    }

    function totalYieldWithdrawed() public view returns(uint256) {
        return _totalYieldWithdrawed;
    }

    function totalExit() public view returns(uint256) {
        return _totalExit;
    }

    function totalSupply(uint256 stakeType) public view returns(uint256) {
        return stakeType == STAKE ? _totalSupply : _totalSupplyYield;
    }

    function lastTimeRewardApplicable() public view returns(uint256) {
        return block.timestamp < periodFinish ? block.timestamp : periodFinish;
    }

    function rewardPerToken(uint256 stakeType) public view returns(uint256) {
        uint256 supply = stakeType == STAKE ? _totalSupply : _totalSupplyYield;        
        if (supply == 0) {
            return stakeType == STAKE ? rewardTillNowPerToken : yieldRewardTillNowPerToken;
        }
        if(stakeType == STAKE){
            return rewardTillNowPerToken.add(
                lastTimeRewardApplicable().sub(lastUpdateTime)
                .mul(rewardRate).mul(1e18).div(_totalSupply)
            );
        }else{
            return yieldRewardTillNowPerToken.add(
                lastTimeRewardApplicable().sub(lastUpdateTime).
                mul(rewardRateYield).mul(1e18).div(_totalSupplyYield)
            );
        }
    }

    function getRewardToken() public view returns(address){
        return address(rewardToken);
    }

    function userInfo(address account) public view returns(
        uint256[14] memory numbers,

        address rewardTokenAddress,
        address stakedTokenAddress,
        address controllerAddress,
        address strategyAddress,
        bool exit
    ){
        User storage user = users[account];
        numbers[0] = user.balance;
        numbers[1] = user.stakeType;
        numbers[2] = user.withdrawTime;
        numbers[3] = user.withdrawable;
        numbers[4] = _totalSupply;
        numbers[5] = _totalSupplyYield;
        numbers[6] = stakedToken.balanceOf(address(this));
        
        numbers[7] = rewardPerToken(STAKE);
        numbers[8] = rewardPerToken(YIELD);
        
        numbers[9] = earned(account);

        numbers[10] = user.exitStartTime;
        numbers[11] = exitBalance(account);

        numbers[12] = user.withdrawable;
        numbers[13] = user.withdrawableExit;

        rewardTokenAddress = address(rewardToken);
        stakedTokenAddress = address(stakedToken);
        controllerAddress = address(controller);

        exit = user.exit;


        strategyAddress = controller.getStrategy(address(this));

        numbers[10] = IStrategy(
            controller.getStrategy(address(this))
        ).getLastEpochTime();
    }

    function setController(address _controller) public onlyOwner{
        if(_controller != address(0)){
            controller = IController(_controller);
        }
    }

    function emergencyWithdrawFor(address _user) public onlyOwner{
        User storage user = users[_user];

        uint256 amount = user.balance;

        stakedToken.transfer(_user, amount);

        emit EmergencyWithdraw(_user, amount);

        //add other fields
        user.balance = 0;
        user.paidReward = 0;
        user.yieldPaidReward = 0;
    }

    function setAllowEmergencyWithdraw(bool _val) public onlyOwner{
        allowEmergencyWithdraw = _val;
    }

    function setExitable(bool _val) public onlyOwner{
        exitable = _val;
    }

    function emergencyWithdrawETH(uint256 amount, address addr) public onlyOwner{
        require(addr != address(0));
        payable(addr).transfer(amount);
    }

    function emergencyWithdrawERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
        StandardToken(_tokenAddr).transfer(_to, _amount);
    }
}



//Dar panah khoda