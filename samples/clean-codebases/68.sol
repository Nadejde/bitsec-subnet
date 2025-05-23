pragma solidity 0.7.2;

contract LYNCStakingV1 {





  //Enable SafeMath


  using SafeMath for uint256;





    address public owner;


    address public contractAddress;


    uint256 public totalRewards = 0;


    uint256 public totalRewardsClaimed = 0;


    uint256 public totalStakedV1 = 0;


    uint256 public oneDay = 86400;          // in seconds


    uint256 public SCALAR = 1e18;           // multiplier


    uint256 public minimumTokenStake = 98;  // takes into account transfer fee


    uint256 public endOfStakeFee = 4;       // 4% including 1% tx fee = approx 5%





    LYNCToken public tokenContract;





    //Events


	event Stake(address _from, uint256 tokens);


	event Unstake(address _to, uint256 tokens);


	event UnstakeFee(address _to, uint256 tokens);


	event CollectRewards(address _to, uint256 tokens);





	//User data


	struct Staker {


		uint256 staked;


		uint256 poolAtLastClaim;


		uint256 userTimeStamp;


	}





    //Mappings


    mapping(address => Staker) stakers;





    //On deployment


    constructor(LYNCToken _tokenContract) {


        owner = msg.sender;


        tokenContract = _tokenContract;


        contractAddress = address(this);


    }





    //MulDiv functions : source https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1


    function mulDiv(uint x, uint y, uint z) public pure returns (uint) {


          (uint l, uint h) = fullMul (x, y);


          assert (h < z);


          uint mm = mulmod(x, y, z);


          if (mm > l) h -= 1;


          l -= mm;


          uint pow2 = z & -z;


          z /= pow2;


          l /= pow2;


          l += h * ((-pow2) / pow2 + 1);


          uint r = 1;


          r *= 2 - z * r;


          r *= 2 - z * r;


          r *= 2 - z * r;


          r *= 2 - z * r;


          r *= 2 - z * r;


          r *= 2 - z * r;


          r *= 2 - z * r;


          r *= 2 - z * r;


          return l * r;


    }





    //Required for MulDiv


    function fullMul(uint x, uint y) private pure returns (uint l, uint h) {


          uint mm = mulmod(x, y, uint (-1));


          l = x * y;


          h = mm - l;


          if (mm < l) h -= 1;


    }





    //Return current reward pool unclaimed


    function rewardPoolBalance() public view returns(uint256) {


        return tokenContract.balanceOf(address(this)).sub(totalStakedV1);


    }





    //Return staker information


    function stakerInformation(address _stakerAddress) public view returns(uint256, uint256, uint256) {


        return (stakers[_stakerAddress].staked, stakers[_stakerAddress].poolAtLastClaim, stakers[_stakerAddress].userTimeStamp);


    }





    //Stake tokens


    function stakeTokens(uint256 _numberOfTokens) external returns (bool) {





        //Check if user is already staking


        if(stakers[msg.sender].staked == 0) {





            //Require minimum stake


            require(_numberOfTokens > (minimumTokenStake * SCALAR), "Not enough tokens to start staking");





            //Transfer tokens and update data


            require(tokenContract.transferFrom(msg.sender, address(this), _numberOfTokens));


            stakers[msg.sender].poolAtLastClaim = totalRewards;


            stakers[msg.sender].userTimeStamp = block.timestamp;


        } else {





            //Transfer tokens


            require(tokenContract.transferFrom(msg.sender, address(this), _numberOfTokens));


        }





        //Update staking totals


        uint256 _feeAmount = (_numberOfTokens.mul(tokenContract.feePercent())).div(100);


        uint256 _stakedAfterFee = _numberOfTokens.sub(_feeAmount);





        //Update data


        stakers[msg.sender].staked = (stakers[msg.sender].staked).add(_stakedAfterFee);


        totalStakedV1 = totalStakedV1.add(_stakedAfterFee);


        totalRewards = rewardPoolBalance().add(totalRewardsClaimed);





        emit Stake(msg.sender, _numberOfTokens);


        return true;


    }





    //Unstake tokens


    function unstakeTokens() external returns (bool) {





        //Minus 4% fee for unstaking


        uint256 _stakedTokens = stakers[msg.sender].staked;


        uint256 _feeAmount = (_stakedTokens.mul(endOfStakeFee)).div(100);


        uint256 _unstakeTokens = (stakers[msg.sender].staked).sub(_feeAmount);





        //Send stakers tokens and remove from total staked


        require(tokenContract.transfer(msg.sender, _unstakeTokens));


        totalStakedV1 = totalStakedV1.sub(_stakedTokens);





        //Update data


        stakers[msg.sender].staked = 0;


        stakers[msg.sender].poolAtLastClaim = 0;


        stakers[msg.sender].userTimeStamp = 0;


        totalRewards = rewardPoolBalance().add(totalRewardsClaimed);





        emit Unstake(msg.sender, _unstakeTokens);


        emit UnstakeFee(msg.sender, _feeAmount);


        return true;


    }





    //Claim current token rewards


    function claimRewards() external returns (bool) {





        totalRewards = rewardPoolBalance().add(totalRewardsClaimed);


        require(stakers[msg.sender].staked > 0, "You do not have any tokens staked");


        require(block.timestamp > (stakers[msg.sender].userTimeStamp + oneDay), "You can only claim 24 hours after staking and once every 24 hours");





        //Calculated user share of reward pool since last claim


        uint256 _poolSinceLastClaim = totalRewards.sub(stakers[msg.sender].poolAtLastClaim);


        uint256 _rewardPercent = mulDiv(stakers[msg.sender].staked, 10000, totalStakedV1);


        uint256 _rewardToClaim = mulDiv(_poolSinceLastClaim, _rewardPercent, 10000);





        //Send tokens


        require(tokenContract.transfer(msg.sender, _rewardToClaim));





        //Update data


        stakers[msg.sender].poolAtLastClaim = totalRewards;


        stakers[msg.sender].userTimeStamp = block.timestamp;


        totalRewardsClaimed = totalRewardsClaimed.add(_rewardToClaim);


        totalRewards = rewardPoolBalance().add(totalRewardsClaimed);





        emit CollectRewards(msg.sender, _rewardToClaim);


        return true;


    }





    //Update the minimum tokens to start staking


    function updateStakeMinimum(uint256 _minimumTokenStake) public onlyOwner {


        minimumTokenStake = _minimumTokenStake;


    }





    //Modifiers


    modifier onlyOwner() {


        require(owner == msg.sender, "Only current owner can call this function");


        _;


    }


}

contract LYNCToken {





    //Enable SafeMath


    using SafeMath for uint256;





    //Token details


    string constant public name = "LYNC Network";


    string constant public symbol = "LYNC";


    uint8 constant public decimals = 18;





    //Reward pool and owner address


    address public owner;


    address public rewardPoolAddress;





    //Supply and tranasction fee


    uint256 public maxTokenSupply = 1e24;   // 1,000,000 tokens


    uint256 public feePercent = 1;          // initial transaction fee percentage


    uint256 public feePercentMax = 10;      // maximum transaction fee percentage





    //Events


    event Transfer(address indexed _from, address indexed _to, uint256 _tokens);


    event Approval(address indexed _owner,address indexed _spender, uint256 _tokens);


    event TranserFee(uint256 _tokens);


    event UpdateFee(uint256 _fee);


    event RewardPoolUpdated(address indexed _rewardPoolAddress, address indexed _newRewardPoolAddress);


    event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);


    event OwnershipRenounced(address indexed _previousOwner, address indexed _newOwner);





    //Mappings


    mapping(address => uint256) public balanceOf;


    mapping(address => mapping(address => uint256)) private allowances;





    //On deployment


    constructor () {


        owner = msg.sender;


        rewardPoolAddress = address(this);


        balanceOf[msg.sender] = maxTokenSupply;


        emit Transfer(address(0), msg.sender, maxTokenSupply);


    }





    //ERC20 totalSupply


    function totalSupply() public view returns (uint256) {


        return maxTokenSupply;


    }





    //ERC20 transfer


    function transfer(address _to, uint256 _tokens) public returns (bool) {


        transferWithFee(msg.sender, _to, _tokens);


        return true;


    }





    //ERC20 transferFrom


    function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool) {


        require(_tokens <= balanceOf[_from], "Not enough tokens in the approved address balance");


        require(_tokens <= allowances[_from][msg.sender], "token amount is larger than the current allowance");


        transferWithFee(_from, _to, _tokens);


        allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_tokens);


        return true;


    }





    //ERC20 approve


    function approve(address _spender, uint256 _tokens) public returns (bool) {


        allowances[msg.sender][_spender] = _tokens;


        emit Approval(msg.sender, _spender, _tokens);


        return true;


    }





    //ERC20 allowance


    function allowance(address _owner, address _spender) public view returns (uint256) {


        return allowances[_owner][_spender];


    }





    //Transfer with transaction fee applied


    function transferWithFee(address _from, address _to, uint256 _tokens) internal returns (bool) {


        require(balanceOf[_from] >= _tokens, "Not enough tokens in the senders balance");


        uint256 _feeAmount = (_tokens.mul(feePercent)).div(100);


        balanceOf[_from] = balanceOf[_from].sub(_tokens);


        balanceOf[_to] = balanceOf[_to].add(_tokens.sub(_feeAmount));


        balanceOf[rewardPoolAddress] = balanceOf[rewardPoolAddress].add(_feeAmount);


        emit Transfer(_from, _to, _tokens.sub(_feeAmount));


        emit Transfer(_from, rewardPoolAddress, _feeAmount);


        emit TranserFee(_tokens);


        return true;


    }





    //Update transaction fee percentage


    function updateFee(uint256 _updateFee) public onlyOwner {


        require(_updateFee <= feePercentMax, "Transaction fee cannot be greater than 10%");


        feePercent = _updateFee;


        emit UpdateFee(_updateFee);


    }





    //Update the reward pool address


    function updateRewardPool(address _newRewardPoolAddress) public onlyOwner {


        require(_newRewardPoolAddress != address(0), "New reward pool address cannot be a zero address");


        rewardPoolAddress = _newRewardPoolAddress;


        emit RewardPoolUpdated(rewardPoolAddress, _newRewardPoolAddress);


    }





    //Transfer current token balance to the reward pool address


    function rewardPoolBalanceTransfer() public onlyOwner returns (bool) {


        uint256 _currentBalance = balanceOf[address(this)];


        transferWithFee(address(this), rewardPoolAddress, _currentBalance);


        return true;


    }





    //Transfer ownership to new owner


    function transferOwnership(address _newOwner) public onlyOwner {


        require(_newOwner != address(0), "New owner cannot be a zero address");


        emit OwnershipTransferred(owner, _newOwner);


        owner = _newOwner;


    }





    //Remove owner from the contract


    function renounceOwnership() public onlyOwner {


        emit OwnershipRenounced(owner, address(0));


        owner = address(0);


    }





    //Modifiers


    modifier onlyOwner() {


        require(owner == msg.sender, "Only current owner can call this function");


        _;


    }


}

library SafeMath {


    /**


     * @dev Returns the addition of two unsigned integers, reverting on


     * overflow.


     *


     * Counterpart to Solidity's `+` operator.


     *


     * Requirements:


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


     * - The divisor cannot be zero.


     */


    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {


        // Solidity only automatically asserts when dividing by 0


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


     * - The divisor cannot be zero.


     */


    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {


        require(b != 0, errorMessage);


        return a % b;


    }


}
