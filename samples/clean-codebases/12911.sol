// File: contracts/SmartTreasuryV2.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

///////////////////////////////////////////////////////////////////////////
//     __/|      
//  __////  /|   This smart contract is part of Mover infrastructure
// |// //_///    https://viamover.com
//    |_/ //     support@viamover.com
//       |/
///////////////////////////////////////////////////////////////////////////

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
library SafeMathUpgradeable {
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


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20Upgradeable {
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


/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
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


/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20Upgradeable {
    using SafeMathUpgradeable for uint256;
    using AddressUpgradeable for address;

    function safeTransfer(IERC20Upgradeable token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20Upgradeable token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20Upgradeable token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
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


/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 */
library EnumerableSetUpgradeable {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint256(_at(set._inner, index)));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}


/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 * 
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
 * 
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 */
abstract contract Initializable {

    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function _isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        // solhint-disable-next-line no-inline-assembly
        assembly { cs := extcodesize(self) }
        return cs == 0;
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
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {
    }
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
    uint256[50] private __gap;
}


/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable {
    function __AccessControl_init() internal initializer {
        __Context_init_unchained();
        __AccessControl_init_unchained();
    }

    function __AccessControl_init_unchained() internal initializer {
    }
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using AddressUpgradeable for address;

    struct RoleData {
        EnumerableSetUpgradeable.AddressSet members;
        bytes32 adminRole;
    }

    mapping (bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role].members.contains(account);
    }

    /**
     * @dev Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     */
    function getRoleMemberCount(bytes32 role) public view returns (uint256) {
        return _roles[role].members.length();
    }

    /**
     * @dev Returns one of the accounts that have `role`. `index` must be a
     * value between 0 and {getRoleMemberCount}, non-inclusive.
     *
     * Role bearers are not sorted in any particular way, and their ordering may
     * change at any point.
     *
     * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
     * you perform all queries on the same block. See the following
     * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
     * for more information.
     */
    function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
        return _roles[role].members.at(index);
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");

        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");

        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) public virtual {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
        _roles[role].adminRole = adminRole;
    }

    function _grantRole(bytes32 role, address account) private {
        if (_roles[role].members.add(account)) {
            emit RoleGranted(role, account, _msgSender());
        }
    }

    function _revokeRole(bytes32 role, address account) private {
        if (_roles[role].members.remove(account)) {
            emit RoleRevoked(role, account, _msgSender());
        }
    }
    uint256[49] private __gap;
}


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
contract ERC20UpgradeableDecimals is Initializable, ContextUpgradeable, IERC20Upgradeable {
    using SafeMathUpgradeable for uint256;

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
    function __ERC20_init(string memory name_, string memory symbol_, uint8 decimals_) internal initializer {
        __Context_init_unchained();
        __ERC20_init_unchained(name_, symbol_, decimals_);
    }

    function __ERC20_init_unchained(string memory name_, string memory symbol_, uint8 decimals_) internal initializer {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public virtual view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public virtual view returns (string memory) {
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
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
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
     * Requirements:
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
     * Requirements:
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
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
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
    uint256[44] private __gap;
}


/**
 * @dev Extension of {ERC20} that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
abstract contract ERC20BurnableUpgradeableDecimals is Initializable, ContextUpgradeable, ERC20UpgradeableDecimals {
    function __ERC20Burnable_init() internal initializer {
        __Context_init_unchained();
        __ERC20Burnable_init_unchained();
    }

    function __ERC20Burnable_init_unchained() internal initializer {
    }
    using SafeMathUpgradeable for uint256;

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual {
        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");

        _approve(account, _msgSender(), decreasedAllowance);
        _burn(account, amount);
    }
    uint256[50] private __gap;
}


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    function __Pausable_init() internal initializer {
        __Context_init_unchained();
        __Pausable_init_unchained();
    }

    function __Pausable_init_unchained() internal initializer {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
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
        require(_paused, "Pausable: not paused");
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
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
    uint256[49] private __gap;
}


/**
 * @dev ERC20 token with pausable token transfers, minting and burning.
 *
 * Useful for scenarios such as preventing trades until the end of an evaluation
 * period, or having an emergency switch for freezing all token transfers in the
 * event of a large bug.
 */
abstract contract ERC20PausableUpgradeableDecimals is Initializable, ERC20UpgradeableDecimals, PausableUpgradeable {
    function __ERC20Pausable_init() internal initializer {
        __Context_init_unchained();
        __Pausable_init_unchained();
        __ERC20Pausable_init_unchained();
    }

    function __ERC20Pausable_init_unchained() internal initializer {
    }
    /**
     * @dev See {ERC20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - the contract must not be paused.
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }
    uint256[50] private __gap;
}


/**
 * @dev {ERC20} token, including:
 *
 *  - ability for holders to burn (destroy) their tokens
 *  - a minter role that allows for token minting (creation)
 *  - a pauser role that allows to stop all token transfers
 *
 * This contract uses {AccessControl} to lock permissioned functions using the
 * different roles - head to its documentation for details.
 *
 * The account that deploys the contract will be granted the minter and pauser
 * roles, as well as the default admin role, which will let it grant both minter
 * and pauser roles to other accounts.
 */
contract ERC20PresetMinterPauserUpgradeableDecimals is Initializable, ContextUpgradeable, AccessControlUpgradeable, ERC20BurnableUpgradeableDecimals, ERC20PausableUpgradeableDecimals {
    function initialize(string memory name, string memory symbol) public virtual initializer {
        __ERC20PresetMinterPauser_init(name, symbol);
    }
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    /**
     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
     * account that deploys the contract.
     *
     * See {ERC20-constructor}.
     */
    function __ERC20PresetMinterPauser_init(string memory name, string memory symbol) internal initializer {
        __Context_init_unchained();
        __AccessControl_init_unchained();
        __ERC20_init_unchained(name, symbol, 18);
        __ERC20Burnable_init_unchained();
        __Pausable_init_unchained();
        __ERC20Pausable_init_unchained();
        __ERC20PresetMinterPauser_init_unchained(name, symbol);
    }

    function __ERC20PresetMinterPauser_init_unchained(string memory name, string memory symbol) internal initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
    }

    /**
     * @dev Creates `amount` new tokens for `to`.
     *
     * See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */
    function mint(address to, uint256 amount) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
        _mint(to, amount);
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC20Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function pause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * See {ERC20Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     *
     * - the caller must have the `PAUSER_ROLE`.
     */
    function unpause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20UpgradeableDecimals, ERC20PausableUpgradeableDecimals) {
        super._beforeTokenTransfer(from, to, amount);
    }
    uint256[50] private __gap;
}


/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
 * directly accessed.
 */
library CountersUpgradeable {
    using SafeMathUpgradeable for uint256;

    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        // The {SafeMath} overflow check can be skipped here, see the comment at the top
        counter._value += 1;
    }

    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}


/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20PermitUpgradeable {
    /**
     * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
     * given `owner`'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}


/**
 * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
 *
 * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
 * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
 * they need in their contracts using a combination of `abi.encode` and `keccak256`.
 *
 * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
 * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
 * ({_hashTypedDataV4}).
 *
 * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
 * the chain id to protect against replay attacks on an eventual fork of the chain.
 *
 * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
 * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
 */
abstract contract EIP712Upgradeable is Initializable {
    /* solhint-disable var-name-mixedcase */
    bytes32 private _HASHED_NAME;
    bytes32 private _HASHED_VERSION;
    bytes32 private constant _TYPE_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    /* solhint-enable var-name-mixedcase */

    /**
     * @dev Initializes the domain separator and parameter caches.
     *
     * The meaning of `name` and `version` is specified in
     * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
     *
     * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
     * - `version`: the current major version of the signing domain.
     *
     * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
     * contract upgrade].
     */
    function __EIP712_init(string memory name, string memory version) internal initializer {
        __EIP712_init_unchained(name, version);
    }

    function __EIP712_init_unchained(string memory name, string memory version) internal initializer {
        bytes32 hashedName = keccak256(bytes(name));
        bytes32 hashedVersion = keccak256(bytes(version));
        _HASHED_NAME = hashedName;
        _HASHED_VERSION = hashedVersion;
    }

    function _EIP712SetNameHash(string memory name) internal {
        bytes32 hashedName = keccak256(bytes(name));
        _HASHED_NAME = hashedName;
    }

    /**
     * @dev Returns the domain separator for the current chain.
     */
    function _domainSeparatorV4() internal view returns (bytes32) {
        return _buildDomainSeparator(_TYPE_HASH, _EIP712NameHash(), _EIP712VersionHash());
    }

    function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
        return keccak256(
            abi.encode(
                typeHash,
                name,
                version,
                _getChainId(),
                address(this)
            )
        );
    }

    /**
     * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
     * function returns the hash of the fully encoded EIP712 message for this domain.
     *
     * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
     *
     * ```solidity
     * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
     *     keccak256("Mail(address to,string contents)"),
     *     mailTo,
     *     keccak256(bytes(mailContents))
     * )));
     * address signer = ECDSA.recover(digest, signature);
     * ```
     */
    function _hashTypedDataV4(bytes32 structHash) internal view returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
    }

    function _getChainId() private view returns (uint256 chainId) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        // solhint-disable-next-line no-inline-assembly
        assembly {
            chainId := chainid()
        }
    }

    /**
     * @dev The hash of the name parameter for the EIP712 domain.
     *
     * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
     * are a concern.
     */
    function _EIP712NameHash() internal virtual view returns (bytes32) {
        return _HASHED_NAME;
    }

    /**
     * @dev The hash of the version parameter for the EIP712 domain.
     *
     * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
     * are a concern.
     */
    function _EIP712VersionHash() internal virtual view returns (bytes32) {
        return _HASHED_VERSION;
    }
    uint256[50] private __gap;
}


/**
 * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
abstract contract ERC20PermitUpgradeableDecimals is Initializable, ERC20UpgradeableDecimals, IERC20PermitUpgradeable, EIP712Upgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;

    mapping (address => CountersUpgradeable.Counter) private _nonces;

    // solhint-disable-next-line var-name-mixedcase
    bytes32 private _PERMIT_TYPEHASH;

    /**
     * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
     *
     * It's a good idea to use the same `name` that is defined as the ERC20 token name.
     */
    function __ERC20Permit_init(string memory name) internal initializer {
        __Context_init_unchained();
        __EIP712_init_unchained(name, "1");
        __ERC20Permit_init_unchained(name);
    }

    function __ERC20Permit_init_unchained(string memory name) internal initializer {
        _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    }

    /**
     * @dev See {IERC20Permit-permit}.
     */
    function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
        // solhint-disable-next-line not-rely-on-time
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        bytes32 structHash = keccak256(
            abi.encode(
                _PERMIT_TYPEHASH,
                owner,
                spender,
                amount,
                _nonces[owner].current(),
                deadline
            )
        );

        bytes32 hash = _hashTypedDataV4(structHash);

        address signer = _recoverSigner(hash, v, r, s);
        require(signer == owner, "ERC20Permit: invalid signature");

        _nonces[owner].increment();
        _approve(owner, spender, amount);
    }

    /**
     * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
     * `r` and `s` signature fields separately.
     */
    function _recoverSigner(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n Г· 2 + 1, and for v in (282): v в€€ {27, 28}. Most
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
     * @dev See {IERC20Permit-nonces}.
     */
    function nonces(address owner) public view override returns (uint256) {
        return _nonces[owner].current();
    }

    /**
     * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view override returns (bytes32) {
        return _domainSeparatorV4();
    }
    uint256[49] private __gap;
}


// Interface to Sushi's MasterChef for staking/unstaking of SLP token
interface IMasterChef {
    // Deposit LP tokens to MasterChef for SUSHI allocation
    function deposit(uint256 _pid, uint256 _amount) external;

    // Withdraw LP tokens from MasterChef
    function withdraw(uint256 _pid, uint256 _amount) external;

    // View function to see pending SUSHIs
    function pendingSushi(uint256 _pid, address _user) external view returns (uint256);
}


abstract contract SafeAllowanceResetUpgradeable {
  using SafeMathUpgradeable for uint256;
  using SafeERC20Upgradeable for IERC20Upgradeable;

  // this function exists due to OpenZeppelin quirks in safe allowance-changing methods
  // we don't want to set allowance by small chunks as it would cost more gas for users
  // and we don't want to set it to zero and then back to value (this makes no sense security-wise in single tx)
  // from the other side, using it through safeIncreaseAllowance could revery due to SafeMath overflow
  // Therefore, we calculate what amount we can increase allowance on to refill it to max uint256 value
  function resetAllowanceIfNeeded(IERC20Upgradeable _token, address _spender, uint256 _amount) internal {
    uint256 allowance = _token.allowance(address(this), _spender);
    if (allowance < _amount) {
      uint256 newAllowance = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
      IERC20Upgradeable(_token).safeIncreaseAllowance(address(_spender), newAllowance.sub(allowance));
    }
  }
}


/*
    SmartTreasury is a contract to handle:
    - staking/unstaking of supported tokens;
    - distribution of yield to bonus and endowment portions;
    - rebalancing of asset allocation;
    - claiming treasury portion through token burn;
    - getting eth for subsidizing a transaction;
    - ERC20 functions for bonus token;
    - administrative functions (tresholds);
    - emergency recover functions (timelocked).

    V2: provide staking of SLP tokens to MasterChef to receive and distribute SUSHI rewards
*/
contract SmartTreasuryV2 is ERC20PresetMinterPauserUpgradeableDecimals, ERC20PermitUpgradeableDecimals, SafeAllowanceResetUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using SafeMathUpgradeable for uint256;


    // role that grants most of financial operations for Treasury (tresholds, etc.)
    bytes32 public constant FINMGMT_ROLE = keccak256("FINMGMT_ROLE");  // allowed to set tresholds and perform rebalancing
    // role that grants ability to spend and rebate bonuses
    bytes32 public constant EXECUTOR_ROLE = keccak256("EXECUTOR_ROLE"); // allowed to fetch asset portion (for gas subsidy)


    ///////////////////////////////////////////////////////////////////////////
    // BASE VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    address public baseToken;           // USDC
    uint256 public endowmentPercent;    // 1e18 percentage of yield portion that goes to endowment, can be changed, won't affect current bonuses
    uint256 public endowmentBalance;    // total endowment balance (in USDC)
    uint256 public bonusBalance;        // total bonus balance (in USDC) to help with accounting
    uint256 public burnLimit;           // 1e18 decimals of maximum tokens allowed to be burned in on tx (default is 1e17=10%)
    uint256 public burnEndowmentMultiplier; // 1e18 when burning tokens, endowment


    ///////////////////////////////////////////////////////////////////////////
    // STAKING/UNSTAKING VARIABLES AND EVENTS
    ///////////////////////////////////////////////////////////////////////////
    // supported tokens for staking into treasury are Mover (MOVE) token and MOVE-ETH LP token from sushiswap pool
    // as mentioned in yellow paper, we don't create stakeable tokens data as array to save gas, expansion could be done via contract upgrade
    address public tokenMoveAddress;
    uint public tokenMoveWeight;
    address public tokenMoveEthLPAddress;
    uint public tokenMoveEthLPWeight;

    event Deposit(address indexed account, uint256 amountMove, uint256 amountMoveEthLP);
    event Withdraw(address indexed account, uint256 amountMove, uint256 amountMoveEthLP);
    event EmergencyWithdraw(address indexed account, uint256 amountMove, uint256 amountMoveEthLP);
    event ReceiveProfit(uint256 amountEndowment, uint256 amountBonus);


    uint256 accBonusPerShareMove;
    uint256 accBonusPerShareMoveEthLP;
    uint256 public totalStakedMove;
    uint256 public totalStakedMoveEthLP;

    struct UserInfo {
        uint256 amount;
        uint256 rewardTally;
    }

    mapping (address => UserInfo) public userInfoMove;
    mapping (address => UserInfo) public userInfoMoveEthLP;


    ///////////////////////////////////////////////////////////////////////////
    // EMERGENCY TRANSFER (TIMELOCKED) VARIABLES AND EVENTS
    ///////////////////////////////////////////////////////////////////////////
    event EmergencyTransferSet(
        address indexed token,
        address indexed destination,
        uint256 amount
    );
    event EmergencyTransferExecute(
        address indexed token,
        address indexed destination,
        uint256 amount
    );
    address private emergencyTransferToken;
    address private emergencyTransferDestination;
    uint256 private emergencyTransferTimestamp;
    uint256 private emergencyTransferAmount;


    ///////////////////////////////////////////////////////////////////////////
    // CLAIM & BURN EVENTS
    ///////////////////////////////////////////////////////////////////////////
    event ClaimAndBurn(address indexed account, uint256 amountMove, uint256 amountCompensation);
    
    // for simple DPY stats calculation
    uint256 public inceptionTimestamp;    // inception timestamp

    ///////////////////////////////////////////////////////////////////////////
    // CONSTRUCTOR/INITIALIZER
    ///////////////////////////////////////////////////////////////////////////
    // NOTE: BONUS TOKENS SHOULD CONTAIN SAME DECIMALS AS BASE ASSET (USDC=6)
    function initialize(string memory name, 
                        string memory symbol, 
                        address _baseToken, // USDC
                        address _tokenMove, // MOVE
                        address _tokenMoveEth) // Sushiswap MOVE-ETH LP
                        public initializer {
        __Context_init_unchained();
        __AccessControl_init_unchained();
        __ERC20_init_unchained(name, symbol, 6); // bonus token has 6 decimals as USDC
        __ERC20Burnable_init_unchained();
        __Pausable_init_unchained();
        __ERC20Pausable_init_unchained();
        __ERC20PresetMinterPauser_init_unchained(name, symbol); // sets up DEFAULT_ADMIN_ROLE
        __ERC20Permit_init(name);

        baseToken = _baseToken;
        tokenMoveAddress = _tokenMove;
        tokenMoveEthLPAddress = _tokenMoveEth;

        inceptionTimestamp = block.timestamp;

        endowmentPercent = 50000000000000000000; // 50% of yield goes to endowment
        endowmentBalance = 0;
        bonusBalance = 0;
        burnLimit = 100000000000000000; // 0.1, 10% of supply could be burned in one tx
        tokenMoveWeight = 1000;
        tokenMoveEthLPWeight = 2500;
        burnEndowmentMultiplier = 4000000000000000000; // 4x multiplier for burn operation
    }
    

    ///////////////////////////////////////////////////////////////////////////
    // FINMGMT FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////

    function setEndowmentPercentage(uint256 _endowmentPercent) public {
        require(hasRole(FINMGMT_ROLE, msg.sender), "finmgmt only");
        endowmentPercent = _endowmentPercent;
    }

    function setBurnLimit(uint256 _burnLimit) public {
        require(hasRole(FINMGMT_ROLE, msg.sender), "finmgmt only");
        burnLimit = _burnLimit;
    }

    function setEndowmentBurnMultiplier(uint256 _burnEndowmentMultiplier) public {
        require(hasRole(FINMGMT_ROLE, msg.sender), "finmgmt only");
        burnEndowmentMultiplier = _burnEndowmentMultiplier;
    }

    ///////////////////////////////////////////////////////////////////////////
    // TREASURY STAKE/UNSTAKE FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////

    function pendingBonus(address _account) public view returns(uint256) {
        UserInfo storage userMove = userInfoMove[_account];
        UserInfo storage userMoveEthLP = userInfoMoveEthLP[_account];

        uint256 pendingBonusMove = userMove.amount.mul(accBonusPerShareMove).div(1e24).sub(userMove.rewardTally);
        return pendingBonusMove.add(userMoveEthLP.amount.mul(accBonusPerShareMoveEthLP).div(1e24).sub(userMoveEthLP.rewardTally));
    }

    // returns available bonus, including inner balance and tokens on wallet address
    function totalBonus(address _account) public view returns(uint256) {
        uint256 balancePending = pendingBonus(_account);
        uint256 balanceTokens = IERC20Upgradeable(address(this)).balanceOf(_account);
        return balancePending.add(balanceTokens);
    }

    // users should stake treasury through transfer proxy to avoid setting allowance to this contract for staked tokens
    function deposit(uint _tokenMoveAmount, uint _tokenMoveEthAmount) public {
        depositInternal(msg.sender, _tokenMoveAmount, _tokenMoveEthAmount, false);
    }

    function depositInternal(address _account, uint _tokenMoveAmount, uint _tokenMoveEthAmount, bool _skipTransfer) internal {

        UserInfo storage userMove = userInfoMove[_account];
        UserInfo storage userMoveEthLP = userInfoMoveEthLP[_account];

        //updateBonusCalculation();

        // if harvest wasn't performed for a long time, perform harvest
        if (block.number.sub(sushiHarvestedBlock) > HARVEST_BLOCK_TRESHOLD) {
            withdrawSLPint(0);
        }

        // if SLP tokens were staked, distribute SUSHI rewards
        if (userMoveEthLP.amount > 0) {
            rewardSushi(_account);
        }

        if (userMove.amount > 0 || userMoveEthLP.amount > 0) {
            uint256 pending = userMove.amount.mul(accBonusPerShareMove).div(1e24).sub(userMove.rewardTally);
            pending = pending.add(userMoveEthLP.amount.mul(accBonusPerShareMoveEthLP).div(1e24).sub(userMoveEthLP.rewardTally));
            if(pending > 0) {
                _mint(_account, pending); //pay the earned tokens when user deposits
            }
        }

        // this condition would save some gas on harvest calls
        if (_tokenMoveAmount > 0) {
            if(!_skipTransfer) {
                IERC20Upgradeable(tokenMoveAddress).safeTransferFrom(msg.sender, address(this), _tokenMoveAmount);
            }
            userMove.amount = userMove.amount.add(_tokenMoveAmount);
            totalStakedMove = totalStakedMove.add(_tokenMoveAmount);
        }
        if (_tokenMoveEthAmount > 0) {
            if(!_skipTransfer) {
                IERC20Upgradeable(tokenMoveEthLPAddress).safeTransferFrom(msg.sender, address(this), _tokenMoveEthAmount);
            }
            userMoveEthLP.amount = userMoveEthLP.amount.add(_tokenMoveEthAmount);
            totalStakedMoveEthLP = totalStakedMoveEthLP.add(_tokenMoveEthAmount);
        }

        userMove.rewardTally = userMove.amount.mul(accBonusPerShareMove).div(1e24);
        userMoveEthLP.rewardTally = userMoveEthLP.amount.mul(accBonusPerShareMoveEthLP).div(1e24);

        sushiRewardTally[_account] = userMoveEthLP.amount.mul(accSushiPerShare).div(1e24);

        emit Deposit(_account, _tokenMoveAmount, _tokenMoveEthAmount);
    }

    function withdraw(uint _tokenMoveAmount, uint _tokenMoveEthAmount) public {
        withdrawInternal(msg.sender, _tokenMoveAmount, _tokenMoveEthAmount);
    }

    function withdrawInternal(address _account, uint _tokenMoveAmount, uint _tokenMoveEthAmount) internal {

        UserInfo storage userMove = userInfoMove[_account];
        UserInfo storage userMoveEthLP = userInfoMoveEthLP[_account];

        //updateBonusCalculation();

        // if there's not enough SLP tokens, withdraw staked from MasterChef, this would also trigger harvest
        if (_tokenMoveEthAmount > 0) {
            uint256 slpBalance = IERC20Upgradeable(tokenMoveEthLPAddress).balanceOf(address(this));
            if (_tokenMoveEthAmount > slpBalance) {
                withdrawSLPint(_tokenMoveEthAmount.sub(slpBalance));
            }
        }
        
        // if harvest wasn't performed for a long time, perform harvest
        if (block.number.sub(sushiHarvestedBlock) > HARVEST_BLOCK_TRESHOLD) {
            withdrawSLPint(0);
        }

        // if SLP tokens were staked, distribute SUSHI rewards
        if (userMoveEthLP.amount > 0) {
            rewardSushi(_account);
        }

        if (userMove.amount > 0 || userMoveEthLP.amount > 0) {
            uint256 pending = userMove.amount.mul(accBonusPerShareMove).div(1e24).sub(userMove.rewardTally);
            pending = pending.add(userMoveEthLP.amount.mul(accBonusPerShareMoveEthLP).div(1e24).sub(userMoveEthLP.rewardTally));
            if(pending > 0) {
                _mint(_account, pending); //pay the earned tokens when user deposits
            }
        }

        require(userMove.amount >= _tokenMoveAmount, "withdraw: insufficient balance");
        require(userMoveEthLP.amount >= _tokenMoveEthAmount, "withdraw: insufficient balance");

        if (_tokenMoveAmount > 0) {
            IERC20Upgradeable(tokenMoveAddress).safeTransfer(address(_account), _tokenMoveAmount);
        }
        if (_tokenMoveEthAmount > 0) {
            IERC20Upgradeable(tokenMoveEthLPAddress).safeTransfer(address(_account), _tokenMoveEthAmount);
        }

        totalStakedMove = totalStakedMove.sub(_tokenMoveAmount);
        totalStakedMoveEthLP = totalStakedMoveEthLP.sub(_tokenMoveEthAmount);

        userMove.amount = userMove.amount.sub(_tokenMoveAmount);
        userMove.rewardTally = userMove.amount.mul(accBonusPerShareMove).div(1e24);
        userMoveEthLP.amount = userMoveEthLP.amount.sub(_tokenMoveEthAmount);
        userMoveEthLP.rewardTally = userMoveEthLP.amount.mul(accBonusPerShareMoveEthLP).div(1e24);

        sushiRewardTally[_account] = userMoveEthLP.amount.mul(accSushiPerShare).div(1e24);

        emit Withdraw(_account, _tokenMoveAmount, _tokenMoveEthAmount);
    }

    function emergencyWithdraw() public {
        UserInfo storage userMove = userInfoMove[msg.sender];
        UserInfo storage userMoveEthLP = userInfoMoveEthLP[msg.sender];

        // if there's not enough SLP tokens, withdraw staked from MasterChef
        if (userMoveEthLP.amount > 0) {
            uint256 slpBalance = IERC20Upgradeable(tokenMoveEthLPAddress).balanceOf(address(this));
            if (userMoveEthLP.amount > slpBalance) {
                withdrawSLPint(userMoveEthLP.amount.sub(slpBalance));
            }
        }

        IERC20Upgradeable(tokenMoveAddress).safeTransfer(address(msg.sender), userMove.amount);
        IERC20Upgradeable(tokenMoveEthLPAddress).safeTransfer(address(msg.sender), userMoveEthLP.amount);

        totalStakedMove = totalStakedMove.sub(userMove.amount);
        totalStakedMoveEthLP = totalStakedMoveEthLP.sub(userMoveEthLP.amount);

        emit EmergencyWithdraw(msg.sender, userMove.amount, userMove.rewardTally);

        userMove.amount = 0;
        userMove.rewardTally = 0;
        userMoveEthLP.amount = 0;
        userMoveEthLP.rewardTally = 0;

        sushiRewardTally[msg.sender] = 0;
    }

    // called when profit distribution occurs by profit distributor contract
    // but can be called by anyone (e.g. for donation)
    function receiveProfit(uint256 _amount) public {
        // transfer base token (USDC) to this contract
        IERC20Upgradeable(baseToken).safeTransferFrom(msg.sender, address(this), _amount);

        // if nothing is taked into treasury, fulfill only endowment portion
        if (totalStakedMove == 0 && totalStakedMoveEthLP == 0) {
            endowmentBalance = endowmentBalance.add(_amount);
            return;
        }

        uint256 endowmentPortion = _amount.mul(endowmentPercent).div(100000000000000000000);
        uint256 bonusPortion = _amount.sub(endowmentPortion);

        endowmentBalance = endowmentBalance.add(endowmentPortion);
        bonusBalance = bonusBalance.add(bonusPortion);

        //uint256 totalWeight = tokenMoveWeight + tokenMoveEthLPWeight;
        uint256 totalShares = totalStakedMove.mul(tokenMoveWeight).add(totalStakedMoveEthLP.mul(tokenMoveEthLPWeight));

        uint256 bonusPortionMove = bonusPortion.mul(totalStakedMove).mul(tokenMoveWeight).div(totalShares);
        uint256 bonusPortionMoveEthLP = bonusPortion.sub(bonusPortionMove);

        if (totalStakedMove > 0) {
            accBonusPerShareMove = accBonusPerShareMove.add(bonusPortionMove.mul(1e24).div(totalStakedMove));
        }
        if (totalStakedMoveEthLP > 0) {
            accBonusPerShareMoveEthLP = accBonusPerShareMoveEthLP.add(bonusPortionMoveEthLP.mul(1e24).div(totalStakedMoveEthLP));
        }

        emit ReceiveProfit(endowmentPortion, bonusPortion);
    }


    ///////////////////////////////////////////////////////////////////////////
    // SUBSIDIZED EXECUTION FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////

    // called by execution proxy when spending bonus on subsidized txes
    // or correction if actual gas spending was higher than actual
    // would also be used for KYC costs, etc.
    function spendBonus(address _account, uint256 _amount) public {
        require(hasRole(EXECUTOR_ROLE, msg.sender), "executor only");
        spendBonusInternal(_account, _amount);
    }
        
    function spendBonusInternal(address _account, uint256 _amount) internal {
        UserInfo storage userMove = userInfoMove[_account];
        UserInfo storage userMoveEthLP = userInfoMoveEthLP[_account];
        uint256 pendingBonusMove = userMove.amount.mul(accBonusPerShareMove).div(1e24).sub(userMove.rewardTally);
        uint256 pendingBonusMoveEthLP = userMoveEthLP.amount.mul(accBonusPerShareMoveEthLP).div(1e24).sub(userMoveEthLP.rewardTally);
        uint256 tokenBonus = IERC20Upgradeable(this).balanceOf(_account);

        require(pendingBonusMove.add(pendingBonusMoveEthLP).add(tokenBonus) >= _amount, "not enough bonus");

        // spend pending bonus first, MOVE-ETH LP bonus first
        if (pendingBonusMoveEthLP >= _amount) {
            // spend only pending MOVE-ETH LP bonus
            userMoveEthLP.rewardTally = userMoveEthLP.rewardTally.add(_amount);
        } else if (pendingBonusMove.add(pendingBonusMoveEthLP) >= _amount) {
            // spend all pending MOVE-ETH LP bonus and portion of pending MOVE-ETH bonus
            userMoveEthLP.rewardTally = userMoveEthLP.amount.mul(accBonusPerShareMoveEthLP).div(1e24); // set zero-point
            userMove.rewardTally = userMove.rewardTally.add(_amount.sub(pendingBonusMoveEthLP));
        } else {
            // spend all pending MOVE-ETH LP bonus, all pending MOVE-ETH bonus and burn some tokens
            userMove.rewardTally = userMove.amount.mul(accBonusPerShareMove).div(1e24); // set zero-point
            userMoveEthLP.rewardTally = userMoveEthLP.amount.mul(accBonusPerShareMoveEthLP).div(1e24); // set zero-point
            _burn(_account, _amount.sub(pendingBonusMove).sub(pendingBonusMoveEthLP));
        }

        bonusBalance = bonusBalance.sub(_amount);
    }

    // called by execution proxy if gas spending is less than actual
    // rebate is issued in form of tokens
    function rebateBonus(address _account, uint256 _amount) public {        
        require(hasRole(EXECUTOR_ROLE, msg.sender), "executor only");
        _mint(_account, _amount);
        bonusBalance = bonusBalance.add(_amount);
    }

    // deposit not requiring allowance of MOVE or MOVE-ETH LP for this contract
    // actual transfer is organized beforehand by trusted party (execution proxy)
    function depositOnBehalf(address _account, uint _tokenMoveAmount, uint _tokenMoveEthAmount) public {
        require(hasRole(EXECUTOR_ROLE, msg.sender), "executor only");
        depositInternal(_account, _tokenMoveAmount, _tokenMoveEthAmount, true);
    }

    function withdrawOnBehalf(address _account, uint _tokenMoveAmount, uint _tokenMoveEthAmount) public {
        require(hasRole(EXECUTOR_ROLE, msg.sender), "executor only");
        withdrawInternal(_account, _tokenMoveAmount, _tokenMoveEthAmount);
    }

    ///////////////////////////////////////////////////////////////////////////
    // CLAIM & BURN FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////

    function maxBurnAmount() public view returns(uint256) {
        uint256 totalSupply = IERC20Upgradeable(tokenMoveAddress).totalSupply();
        return totalSupply.mul(burnLimit).div(1000000000000000000);
    }

    function getBurnValue(address _account, uint256 _amount) public view returns(uint256) {
        (uint256 endowmentPortion, uint256 bonusPortion) = getBurnValuePortions(_account, _amount);
        return endowmentPortion.add(bonusPortion);
    }

    function getBurnValuePortions(address _account, uint256 _amount) public view returns(uint256, uint256) {
        uint256 totalSupply = IERC20Upgradeable(tokenMoveAddress).totalSupply();
        uint256 endowmentPortion = _amount.mul(1000000000000000000).div(totalSupply).mul(endowmentBalance).div(1000000000000000000);

        uint256 bonusPortion = totalBonus(_account); 
        // bonus compensation cannot be higher than MOVE burned portion (bonus tokens could be transferred)
        // to prevent burning bonus for USDC directly
        if (bonusPortion > endowmentPortion) {
            bonusPortion = endowmentPortion; 
        }

        // endowment portion has a multiplier for rewarding reducing number of MOVE tokens
        endowmentPortion = endowmentPortion.mul(burnEndowmentMultiplier).div(1e18);

        return (endowmentPortion, bonusPortion);
    }

    // executor proxy performs burn as it has allowance on MOVE token and calls this method
    function claimAndBurnOnBehalf(address _beneficiary, uint256 _amount) public {
        require(hasRole(EXECUTOR_ROLE, msg.sender), "executor only");
        require(_amount <= maxBurnAmount(), "max amount exceeded");

        (uint256 endowmentPortion, uint256 bonusPortion) = getBurnValuePortions(_beneficiary, _amount);

        if (bonusPortion > 0) {
            spendBonusInternal(_beneficiary, bonusPortion);
        }

        // if not enough balance, divest funds from yield generating products
        // (this is undesireable, should be covered by rebalancer)
        // if (IERC20Upgradeable(baseToken).balanceOf(address(this)) < endowmentPortion.add(bonusPortion)) {
            // TODO: perform rebalance (should be required when treasury stakes its portion)
        //}

        uint256 baseTokenToTransfer = endowmentPortion.add(bonusPortion);
        IERC20Upgradeable(baseToken).safeTransfer(_beneficiary, baseTokenToTransfer);
        endowmentBalance = endowmentBalance.sub(endowmentPortion);
        emit ClaimAndBurn(_beneficiary, _amount, baseTokenToTransfer);
    }

    // This is oversimplified, no compounding and averaged across timespan from inception
    // we don't know price of MOVE token here, so it should be divided by MOVE price in apps
    function getDPYPerMoveToken() public view returns(uint256) {
      uint256 secondsFromInception = block.timestamp.sub(inceptionTimestamp);
      
      // calculate as total amassed endowment valuation to total number of tokens staked
      uint256 totalMoveStakedEquivalent = totalStakedMove;

      // add equivalent underlying MOVE for MOVE-ETH LP
      uint256 moveInLP = IERC20Upgradeable(tokenMoveEthLPAddress).balanceOf(tokenMoveAddress);
      uint256 totalLP = IERC20Upgradeable(tokenMoveEthLPAddress).totalSupply();
      if (totalLP > 0) {
        totalMoveStakedEquivalent = totalMoveStakedEquivalent.add(totalStakedMoveEthLP.mul(moveInLP).div(totalLP));
      }
      
      if (totalMoveStakedEquivalent == 0) {
          return 0; // no APY can be formulated as zero tokens staked
      }

      // endowmentBalance has 6 decimals as USDC, so to get 1e18 decimals, multiply by 1e12 and by 100 to get %
      uint256 baseAssetPerDay = endowmentBalance.mul(1e12).mul(100).mul(86400).div(secondsFromInception);

      return baseAssetPerDay.mul(1e18).div(totalMoveStakedEquivalent);
    }


    ///////////////////////////////////////////////////////////////////////////
    // ERC20 MOVER BONUS TOKEN FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20PresetMinterPauserUpgradeableDecimals, ERC20UpgradeableDecimals) {
        super._beforeTokenTransfer(from, to, amount);
    }

    // add new variables that can be renamed
    string private _token_name;
    string private _token_symbol;

    function name() public override view returns (string memory) {
        return _token_name;
    }

    function symbol() public override view returns (string memory) {
        return _token_symbol;
    }

    // set the name and symbol for the token
    // callable only by admin
    function setTokenName(string memory _symbol, string memory _name) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
        _token_name = _name;
        _token_symbol = _symbol;
        _EIP712SetNameHash(_name);
    }

    // airdrop tokens (used to distributed bonus tokens)
	// callable only by admin
	function airdropTokens(address[] calldata _recipients, uint256[] calldata _amounts) public {
		require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
        require(_recipients.length == _amounts.length, "array length mismatch");
		for(uint256 i = 0; i < _recipients.length; i++) {
            _mint(_recipients[i], _amounts[i]);
        }
	}


    ///////////////////////////////////////////////////////////////////////////
    // EMERGENCY FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////

    // emergencyTransferTimelockSet is for safety (if some tokens got stuck)
    // in the future it could be removed, to restrict access to user funds
    // this is timelocked as contract can have user funds
    function emergencyTransferTimelockSet(
        address _token,
        address _destination,
        uint256 _amount
    ) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
        emergencyTransferTimestamp = block.timestamp;
        emergencyTransferToken = _token;
        emergencyTransferDestination = _destination;
        emergencyTransferAmount = _amount;

        emit EmergencyTransferSet(_token, _destination, _amount);
    }

    function emergencyTransferExecute() public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
        require(
            block.timestamp > emergencyTransferTimestamp + 24 * 3600,
            "timelock too early"
        );
        require(
            block.timestamp < emergencyTransferTimestamp + 72 * 3600,
            "timelock too late"
        );

        IERC20Upgradeable(emergencyTransferToken).safeTransfer(
            emergencyTransferDestination,
            emergencyTransferAmount
        );

        emit EmergencyTransferExecute(
            emergencyTransferToken,
            emergencyTransferDestination,
            emergencyTransferAmount
        );
        // clear emergency transfer timelock data
        emergencyTransferTimestamp = 0;
        emergencyTransferToken = address(0);
        emergencyTransferDestination = address(0);
        emergencyTransferAmount = 0;
    }

    ///////////////////////////////////////////////////////////////////////////
    // SUSHI LP STAKING FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////
    //address public constant MASTERCHEF_ADDRESS = 0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd;
    //address public constant SUSHI_ADDRESS = 0x6B3595068778DD592e39A122f4f5a5cF09C90fE2;
    
    // this for tests only, reduce using] constants in PROD contract
    address public MASTERCHEF_ADDRESS;
    address public SUSHI_ADDRESS;
    uint public MASTERCHEF_POOLID;
    
    function setSushiAddresses(address _masterChef, address _sushiToken, uint _poolId) public {
        require(hasRole(FINMGMT_ROLE, msg.sender), "finmgmt only");
        MASTERCHEF_ADDRESS = _masterChef;
        SUSHI_ADDRESS = _sushiToken;
        MASTERCHEF_POOLID = _poolId;
    }

    uint256 private constant ALLOWANCE_SIZE = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    uint256 private constant HARVEST_BLOCK_TRESHOLD = 6400; // approximately one day
    
    // percentage of sushi that is allocated to Smart Treasury itself 1000000000000000000 = 1%
    uint256 public treasuryFeeSushi;
    // current sushi accumulated per single share
    uint256 public accSushiPerShare;
    // last block on which sushi were harvested
    uint256 public sushiHarvestedBlock;
    // sushi pending markings for accounts
    mapping (address => uint256) public sushiRewardTally;
    // Smart Treasury's own sushi
    uint256 public treasurySushi;
    event ReceiveSushi(uint256 sushiAmount);

    function setSushiFee(uint256 _feeSushi) public {
        require(hasRole(FINMGMT_ROLE, msg.sender), "finmgmt only");
        treasuryFeeSushi = _feeSushi;
    }

    // could also be used to harvest pending SUSHI rewards
    function depositSLP(uint256 _amount) public {
        require(hasRole(FINMGMT_ROLE, msg.sender), "finmgmt only");
        depositSLPint(_amount);
    }

    // could also be used to harvest pending SUSHI rewards
    function withdrawSLP(uint256 _amount) public {
        require(hasRole(FINMGMT_ROLE, msg.sender), "finmgmt only");
        withdrawSLPint(_amount);
    }

    function depositSLPint(uint256 _amount) internal {
        uint256 sushiBefore = IERC20Upgradeable(SUSHI_ADDRESS).balanceOf(address(this));

        resetAllowanceIfNeeded(IERC20Upgradeable(tokenMoveEthLPAddress), MASTERCHEF_ADDRESS, ALLOWANCE_SIZE);

        // make deposit call to MasterChef
        IMasterChef(MASTERCHEF_ADDRESS).deposit(MASTERCHEF_POOLID, _amount); // MOVE-ETH LP pool id is 257 (0x101)

        uint256 sushiAfter = IERC20Upgradeable(SUSHI_ADDRESS).balanceOf(address(this));
        distributeSushi(sushiBefore, sushiAfter);

        sushiHarvestedBlock = block.number;
    }

    // called by FINMGMT or when there's not enough SLP when someone withdraws
    function withdrawSLPint(uint256 _amount) internal {
        if (MASTERCHEF_ADDRESS == address(0)) {
            return; // sushi rewards staking is not enabled
        }

        uint256 sushiBefore = IERC20Upgradeable(SUSHI_ADDRESS).balanceOf(address(this));

        // make withdraw call to MasterChef
        IMasterChef(MASTERCHEF_ADDRESS).withdraw(MASTERCHEF_POOLID, _amount); // MOVE-ETH LP pool id is 257 (0x101)

        uint256 sushiAfter = IERC20Upgradeable(SUSHI_ADDRESS).balanceOf(address(this));
        distributeSushi(sushiBefore, sushiAfter);

        sushiHarvestedBlock = block.number;
    }

    function distributeSushi(uint256 _before, uint256 _after) internal {
        if (_before >= _after) {
            return; // don't revert, just do nothing
        }

        uint256 receivedSushi = _after.sub(_before);
        if (treasuryFeeSushi > 0) {
            uint256 sushitotreasury = receivedSushi.mul(treasuryFeeSushi).div(1e20);
            treasurySushi = treasurySushi.add(sushitotreasury);
            receivedSushi = receivedSushi.sub(sushitotreasury);
        }

        accSushiPerShare = accSushiPerShare.add(receivedSushi.mul(1e24).div(totalStakedMoveEthLP));
        emit ReceiveSushi(receivedSushi);
    }

    function rewardSushi(address _account) internal {
        UserInfo storage userMoveEthLP = userInfoMoveEthLP[_account];
        if (userMoveEthLP.amount == 0) {
            return; // no SUSHI rewards if no SLPs staked
        }

        uint256 pendingSushi = userMoveEthLP.amount.mul(accSushiPerShare).div(1e24).sub(sushiRewardTally[_account]);
        if(pendingSushi > 0) {
            IERC20Upgradeable(SUSHI_ADDRESS).safeTransfer(_account, pendingSushi); //pay the earned SUSHI rewards
        }
    }

    function getTreasurySushi(uint256 _amount, address _receiver) public {
        require(hasRole(FINMGMT_ROLE, msg.sender), "finmgmt only");
        require(_amount <= treasurySushi, "amount exceeds balance");
        IERC20Upgradeable(SUSHI_ADDRESS).safeTransfer(_receiver, _amount);
        treasurySushi = treasurySushi.sub(_amount);
    }
}