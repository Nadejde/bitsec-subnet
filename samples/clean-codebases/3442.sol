/**
 *Submitted for verification at Etherscan.io on 2021-11-15
*/

// Sources flattened with hardhat v2.6.0 https://hardhat.org

// File @openzeppelin/contracts/token/ERC20/[email protected]

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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


// File @openzeppelin/contracts/math/[email protected]



pragma solidity >=0.6.0 <0.8.0;

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


// File @openzeppelin/contracts/utils/[email protected]



pragma solidity >=0.6.2 <0.8.0;

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


// File @openzeppelin/contracts/token/ERC20/[email protected]



pragma solidity >=0.6.0 <0.8.0;



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


// File @openzeppelin/contracts/math/[email protected]



pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}


// File contracts/interfaces/IPeak.sol



pragma solidity 0.6.11;

interface IPeak {
    function portfolioValue() external view returns (uint);
}

interface IBadgerSettPeak is IPeak {
    function mint(uint poolId, uint inAmount, bytes32[] calldata merkleProof)
        external
        returns(uint outAmount);

    function calcMint(uint poolId, uint inAmount)
        external
        view
        returns(uint bBTC, uint fee);

    function redeem(uint poolId, uint inAmount)
        external
        returns (uint outAmount);

    function calcRedeem(uint poolId, uint bBtc)
        external
        view
        returns(uint sett, uint fee, uint max);
}

interface IByvWbtcPeak is IPeak {
    function mint(uint inAmount, bytes32[] calldata merkleProof)
        external
        returns(uint outAmount);

    function calcMint(uint inAmount)
        external
        view
        returns(uint bBTC, uint fee);

    function redeem(uint inAmount)
        external
        returns (uint outAmount);

    function calcRedeem(uint bBtc)
        external
        view
        returns(uint sett, uint fee, uint max);
}


// File contracts/interfaces/IbBTC.sol



pragma solidity 0.6.11;

interface IbBTC is IERC20 {
    function mint(address account, uint amount) external;
    function burn(address account, uint amount) external;
}


// File contracts/interfaces/ICore.sol



pragma solidity 0.6.11;

interface ICore {
    function mint(uint btc, address account, bytes32[] calldata merkleProof) external returns (uint);
    function redeem(uint btc, address account) external returns (uint);
    function btcToBbtc(uint btc) external view returns (uint, uint);
    function bBtcToBtc(uint bBtc) external view returns (uint btc, uint fee);
    function pricePerShare() external view returns (uint);
}


// File contracts/common/proxy/GovernableProxy.sol



pragma solidity 0.6.11;

contract GovernableProxy {
    bytes32 constant OWNER_SLOT = keccak256("proxy.owner");

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() internal {
        _transferOwnership(msg.sender);
    }

    modifier onlyGovernance() {
        require(owner() == msg.sender, "NOT_OWNER");
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns(address _owner) {
        bytes32 position = OWNER_SLOT;
        assembly {
            _owner := sload(position)
        }
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function transferOwnership(address newOwner) external onlyGovernance {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "OwnableProxy: new owner is the zero address");
        emit OwnershipTransferred(owner(), newOwner);
        bytes32 position = OWNER_SLOT;
        assembly {
            sstore(position, newOwner)
        }
    }
}


// File contracts/common/PausableSlot.sol



pragma solidity 0.6.11;

contract PausableSlot {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bytes32 constant PAUSED_SLOT = keccak256("_paused");

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool _paused) {
        bytes32 position = PAUSED_SLOT;
        assembly {
            _paused := sload(position)
        }
    }

    function _setPaused(bool _paused) internal {
        bytes32 position = PAUSED_SLOT;
        assembly {
            sstore(position, _paused)
        }
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!paused(), "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(paused(), "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _setPaused(true);
        emit Paused(msg.sender);
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _setPaused(false);
        emit Unpaused(msg.sender);
    }
}


// File contracts/Core.sol



pragma solidity 0.6.11;







contract Core is GovernableProxy, PausableSlot, ICore {
    using SafeERC20 for IERC20;
    using SafeMath for uint;
    using Math for uint;

    uint constant PRECISION = 1e4;

    IbBTC public immutable bBTC;

    BadgerGuestListAPI public guestList;

    enum PeakState { Extinct, Active, RedeemOnly, MintOnly }
    mapping(address => PeakState) public peaks;

    address[] public peakAddresses;
    address public feeSink;
    uint public mintFee;
    uint public redeemFee;
    uint public accumulatedFee;

    address public guardian;
    address constant public badgerGovernance = 0xB65cef03b9B89f99517643226d76e286ee999e77;

    uint256[49] private __gap;

    // END OF STORAGE VARIABLES

    event PeakWhitelisted(address indexed peak);
    event FeeCollected(uint amount);

    /**
    * @param _bBTC bBTC token address
    */
    constructor(address _bBTC) public {
        require(_bBTC != address(0), "NULL_ADDRESS");
        bBTC = IbBTC(_bBTC);
    }

    modifier onlyGuardianOrGovernance() {
        require(msg.sender == guardian || msg.sender == owner(), "onlyGuardianOrGovernance");
        _;
    }

    modifier onlyGovernanceOrBadgerGovernance() {
        require(msg.sender == badgerGovernance || msg.sender == owner(), "onlyGovernanceOrBadgerGovernance");
        _;
    }

    /**
    * @notice Mint bBTC
    * @dev Only whitelisted peaks can call this function
    * @param btc BTC amount supplied, scaled by 1e18
    * @return bBtc Badger BTC that was minted
    */
    function mint(uint btc, address account, bytes32[] calldata merkleProof)
        override
        external
        whenNotPaused
        returns(uint)
    {
        require(peaks[msg.sender] == PeakState.Active || peaks[msg.sender] == PeakState.MintOnly, "PEAK_INACTIVE_OR_MINTING_DISABLED");
        if (address(guestList) != address(0)) {
            require(
                guestList.authorized(account, btc, merkleProof),
                "guest-list-authorization"
            );
        }
        (uint bBtc, uint fee) = btcToBbtc(btc);
        require(bBtc > 0, "MINTING_0_bBTC");
        accumulatedFee = accumulatedFee.add(fee);
        bBTC.mint(account, bBtc);
        return bBtc;
    }

    /**
    * @param btc BTC amount supplied
    */
    function btcToBbtc(uint btc) override public view returns (uint bBtc, uint fee) {
        uint _totalSupply = IERC20(address(bBTC)).totalSupply().add(accumulatedFee);
        if (_totalSupply > 0) {
            bBtc = btc.mul(_totalSupply).div(totalSystemAssets());
        } else {
            bBtc = btc;
        }
        fee = bBtc.mul(mintFee).div(PRECISION);
        bBtc = bBtc.sub(fee);
    }

    /**
    * @notice Redeem bBTC
    * @dev Only whitelisted peaks can call this function
    * @param bBtc bBTC amount to redeem
    * @return btc amount redeemed, scaled by 1e36
    */
    function redeem(uint bBtc, address account) override external whenNotPaused returns (uint) {
        require(bBtc > 0, "REDEEMING_0_bBTC");
        require(peaks[msg.sender] == PeakState.Active || peaks[msg.sender] == PeakState.RedeemOnly, "PEAK_INACTIVE_OR_REDEMPTION_DISABLED");
        (uint btc, uint fee) = bBtcToBtc(bBtc);
        accumulatedFee = accumulatedFee.add(fee);
        bBTC.burn(account, bBtc);
        return btc;
    }

    /**
    * @return btc amount redeemed, scaled by 1e36
    */
    function bBtcToBtc(uint bBtc) override public view returns (uint btc, uint fee) {
        fee = bBtc.mul(redeemFee).div(PRECISION);
        btc = bBtc.sub(fee).mul(pricePerShare());
    }

    function pricePerShare() override public view returns (uint) {
        uint _totalSupply = IERC20(address(bBTC)).totalSupply().add(accumulatedFee);
        if (_totalSupply > 0) {
            return totalSystemAssets().mul(1e18).div(_totalSupply);
        }
        return 1e18;
    }

    /**
    * @notice Collect all the accumulated fee (denominated in bBTC)
    */
    function collectFee() external whenNotPaused {
        require(feeSink != address(0), "NULL_ADDRESS");
        uint _fee = accumulatedFee;
        require(_fee > 0, "NO_FEE");
        accumulatedFee = 0;
        bBTC.mint(feeSink, _fee);
        emit FeeCollected(_fee);
    }

    function totalSystemAssets() public view returns (uint totalAssets) {
        address[] memory _peakAddresses = peakAddresses;
        uint numPeaks = _peakAddresses.length;
        for (uint i = 0; i < numPeaks; i++) {
            if (peaks[_peakAddresses[i]] == PeakState.Extinct) {
                continue;
            }
            totalAssets = totalAssets.add(
                IPeak(_peakAddresses[i]).portfolioValue()
            );
        }
    }

    /**
    * @notice Whitelist a new peak
    * @param peak Address of the contract that interfaces with the 3rd-party protocol
    */
    function whitelistPeak(address peak)
        external
        onlyGovernanceOrBadgerGovernance
    {
        require(
            peaks[peak] == PeakState.Extinct,
            "DUPLICATE_PEAK"
        );

        address[] memory _peakAddresses = peakAddresses;
        uint numPeaks = _peakAddresses.length;
        for (uint i = 0; i < numPeaks; i++) {
            require(_peakAddresses[i] != peak, "USE_setPeakStatus");
        }

        IPeak(peak).portfolioValue(); // sanity check
        peakAddresses.push(peak);
        peaks[peak] = PeakState.Active;
        emit PeakWhitelisted(peak);
    }

    /**
    * @notice Change a peaks status
    */
    function setPeakStatus(address peak, PeakState state)
        external
        onlyGovernanceOrBadgerGovernance
    {
        require(
            peaks[peak] != PeakState.Extinct,
            "Peak is extinct"
        );
        if (state == PeakState.Extinct) {
            require(IPeak(peak).portfolioValue() <= 1e15, "NON_TRIVIAL_FUNDS_IN_PEAK");
        }
        peaks[peak] = state;
    }

    /**
    * @notice Set config
    * @param _mintFee Mint Fee
    * @param _redeemFee Redeem Fee
    * @param _feeSink Address of the EOA/contract where accumulated fee will be transferred
    */
    function setConfig(
        uint _mintFee,
        uint _redeemFee,
        address _feeSink
    )
        external
        onlyGovernance
    {
        require(
            _mintFee <= PRECISION
            && _redeemFee <= PRECISION,
            "INVALID_PARAMETERS"
        );
        require(_feeSink != address(0), "NULL_ADDRESS");

        mintFee = _mintFee;
        redeemFee = _redeemFee;
        feeSink = _feeSink;
    }

    function setGuestList(address _guestList) external onlyGovernanceOrBadgerGovernance {
        guestList = BadgerGuestListAPI(_guestList);
    }

    function setGuardian(address _guardian) external onlyGovernanceOrBadgerGovernance {
        guardian = _guardian;
    }

    function pause() external onlyGuardianOrGovernance {
        _pause();
    }

    function unpause() external onlyGovernanceOrBadgerGovernance {
        _unpause();
    }
}

interface BadgerGuestListAPI {
    function authorized(address guest, uint256 amount, bytes32[] calldata merkleProof) external view returns (bool);
}