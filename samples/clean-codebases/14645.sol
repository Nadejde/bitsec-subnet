// File: contracts/interfaces/ISaffronBase.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.1;

interface ISaffronBase {
  enum Tranche {S, AA, A}
  enum LPTokenType {dsec, principal}

  // Store values (balances, dsec, vdsec) with TrancheUint256
  struct TrancheUint256 {
    uint256 S;
    uint256 AA;
    uint256 A;
  }

  struct epoch_params {
    uint256 start_date;       // Time when the platform launched
    uint256 duration;         // Duration of epoch
  }
}

// File: contracts/interfaces/ISaffronStrategy.sol


pragma solidity ^0.7.1;


interface ISaffronStrategy is ISaffronBase{
  function deploy_all_capital() external;
  function select_adapter_for_liquidity_removal() external returns(address);
  function add_adapter(address adapter_address) external;
  function add_pool(address pool_address) external;
  function delete_adapters() external;
  function set_governance(address to) external;
  function get_adapter_address(uint256 adapter_index) external view returns(address);
  function set_pool_SFI_reward(uint256 poolIndex, uint256 reward) external;
}

// File: contracts/interfaces/ISaffronPool.sol


pragma solidity ^0.7.1;

interface ISaffronPool is ISaffronBase {
  function add_liquidity(uint256 amount, Tranche tranche) external;
  function remove_liquidity(address v1_dsec_token_address, uint256 dsec_amount, address v1_principal_token_address, uint256 principal_amount) external;
  function get_base_asset_address() external view returns(address);
  function hourly_strategy(address adapter_address) external;
  function wind_down_epoch(uint256 epoch, uint256 amount_sfi) external;
  function set_governance(address to) external;
  function get_epoch_cycle_params() external view returns (uint256, uint256);
  function shutdown() external;
}

// File: contracts/interfaces/ISaffronAdapter.sol


pragma solidity ^0.7.1;

interface ISaffronAdapter is ISaffronBase {
    function deploy_capital(uint256 amount) external;
    function return_capital(uint256 base_asset_amount, address to) external;
    function approve_transfer(address addr,uint256 amount) external;
    function get_base_asset_address() external view returns(address);
    function set_base_asset(address addr) external;
    function get_holdings() external returns(uint256);
    function get_interest(uint256 principal) external returns(uint256);
    function set_governance(address to) external;
}

// File: contracts/lib/IERC20.sol


pragma solidity ^0.7.1;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/lib/SafeMath.sol


pragma solidity ^0.7.1;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
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

// File: contracts/lib/Address.sol


pragma solidity ^0.7.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: contracts/lib/SafeERC20.sol


pragma solidity ^0.7.1;




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
  using SafeMath for uint256;
  using Address for address;

  function safeTransfer(IERC20 token, address to, uint256 value) internal {
    _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
  }

  function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
    _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
  }

  /**
   * @dev Deprecated. This function has issues similar to the ones found in
   * {IERC20-approve}, and its usage is discouraged.
   *
   * Whenever possible, use {safeIncreaseAllowance} and
   * {safeDecreaseAllowance} instead.
   */
  function safeApprove(IERC20 token, address spender, uint256 value) internal {
    // safeApprove should only be called when setting an initial allowance,
    // or when resetting it to zero. To increase and decrease it, use
    // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
    // solhint-disable-next-line max-line-length
    require((value == 0) || (token.allowance(address(this), spender) == 0),
      "SafeERC20: approve from non-zero to non-zero allowance"
    );
    _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
  }

  function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
    uint256 newAllowance = token.allowance(address(this), spender).add(value);
    _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
  }

  function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
    uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
    _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
  }

  /**
   * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
   * on the return value: the return value is optional (but if data is returned, it must not be false).
   * @param token The token targeted by the call.
   * @param data The call data (encoded using abi.encode or one of its variants).
   */
  function _callOptionalReturn(IERC20 token, bytes memory data) private {
    // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
    // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
    // the target address contains contract code and also asserts for success in the low-level call.

    bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
    if (returndata.length > 0) { // Return data is optional
      // solhint-disable-next-line max-line-length
      require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }
  }
}

// File: @chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol

pragma solidity >=0.7.0;

interface AggregatorV3Interface {

  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

}

// File: contracts/ChainlinkRewardOracle.sol


pragma solidity ^0.7.1;


contract ChainlinkRewardOracle {

  mapping(uint16 => uint256[]) public base_SFI_rewards;
  mapping(uint16 => uint256[]) public bonus_SFI_rewards;

  mapping(uint256 => AggregatorV3Interface) public pool_feed;
  mapping(uint256 => uint256) public base_asset_price_begin;
  mapping(uint256 => uint256) public base_asset_price_end;
  mapping(uint256 => uint256) public limit; // If end price is less than X percent of `begin` use maximum reward; 1e18 scale

  mapping(uint16 => uint16[]) public tracked_pools;

  enum states {UNSET, REWARD_SET, STARTED, ENDED}
  mapping(uint16 => states) public epoch_state;

  address public governance;
  address public _new_governance;
  address public strategy;

  constructor(address strategyAddr) {
    governance = msg.sender;
    strategy = strategyAddr;
  }

  function set_feed(uint16 epoch, uint16 pool, address feedAddr, uint256 maxPct, uint256 alt_reward) public {
    require(msg.sender == strategy || msg.sender == governance, "must be strategy or gov");
    require(epoch_state[epoch] == states.REWARD_SET, "rewards must be set and not started");
    require(pool < base_SFI_rewards[epoch].length, "cannot feed pool with undefined reward");
    require(maxPct < 1 ether, "can't award on no change"); // Prevent divide by zero
    uint256 index = pack(epoch, pool);
    pool_feed[index] = AggregatorV3Interface(feedAddr);
    tracked_pools[epoch].push(pool);
    limit[index] = maxPct;
    bonus_SFI_rewards[epoch][pool] = alt_reward;
  }

  function set_base_reward(uint16 epoch, uint256[] calldata SFI_rewards) public {
    require(msg.sender == strategy || msg.sender == governance, "must be strategy or gov");
    require(epoch_state[epoch] == states.UNSET || epoch_state[epoch] == states.REWARD_SET, "must not be started");
    epoch_state[epoch] = states.REWARD_SET;
    base_SFI_rewards[epoch] = SFI_rewards;
    bonus_SFI_rewards[epoch] = SFI_rewards;
  }

  event BeginEpoch(uint16 epoch);

  function begin_epoch(uint16 epoch) public {
    require(msg.sender == strategy || msg.sender == governance, "must be strategy or gov");
    require(epoch_state[epoch] == states.REWARD_SET, "must set rewards first");
    epoch_state[epoch] = states.STARTED;
    emit BeginEpoch(epoch);
    for (uint256 i = 0; i < tracked_pools[epoch].length; i++) {
      uint256 index = pack(epoch, tracked_pools[epoch][i]);
      base_asset_price_begin[index] = get_latest_price(index);
    }
  }

  event EndEpoch(uint16 epoch);

  function end_epoch(uint16 epoch) public {
    require(msg.sender == strategy || msg.sender == governance, "must be strategy or gov");
    require(epoch_state[epoch] == states.STARTED, "must be started");
    epoch_state[epoch] = states.ENDED;
    emit EndEpoch(epoch);
    for (uint256 i = 0; i < tracked_pools[epoch].length; i++) {
      uint256 index = pack(epoch, tracked_pools[epoch][i]);
      base_asset_price_end[index] = get_latest_price(index);
    }
  }

  event OracleGetReward(uint256 index, uint256 begin, uint256 end, uint256 reward);

  function get_reward(uint16 epoch, uint16 pool) public view returns (uint256 index, uint256 begin, uint256 end, uint256 reward) {
    require(epoch_state[epoch] == states.ENDED, "must be ended");
    if (pool > base_SFI_rewards[epoch].length) {
      return (index, begin, end, reward);
    }

    index = pack(epoch, pool);

    if (pool_feed[index] == AggregatorV3Interface(0x0)) {
      reward = base_SFI_rewards[epoch][pool];
      return (index, begin, end, reward);
    }

    begin = base_asset_price_begin[index];
    end = base_asset_price_end[index];

    if (end >= begin) {
      reward = base_SFI_rewards[epoch][pool];
      return (index, begin, end, reward);
    }

    uint256 pct = limit[index];
    uint256 max_price_move = begin * pct / 1e18;

    reward = base_SFI_rewards[epoch][pool] + calc_reward_bonus(begin, end, pct, max_price_move, bonus_SFI_rewards[epoch][pool]);

    return (index, begin, end, reward);
  }

  function calc_reward_bonus(uint256 begin, uint256 end, uint256 pct, uint256 max_price_move, uint256 bonus_SFI_reward) internal pure returns (uint256) {
    if (end <= max_price_move) return bonus_SFI_reward;
    uint256 delta = (begin - end);
    uint256 delta_pct = (delta * 1 ether) / begin;
    uint256 reward_multiplier = delta_pct * 1 ether / (1 ether - pct);
    return bonus_SFI_reward * reward_multiplier / 1 ether;
  }

  function get_latest_price(uint256 index) internal view returns (uint256) {
    AggregatorV3Interface priceFeed = pool_feed[index];
    require(priceFeed != AggregatorV3Interface(0x0), "no feed found");
    // uint80 roundID, int price, uint startedAt, uint timeStamp, uint80 answeredInRound
    (,int price,,,) = priceFeed.latestRoundData();
    return uint256(price);
  }

  function pack(uint16 epoch, uint16 pool) internal pure returns (uint256) {
    return uint256(epoch) | uint256(pool) << 16;
  }

  //  function unpack(uint256 value) public pure returns (uint16, uint16) {
  //    return (uint16(value), uint16(value >> 16));
  //  }

  event SetGovernance(address prev, address next);
  event AcceptGovernance(address who);

  function set_governance(address to) external {
    require(msg.sender == governance, "must be governance");
    _new_governance = to;
    emit SetGovernance(msg.sender, to);
  }

  function accept_governance() external {
    require(msg.sender == _new_governance, "must be new governance");
    governance = msg.sender;
    emit AcceptGovernance(msg.sender);
  }

  function set_strategy(address to) external {
    require(msg.sender == governance, "must be governance");
    strategy = to;
  }
}

// File: contracts/lib/Context.sol


pragma solidity ^0.7.1;

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

// File: contracts/lib/ERC20.sol


pragma solidity ^0.7.1;





/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

// File: contracts/SFI.sol


pragma solidity ^0.7.1;



contract SFI is ERC20 {
  using SafeERC20 for IERC20;

  address public governance;
  address public SFI_minter;
  uint256 public MAX_TOKENS = 100000 ether;

  constructor (string memory name, string memory symbol) ERC20(name, symbol) {
    // Initial governance is Saffron Deployer
    governance = msg.sender;
  }

  function mint_SFI(address to, uint256 amount) public {
    require(msg.sender == SFI_minter, "must be SFI_minter");
    require(this.totalSupply() + amount < MAX_TOKENS, "cannot mint more than MAX_TOKENS");
    _mint(to, amount);
  }

  function set_minter(address to) external {
    require(msg.sender == governance, "must be governance");
    SFI_minter = to;
  }

  function set_governance(address to) external {
    require(msg.sender == governance, "must be governance");
    governance = to;
  }

  event ErcSwept(address who, address to, address token, uint256 amount);
  function erc_sweep(address _token, address _to) public {
    require(msg.sender == governance, "must be governance");

    IERC20 tkn = IERC20(_token);
    uint256 tBal = tkn.balanceOf(address(this));
    tkn.safeTransfer(_to, tBal);

    emit ErcSwept(msg.sender, _to, _token, tBal);
  }
}

// File: contracts/SaffronStrategy.sol


pragma solidity ^0.7.1;









// v0: all functions returns the only adapter that exists
// v1: evaluate adapters by interest rate and return the best one possible per currency
contract SaffronStrategy is ISaffronStrategy {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  ChainlinkRewardOracle public oracle;
  address public governance;
  address public team_address;
  address public SFI_address;
  address[] public pools;
  address[] public adapters;
  mapping(address=>uint256) private adapter_indexes;
  mapping(uint256=>address) private adapter_addresses;
  uint256[] public pool_SFI_rewards = [
	10500000000000000000,     //	10.5	SFI -	dai comp
	33750000000000000000,     //	33.75	SFI -	eth uni
	22500000000000000000,     //	22.5	SFI -	sfi stake
	1500000000000000000	,     //	1.5		SFI -	btse
	15500000000000000000,     //	10.5	SFI -	wbtc comp
	1500000000000000000,      //	1.5		SFI -	geeq
	1500000000000000000,      //	1.5		SFI -	esd
	33750000000000000000,     //	33.75	SFI -	eth sushi
	1500000000000000000,      //	1.5		SFI -	alpha
	10500000000000000000,     //	10.5	SFI -	dai rari
	1500000000000000000,      //	1.5		SFI -	prt
	10500000000000000000,     //	10.5	SFI -	usdt comp
	10500000000000000000      //	10.5	SFI -	usdc comp
  ];

  // True if epoch has been wound down already
  mapping(uint256=>bool) public epoch_wound_down;

  uint256 public last_deploy;     // Last run of Hourly Deploy
  uint256 public deploy_interval; // Hourly deploy interval

  epoch_params public epoch_cycle = epoch_params({
    start_date: 1604239200,   // 11/01/2020 @ 2:00pm (UTC)
    duration:   14 days       // 1210000 seconds
  });

  constructor(address _sfi_address, address _team_address, bool epoch_cycle_reset) {
    governance = msg.sender;
    team_address = _team_address;
    SFI_address = _sfi_address;
    deploy_interval = 1 hours;
    epoch_cycle.duration = (epoch_cycle_reset ? 30 minutes : 14 days); // Make testing previous epochs easier
    epoch_cycle.start_date = (epoch_cycle_reset ? (block.timestamp) - (4 * epoch_cycle.duration) : 1604239200); // Make testing previous epochs easier
  }

  function set_oracle(address oracleAddr) external {
    require(msg.sender == team_address || msg.sender == governance, "must be team or governance");
    oracle = ChainlinkRewardOracle(oracleAddr);
  }

  function oracle_set_reward(uint16 epoch) external {
    require(msg.sender == team_address || msg.sender == governance, "must be team or governance");
    oracle.set_base_reward(epoch, pool_SFI_rewards);
  }

  function wind_down_epoch(uint256 epoch) external {
    require(epoch == 13, "v1.13: only epoch 13");
    require(!epoch_wound_down[epoch], "epoch already wound down");
    require(msg.sender == team_address || msg.sender == governance, "must be team or governance");
    uint256 current_epoch = get_current_epoch();
    require(epoch < current_epoch, "cannot wind down future epoch");
    epoch_wound_down[epoch] = true;

    // Team Funds - https://miro.medium.com/max/568/1*8vnnKp4JzzCA3tNqW246XA.png
    uint256 team_sfi = 54 * 1 ether;
    SFI(SFI_address).mint_SFI(team_address, team_sfi);

    for (uint256 i = 0; i < pools.length; i++) {
      uint256 rewardSFI = 0;
      if (i < pool_SFI_rewards.length) {
        rewardSFI = pool_SFI_rewards[i];
        SFI(SFI_address).mint_SFI(pools[i], rewardSFI);
      }
      ISaffronPool(pools[i]).wind_down_epoch(epoch, rewardSFI);
    }
  }

  function wind_down_epoch_oracle(uint256 epoch) external {
    require(epoch == 13, "v1.13: only epoch 13");
    require(!epoch_wound_down[epoch], "epoch already wound down");
    require(msg.sender == team_address || msg.sender == governance, "must be team or governance");
    uint256 current_epoch = get_current_epoch();
    require(epoch < current_epoch, "cannot wind down future epoch");
    epoch_wound_down[epoch] = true;

    require(oracle != ChainlinkRewardOracle(0x0), "no oracle");

    // Team Funds - https://miro.medium.com/max/568/1*8vnnKp4JzzCA3tNqW246XA.png
    uint256 team_sfi = 54 * 1 ether;
    SFI(SFI_address).mint_SFI(team_address, team_sfi);

    oracle.end_epoch(uint16(epoch));

    for (uint16 i = 0; i < pools.length; i++) {
      uint256 rewardSFI = 0;
      if (i < pool_SFI_rewards.length) {
        (,,,rewardSFI) = oracle.get_reward(uint16(epoch), i);
        require(rewardSFI <= 34 ether, "oracle failure: rewards too high");
        SFI(SFI_address).mint_SFI(pools[i], rewardSFI);
      }
      ISaffronPool(pools[i]).wind_down_epoch(epoch, rewardSFI);
    }
  }

  // Wind down pool exists just in case one of the pools is broken
  function wind_down_pool(uint256 pool, uint256 epoch) external {
    require(msg.sender == team_address || msg.sender == governance, "must be team or governance");
    require(epoch == 13, "v1.13: only epoch 13");
    uint256 current_epoch = get_current_epoch();
    require(epoch < current_epoch, "cannot wind down future epoch");

    if (pool == uint(-1)) {
      require(!epoch_wound_down[epoch], "epoch already wound down");
      epoch_wound_down[epoch] = true;

      // Team Funds - https://miro.medium.com/max/568/1*8vnnKp4JzzCA3tNqW246XA.png
      uint256 team_sfi = 54 * 1 ether;
      SFI(SFI_address).mint_SFI(team_address, team_sfi);
    } else {
      uint256 rewardSFI = 0;
      if (pool < pool_SFI_rewards.length) {
        rewardSFI = pool_SFI_rewards[pool];
        SFI(SFI_address).mint_SFI(pools[pool], rewardSFI);
      }
      ISaffronPool(pools[pool]).wind_down_epoch(epoch, rewardSFI);
    }
  }

  // Deploy all capital in pool (funnel 100% of pooled base assets into best adapter)
  function deploy_all_capital() external override {
    require(block.timestamp >= last_deploy + (deploy_interval), "deploy call too soon" );
    last_deploy = block.timestamp;

    // DAI/Compound
    ISaffronPool pool = ISaffronPool(pools[0]);
    IERC20 base_asset = IERC20(pool.get_base_asset_address());
    if (base_asset.balanceOf(pools[0]) > 0) pool.hourly_strategy(adapters[0]);

    // DAI/Rari
    pool = ISaffronPool(pools[9]);
    base_asset = IERC20(pool.get_base_asset_address());
    if (base_asset.balanceOf(pools[9]) > 0) pool.hourly_strategy(adapters[1]);

    // wBTC/Compound
    pool = ISaffronPool(pools[4]);
    base_asset = IERC20(pool.get_base_asset_address());
    if (base_asset.balanceOf(pools[4]) > 0) pool.hourly_strategy(adapters[2]);

    // USDT/Compound
    pool = ISaffronPool(pools[11]);
    base_asset = IERC20(pool.get_base_asset_address());
    if (base_asset.balanceOf(pools[11]) > 0) pool.hourly_strategy(adapters[3]);
    
    // USDC/Compound
    pool = ISaffronPool(pools[12]);
    base_asset = IERC20(pool.get_base_asset_address());
    if (base_asset.balanceOf(pools[12]) > 0) pool.hourly_strategy(adapters[4]);
  }

  function deploy_all_capital_single_pool(uint256 pool_index, uint256 adapter_index) public {
    require(msg.sender == governance, "must be governance");
    ISaffronPool pool = ISaffronPool(pools[pool_index]);
    IERC20 base_asset = IERC20(pool.get_base_asset_address());
    if (base_asset.balanceOf(pools[pool_index]) > 0) pool.hourly_strategy(adapters[adapter_index]);
  }

  function v01_final_deploy() external {
    require(msg.sender == governance, "must be governance");
    // DAI Compound
    ISaffronPool pool = ISaffronPool(pools[0]);
    IERC20 base_asset = IERC20(pool.get_base_asset_address());
    if (base_asset.balanceOf(pools[0]) > 0) pool.hourly_strategy(adapters[0]);

    // Rari
    pool = ISaffronPool(pools[9]);
    base_asset = IERC20(pool.get_base_asset_address());
    if (base_asset.balanceOf(pools[9]) > 0) pool.hourly_strategy(adapters[1]);

    // wBTC/Compound
    pool = ISaffronPool(pools[4]);
    base_asset = IERC20(pool.get_base_asset_address());
    if (base_asset.balanceOf(pools[4]) > 0) pool.hourly_strategy(adapters[2]);

    // USDT/Compound
    pool = ISaffronPool(pools[11]);
    base_asset = IERC20(pool.get_base_asset_address());
    if (base_asset.balanceOf(pools[11]) > 0) pool.hourly_strategy(adapters[3]);

    // USDC/Compound
    pool = ISaffronPool(pools[12]);
    base_asset = IERC20(pool.get_base_asset_address());
    if (base_asset.balanceOf(pools[12]) > 0) pool.hourly_strategy(adapters[4]);

    for (uint256 i = 0; i < pools.length; i++) {
      ISaffronPool(pools[i]).shutdown();
    }
  }

  // Add adapters to a list of adapters passed in
  function add_adapter(address adapter_address) external override {
    require(msg.sender == governance, "add_adapter: must be governance");
    adapter_indexes[adapter_address] = adapters.length;
    adapters.push(adapter_address);
  }

  // Get an adapter's address by index
  function get_adapter_index(address adapter_address) public view returns(uint256) {
    return adapter_indexes[adapter_address];
  }

  // Get an adapter's address by index
  function get_adapter_address(uint256 index) external view override returns(address) {
    return address(adapters[index]);
  }

  function add_pool(address pool_address) external override {
    require(msg.sender == governance, "add_pool: must be governance");
    pools.push(pool_address);
  }

  function delete_adapters() external override {
    require(msg.sender == governance, "delete_adapters: must be governance");
    delete adapters;
  }

  function set_team_address(address to) public {
    require(msg.sender == governance || msg.sender == team_address, "permission");
    team_address = to;
  }

  function set_governance(address to) external override {
    require(msg.sender == governance, "set_governance: must be governance");
    governance = to;
  }

  function set_pool_SFI_reward(uint256 poolIndex, uint256 reward) external override {
    require(msg.sender == governance, "set_governance: must be governance");
    pool_SFI_rewards[poolIndex] = reward;
  }

  function shutdown_pool(uint256 poolIndex) external {
    require(msg.sender == governance, "must be governance");
    ISaffronPool(pools[poolIndex]).shutdown();
  }

  function select_adapter_for_liquidity_removal() external view override returns(address) {
    return adapters[0]; // v0: only one adapter
  }
  // v1.5 add replace adapter function
  // v1.5 add remove adapter function

  /*** TIME UTILITY FUNCTIONS ***/
  function get_epoch_end(uint256 epoch) public view returns (uint256) {
    return epoch_cycle.start_date.add(epoch.add(1).mul(epoch_cycle.duration));
  }

  function get_current_epoch() public view returns (uint256) {
    require(block.timestamp > epoch_cycle.start_date, "before epoch 0");
    return (block.timestamp - epoch_cycle.start_date) / epoch_cycle.duration;
  }

  function get_seconds_until_epoch_end(uint256 epoch) public view returns (uint256) {
    return epoch_cycle.start_date.add(epoch.add(1).mul(epoch_cycle.duration)).sub(block.timestamp);
  }

  event ErcSwept(address who, address to, address token, uint256 amount);
  function erc_sweep(address _token, address _to) public {
    require(msg.sender == governance, "must be governance");

    IERC20 tkn = IERC20(_token);
    uint256 tBal = tkn.balanceOf(address(this));
    tkn.safeTransfer(_to, tBal);

    emit ErcSwept(msg.sender, _to, _token, tBal);
  }
}