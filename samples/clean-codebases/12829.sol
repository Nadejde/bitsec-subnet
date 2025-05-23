// SPDX-License-Identifier: GPL-3.0-only

// File: @openzeppelin/contracts/cryptography/ECDSA.sol


pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSA {
    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        // Check the signature length
        if (signature.length != 65) {
            revert("ECDSA: invalid signature length");
        }

        // Divide the signature in r, s and v variables
        bytes32 r;
        bytes32 s;
        uint8 v;

        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
        require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * replicates the behavior of the
     * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
     * JSON-RPC method.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol


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

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


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

// File: @openzeppelin/contracts/utils/Address.sol


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

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol


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

// File: @openzeppelin/contracts/utils/ReentrancyGuard.sol


pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: contracts/SignatureBasedPeerToPeerMarkets.sol

pragma solidity ^0.6.0;







contract SignatureBasedPeerToPeerMarkets is ReentrancyGuard
{
	using Address for address payable;
	using ECDSA for bytes32;
	using SafeERC20 for IERC20;
	using SafeMath for uint256;

	bytes32 constant TYPEHASH = keccak256("Order(address,address,uint256,uint256,address,uint256)");

	mapping (bytes32 => uint256) public executedBookAmounts;

	uint256 public immutable fee;
	address payable public immutable vault;

	uint256 private immutable chainId_;

	constructor (uint256 _fee, address payable _vault) public
	{
		require(_fee <= 1e18, "invalid fee");
		require(_vault != address(0), "invalid address");
		fee = _fee;
		vault = _vault;
		chainId_ = _chainId();
	}

	function generateOrderId(address _bookToken, address _execToken, uint256 _bookAmount, uint256 _execAmount, address payable _maker, uint256 _salt) public view returns (bytes32 _orderId)
	{
		return keccak256(abi.encodePacked(TYPEHASH, chainId_, address(this), _bookToken, _execToken, _bookAmount, _execAmount, _maker, _salt));
	}

	function checkOrderExecution(address _bookToken, address _execToken, uint256 _bookAmount, uint256 _execAmount, address payable _maker, uint256 _salt, uint256 _requiredBookAmount) external view returns (uint256 _totalExecAmount)
	{
		return _checkOrderExecution(_bookToken, _execToken, _bookAmount, _execAmount, _maker, _salt, _requiredBookAmount);
	}

	// availability may not be accurate for multiple orders of the same maker
	function checkOrdersExecution(address _bookToken, address _execToken, uint256[] calldata _bookAmounts, uint256[] calldata _execAmounts, address payable[] calldata _makers, uint256[] calldata _salts, uint256 _lastRequiredBookAmount) external view returns (uint256 _totalExecAmount)
	{
		uint256 _length = _makers.length;
		if (_length == 0) return 0;
		_totalExecAmount = 0;
		for (uint256 _i = 0; _i < _length - 1; _i++) {
			uint256 _localExecAmount = _checkOrderExecution(_bookToken, _execToken, _bookAmounts[_i], _execAmounts[_i], _makers[_i], _salts[_i], uint256(-1));
			uint256 _newTotalExecAmount = _totalExecAmount + _localExecAmount;
			if (_newTotalExecAmount <= _totalExecAmount) return 0;
			_totalExecAmount = _newTotalExecAmount;
		}
		{
			uint256 _i = _length - 1;
			uint256 _localExecAmount = _checkOrderExecution(_bookToken, _execToken, _bookAmounts[_i], _execAmounts[_i], _makers[_i], _salts[_i], _lastRequiredBookAmount);
			uint256 _newTotalExecAmount = _totalExecAmount + _localExecAmount;
			if (_newTotalExecAmount <= _totalExecAmount) return 0;
			_totalExecAmount = _newTotalExecAmount;
		}
		return _totalExecAmount;
	}

	function _checkOrderExecution(address _bookToken, address _execToken, uint256 _bookAmount, uint256 _execAmount, address payable _maker, uint256 _salt, uint256 _requiredBookAmount) internal view returns (uint256 _requiredExecAmount)
	{
		if (_requiredBookAmount == 0) return 0;
		bytes32 _orderId = generateOrderId(_bookToken, _execToken, _bookAmount, _execAmount, _maker, _salt);
		uint256 _executedBookAmount = executedBookAmounts[_orderId];
		if (_executedBookAmount >= _bookAmount) return 0;
		uint256 _availableBookAmount = _bookAmount - _executedBookAmount;
		if (_requiredBookAmount == uint256(-1)) {
			_requiredBookAmount = _availableBookAmount;
		} else {
			if (_requiredBookAmount > _availableBookAmount) return 0;
		}
		if (_requiredBookAmount > IERC20(_bookToken).balanceOf(_maker)) return 0;
		if (_requiredBookAmount > IERC20(_bookToken).allowance(_maker, address(this))) return 0;
		_requiredExecAmount = _requiredBookAmount.mul(_execAmount).add(_bookAmount - 1) / _bookAmount;
		return _requiredExecAmount;
	}

	function executeOrder(address _bookToken, address _execToken, uint256 _bookAmount, uint256 _execAmount, address payable _maker, uint256 _salt, bytes calldata _signature, uint256 _requiredBookAmount) external payable nonReentrant
	{
		address payable _taker = msg.sender;
		uint256 _totalExecFeeAmount = _executeOrder(_bookToken, _execToken, _bookAmount, _execAmount, _maker, _salt, _signature, _taker, _requiredBookAmount);
		if (_execToken == address(0)) {
			vault.sendValue(_totalExecFeeAmount);
			require(address(this).balance == 0, "excess value");
		} else {
			IERC20(_execToken).safeTransferFrom(_taker, vault, _totalExecFeeAmount);
		}
	}

	function executeOrders(address _bookToken, address _execToken, uint256[] memory _bookAmounts, uint256[] memory _execAmounts, address payable[] memory _makers, uint256[] memory _salts, bytes memory _signatures, uint256 _lastRequiredBookAmount) external payable nonReentrant
	{
		address payable _taker = msg.sender;
		uint256 _length = _makers.length;
		require(_length > 0, "invalid length");
		uint256 _totalExecFeeAmount = 0;
		for (uint256 _i = 0; _i < _length - 1; _i++) {
			bytes memory _signature = _extractSignature(_signatures, _i);
			uint256 _requiredExecFeeAmount = _executeOrder(_bookToken, _execToken, _bookAmounts[_i], _execAmounts[_i], _makers[_i], _salts[_i], _signature, _taker, uint256(-1));
			_totalExecFeeAmount = _totalExecFeeAmount.add(_requiredExecFeeAmount);
		}
		{
			uint256 _i = _length - 1;
			bytes memory _signature = _extractSignature(_signatures, _i);
			uint256 _requiredExecFeeAmount = _executeOrder(_bookToken, _execToken, _bookAmounts[_i], _execAmounts[_i], _makers[_i], _salts[_i], _signature, _taker, _lastRequiredBookAmount);
			_totalExecFeeAmount = _totalExecFeeAmount.add(_requiredExecFeeAmount);
		}
		if (_execToken == address(0)) {
			vault.sendValue(_totalExecFeeAmount);
			require(address(this).balance == 0);
		} else {
			IERC20(_execToken).safeTransferFrom(_taker, vault, _totalExecFeeAmount);
		}
	}

	function _executeOrder(address _bookToken, address _execToken, uint256 _bookAmount, uint256 _execAmount, address payable _maker, uint256 _salt, bytes memory _signature, address payable _taker, uint256 _requiredBookAmount) internal returns (uint256 _requiredExecFeeAmount)
	{
		require(_requiredBookAmount > 0, "invalid amount");
		bytes32 _orderId = generateOrderId(_bookToken, _execToken, _bookAmount, _execAmount, _maker, _salt);
		require(_maker == _recoverSigner(_orderId, _signature), "access denied");
		uint256 _requiredExecNetAmount;
		{
			uint256 _executedBookAmount = executedBookAmounts[_orderId];
			require(_executedBookAmount < _bookAmount, "inactive order");
			{
				uint64 _startTime = uint64(_salt >> 64);
				uint64 _endTime = uint64(_salt);
				require(_startTime <= now && now < _endTime, "invalid timeframe");
			}
			uint256 _availableBookAmount = _bookAmount - _executedBookAmount;
			if (_requiredBookAmount == uint256(-1)) {
				_requiredBookAmount = _availableBookAmount;
			} else {
				require(_requiredBookAmount <= _availableBookAmount, "insufficient liquidity");
			}
			uint256 _requiredExecAmount = _requiredBookAmount.mul(_execAmount).add(_bookAmount - 1) / _bookAmount;
			_requiredExecFeeAmount = _requiredExecAmount.mul(fee) / 1e18;
			_requiredExecNetAmount = _requiredExecAmount - _requiredExecFeeAmount;
			executedBookAmounts[_orderId] = _executedBookAmount - _requiredBookAmount;
		}
		IERC20(_bookToken).safeTransferFrom(_maker, _taker, _requiredBookAmount);
		if (_execToken == address(0)) {
			_maker.sendValue(_requiredExecNetAmount);
		} else {
			IERC20(_execToken).safeTransferFrom(_taker, _maker, _requiredExecNetAmount);
		}
		emit Trade(_bookToken, _execToken, _orderId, _requiredBookAmount, _requiredExecNetAmount, _requiredExecFeeAmount, _maker, _taker);
		return _requiredExecFeeAmount;
	}

	function cancelOrder(address _bookToken, address _execToken, uint256 _bookAmount, uint256 _execAmount, uint256 _salt) external
	{
		address payable _maker = msg.sender;
		_cancelOrder(_bookToken, _execToken, _bookAmount, _execAmount, _maker, _salt);
	}

	function cancelOrders(address _bookToken, address _execToken, uint256[] calldata _bookAmounts, uint256[] calldata _execAmounts, uint256[] calldata _salts) external
	{
		address payable _maker = msg.sender;
		for (uint256 _i = 0; _i < _bookAmounts.length; _i++) {
			_cancelOrder(_bookToken, _execToken, _bookAmounts[_i], _execAmounts[_i], _maker, _salts[_i]);
		}
	}

	function _cancelOrder(address _bookToken, address _execToken, uint256 _bookAmount, uint256 _execAmount, address payable _maker, uint256 _salt) internal
	{
		bytes32 _orderId = generateOrderId(_bookToken, _execToken, _bookAmount, _execAmount, _maker, _salt);
		executedBookAmounts[_orderId] = uint256(-1);
		emit CancelOrder(_bookToken, _execToken, _orderId);
	}

	function _extractSignature(bytes memory _signatures, uint256 _index) internal pure returns (bytes memory _signature)
	{
		uint256 _offset = 65 * _index;
		_signature = new bytes(65);
		for (uint256 _i = 0; _i < 65; _i++) {
			_signature[_i] = _signatures[_offset + _i];
		}
		return _signature;
	}

	function _recoverSigner(bytes32 _hash, bytes memory _signature) internal pure returns (address _signer)
	{
		return _hash.toEthSignedMessageHash().recover(_signature);
	}

	function _chainId() internal pure returns (uint256 _chainid)
	{
		assembly { _chainid := chainid() }
		return _chainid;
	}

	event Trade(address indexed _bookToken, address indexed _execToken, bytes32 indexed _orderId, uint256 _bookAmount, uint256 _execAmount, uint256 _execFeeAmount, address _maker, address _taker);
	event CancelOrder(address indexed _bookToken, address indexed _execToken, bytes32 indexed _orderId);
}