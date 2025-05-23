pragma solidity 0.5.17;

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

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts

        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned

        // for accounts without code, i.e. `keccak256('')`

        bytes32 codehash;





            bytes32 accountHash

         = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly {

            codehash := extcodehash(account)

        }

        return (codehash != accountHash && codehash != 0x0);

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

        require(

            address(this).balance >= amount,

            'Address: insufficient balance'

        );



        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

        (bool success, ) = recipient.call.value(amount)('');

        require(

            success,

            'Address: unable to send value, recipient may have reverted'

        );

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

    function functionCall(address target, bytes memory data)

        internal

        returns (bytes memory)

    {

        return functionCall(target, data, 'Address: low-level call failed');

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with

     * `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCall(

        address target,

        bytes memory data,

        string memory errorMessage

    ) internal returns (bytes memory) {

        return _functionCallWithValue(target, data, 0, errorMessage);

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

    function functionCallWithValue(

        address target,

        bytes memory data,

        uint256 value

    ) internal returns (bytes memory) {

        return

            functionCallWithValue(

                target,

                data,

                value,

                'Address: low-level call with value failed'

            );

    }



    /**

     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but

     * with `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(

        address target,

        bytes memory data,

        uint256 value,

        string memory errorMessage

    ) internal returns (bytes memory) {

        require(

            address(this).balance >= value,

            'Address: insufficient balance for call'

        );

        return _functionCallWithValue(target, data, value, errorMessage);

    }



    function _functionCallWithValue(

        address target,

        bytes memory data,

        uint256 weiValue,

        string memory errorMessage

    ) private returns (bytes memory) {

        require(isContract(target), 'Address: call to non-contract');



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.call.value(weiValue)(

            data

        );

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

contract Context {

    function _msgSender() internal view returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}

contract ERC20 is Context {

    using SafeMath for uint256;

    using Address for address;



    mapping(address => uint256) private _balances;



    mapping(address => mapping(address => uint256)) private _allowances;



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

    constructor(string memory name, string memory symbol) public {

        _name = name;

        _symbol = symbol;

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

    function totalSupply() public view returns (uint256) {

        return _totalSupply;

    }



    /**

     * @dev See {IERC20-balanceOf}.

     */

    function balanceOf(address account) public view returns (uint256) {

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

    function transfer(address recipient, uint256 amount) public returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    /**

     * @dev See {IERC20-allowance}.

     */

    function allowance(address owner, address spender)

        public

        view

        returns (uint256)

    {

        return _allowances[owner][spender];

    }



    /**

     * @dev See {IERC20-approve}.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function approve(address spender, uint256 amount) public returns (bool) {

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

    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) public returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(

            sender,

            _msgSender(),

            _allowances[sender][_msgSender()].sub(

                amount,

                'ERC20: transfer amount exceeds allowance'

            )

        );

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

    function increaseAllowance(address spender, uint256 addedValue)

        public

        returns (bool)

    {

        _approve(

            _msgSender(),

            spender,

            _allowances[_msgSender()][spender].add(addedValue)

        );

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

    function decreaseAllowance(address spender, uint256 subtractedValue)

        public

        returns (bool)

    {

        _approve(

            _msgSender(),

            spender,

            _allowances[_msgSender()][spender].sub(

                subtractedValue,

                'ERC20: decreased allowance below zero'

            )

        );

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

    function _transfer(

        address sender,

        address recipient,

        uint256 amount

    ) internal {

        require(sender != address(0), 'ERC20: transfer from the zero address');

        require(recipient != address(0), 'ERC20: transfer to the zero address');



        _beforeTokenTransfer(sender, recipient, amount);



        _balances[sender] = _balances[sender].sub(

            amount,

            'ERC20: transfer amount exceeds balance'

        );

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

    function _mint(address account, uint256 amount) internal {

        require(account != address(0), 'ERC20: mint to the zero address');



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

    function _burn(address account, uint256 amount) internal {

        require(account != address(0), 'ERC20: burn from the zero address');



        _beforeTokenTransfer(account, address(0), amount);



        _balances[account] = _balances[account].sub(

            amount,

            'ERC20: burn amount exceeds balance'

        );

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

    function _approve(

        address owner,

        address spender,

        uint256 amount

    ) internal {

        require(owner != address(0), 'ERC20: approve from the zero address');

        require(spender != address(0), 'ERC20: approve to the zero address');



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

    function _beforeTokenTransfer(

        address from,

        address to,

        uint256 amount

    ) internal {}



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

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );

}

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

    function transfer(address recipient, uint256 amount)

        external

        returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through {transferFrom}. This is

     * zero by default.

     *

     * This value changes when {approve} or {transferFrom} are called.

     */

    function allowance(address owner, address spender)

        external

        view

        returns (uint256);



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

    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) external returns (bool);



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

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );

}

contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(

        address indexed previousOwner,

        address indexed newOwner

    );



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor() internal {

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

        require(_owner == _msgSender(), 'Ownable: caller is not the owner');

        _;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public onlyOwner {

        require(

            newOwner != address(0),

            'Ownable: new owner is the zero address'

        );

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}

library SafeERC20 {

    using SafeMath for uint256;

    using Address for address;



    function safeTransfer(

        IERC20 token,

        address to,

        uint256 value

    ) internal {

        _callOptionalReturn(

            token,

            abi.encodeWithSelector(token.transfer.selector, to, value)

        );

    }



    function safeTransferFrom(

        IERC20 token,

        address from,

        address to,

        uint256 value

    ) internal {

        _callOptionalReturn(

            token,

            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)

        );

    }



    /**

     * @dev Deprecated. This function has issues similar to the ones found in

     * {IERC20-approve}, and its usage is discouraged.

     *

     * Whenever possible, use {safeIncreaseAllowance} and

     * {safeDecreaseAllowance} instead.

     */

    function safeApprove(

        IERC20 token,

        address spender,

        uint256 value

    ) internal {

        // safeApprove should only be called when setting an initial allowance,

        // or when resetting it to zero. To increase and decrease it, use

        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'

        // solhint-disable-next-line max-line-length

        require(

            (value == 0) || (token.allowance(address(this), spender) == 0),

            'SafeERC20: approve from non-zero to non-zero allowance'

        );

        _callOptionalReturn(

            token,

            abi.encodeWithSelector(token.approve.selector, spender, value)

        );

    }



    function safeIncreaseAllowance(

        IERC20 token,

        address spender,

        uint256 value

    ) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(

            value

        );

        _callOptionalReturn(

            token,

            abi.encodeWithSelector(

                token.approve.selector,

                spender,

                newAllowance

            )

        );

    }



    function safeDecreaseAllowance(

        IERC20 token,

        address spender,

        uint256 value

    ) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(

            value,

            'SafeERC20: decreased allowance below zero'

        );

        _callOptionalReturn(

            token,

            abi.encodeWithSelector(

                token.approve.selector,

                spender,

                newAllowance

            )

        );

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



        bytes memory returndata = address(token).functionCall(

            data,

            'SafeERC20: low-level call failed'

        );

        if (returndata.length > 0) {

            // Return data is optional

            // solhint-disable-next-line max-line-length

            require(

                abi.decode(returndata, (bool)),

                'SafeERC20: ERC20 operation did not succeed'

            );

        }

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

     *

     * - Addition cannot overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, 'SafeMath: addition overflow');



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

        return sub(a, b, 'SafeMath: subtraction overflow');

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

    function sub(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

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

        require(c / a == b, 'SafeMath: multiplication overflow');



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

        return div(a, b, 'SafeMath: division by zero');

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

    function div(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

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

        return mod(a, b, 'SafeMath: modulo by zero');

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

    function mod(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}

interface IMigratorChef {

    // Perform LP token migration from legacy UniswapV2 to KatanaSwap.

    // Take the current LP token address and return the new LP token address.

    // Migrator should have full access to the caller's LP token.

    // Return the new LP token address.

    //

    // XXX Migrator must have allowance access to UniswapV2 LP tokens.

    // KatanaSwap must mint EXACTLY the same amount of KatanaSwap LP tokens or

    // else something bad will happen. Traditional UniswapV2 does not

    // do that so be careful!

    function migrate(IERC20 token) external returns (IERC20);

}

contract Samurai is Ownable {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;



    // Info of each user.

    struct UserInfo {

        uint256 amount; // How many LP tokens the user has provided.

        uint256 rewardDebt; // Reward debt. See explanation below.

        //

        // We do some fancy math here. Basically, any point in time, the amount of KATANAs

        // entitled to a user but is pending to be distributed is:

        //

        //   pending reward = (user.amount * pool.accPerShare) - user.rewardDebt

        //

        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:

        //   1. The pool's `accKatanaPerShare` (and `lastRewardBlock`) gets updated.

        //   2. User receives the pending reward sent to his/her address.

        //   3. User's `amount` gets updated.

        //   4. User's `rewardDebt` gets updated.

    }



    // Info of each pool.

    struct PoolInfo {

        IERC20 lpToken; // Address of LP token contract.

        uint256 allocPoint; // How many allocation points assigned to this pool. KATANAs to distribute per block.

        uint256 lastRewardBlock; // Last block number that KATANAs distribution occurs.

        uint256 accKatanaPerShare; // Accumulated KATANAs per share, times 1e12. See below.

    }



    // The KATANA TOKEN!

    KatanaToken public katana;

    // Dev address.

    address public devaddr;

    // Block number when bonus KATANA period ends.

    uint256 public bonusEndBlock;

    // KATANA tokens created per block.

    uint256 public katanaPerBlock;

    // Reward distribution end block

    uint256 public rewardsEndBlock;

    // Bonus muliplier for early katana makers.

    uint256 public constant BONUS_MULTIPLIER = 3;

    // The migrator contract. It has a lot of power. Can only be set through governance (owner).

    IMigratorChef public migrator;



    // Info of each pool.

    PoolInfo[] public poolInfo;

    mapping(address => bool) public lpTokenExistsInPool;

    // Info of each user that stakes LP tokens.

    mapping(uint256 => mapping(address => UserInfo)) public userInfo;

    // Total allocation poitns. Must be the sum of all allocation points in all pools.

    uint256 public totalAllocPoint = 0;

    // The block number when KATANA mining starts.

    uint256 public startBlock;



    uint256 public blockInAMonth = 97500;

    uint256 public halvePeriod = blockInAMonth;

    uint256 public lastHalveBlock;



    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);

    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);

    event EmergencyWithdraw(

        address indexed user,

        uint256 indexed pid,

        uint256 amount

    );

    event Halve(uint256 newKatanaPerBlock, uint256 nextHalveBlockNumber);



    constructor(

        KatanaToken _katana,

        address _devaddr,

        uint256 _katanaPerBlock,

        uint256 _startBlock,

        uint256 _bonusEndBlock,

        uint256 _rewardsEndBlock

    ) public {

        katana = _katana;

        devaddr = _devaddr;

        katanaPerBlock = _katanaPerBlock;

        bonusEndBlock = _bonusEndBlock;

        startBlock = _startBlock;

        lastHalveBlock = _startBlock;

        rewardsEndBlock = _rewardsEndBlock;

    }



    function doHalvingCheck(bool _withUpdate) public {

        uint256 blockNumber = min(block.number, rewardsEndBlock);

        bool doHalve = blockNumber > lastHalveBlock + halvePeriod;

        if (!doHalve) {

            return;

        }

        uint256 newKatanaPerBlock = katanaPerBlock.div(2);

        katanaPerBlock = newKatanaPerBlock;

        lastHalveBlock = blockNumber;

        emit Halve(newKatanaPerBlock, blockNumber + halvePeriod);



        if (_withUpdate) {

            massUpdatePools();

        }

    }



    function poolLength() external view returns (uint256) {

        return poolInfo.length;

    }



    // Add a new lp to the pool. Can only be called by the owner.

    // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.

    function add(

        uint256 _allocPoint,

        IERC20 _lpToken,

        bool _withUpdate

    ) public onlyOwner {

        require(

            !lpTokenExistsInPool[address(_lpToken)],

            'Samurai: LP Token Address already exists in pool'

        );

        if (_withUpdate) {

            massUpdatePools();

        }

        uint256 blockNumber = min(block.number, rewardsEndBlock);

        uint256 lastRewardBlock = blockNumber > startBlock

            ? blockNumber

            : startBlock;

        totalAllocPoint = totalAllocPoint.add(_allocPoint);

        poolInfo.push(

            PoolInfo({

                lpToken: _lpToken,

                allocPoint: _allocPoint,

                lastRewardBlock: lastRewardBlock,

                accKatanaPerShare: 0

            })

        );

        lpTokenExistsInPool[address(_lpToken)] = true;

    }



    function updateLpTokenExists(address _lpTokenAddr, bool _isExists)

        external

        onlyOwner

    {

        lpTokenExistsInPool[_lpTokenAddr] = _isExists;

    }



    // Update the given pool's KATANA allocation point. Can only be called by the owner.

    function set(

        uint256 _pid,

        uint256 _allocPoint,

        bool _withUpdate

    ) public onlyOwner {

        if (_withUpdate) {

            massUpdatePools();

        }

        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(

            _allocPoint

        );

        poolInfo[_pid].allocPoint = _allocPoint;

    }



    // Set the migrator contract. Can only be called by the owner.

    function setMigrator(IMigratorChef _migrator) public onlyOwner {

        migrator = _migrator;

    }



    function migrate(uint256 _pid) public onlyOwner {

        require(

            address(migrator) != address(0),

            'Samurai: Address of migrator is null'

        );

        PoolInfo storage pool = poolInfo[_pid];

        IERC20 lpToken = pool.lpToken;

        uint256 bal = lpToken.balanceOf(address(this));

        lpToken.safeApprove(address(migrator), bal);

        IERC20 newLpToken = migrator.migrate(lpToken);

        require(

            !lpTokenExistsInPool[address(newLpToken)],

            'Samurai: New LP Token Address already exists in pool'

        );

        require(

            bal == newLpToken.balanceOf(address(this)),

            'Samurai: New LP Token balance incorrect'

        );

        pool.lpToken = newLpToken;

        lpTokenExistsInPool[address(newLpToken)] = true;

    }



    // Return reward multiplier over the given _from to _to block.

    function getMultiplier(uint256 _from, uint256 _to)

        public

        view

        returns (uint256)

    {

        if (_to <= bonusEndBlock) {

            return _to.sub(_from).mul(BONUS_MULTIPLIER);

        } else if (_from >= bonusEndBlock) {

            return _to.sub(_from);

        } else {

            return

                bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(

                    _to.sub(bonusEndBlock)

                );

        }

    }



    // View function to see pending KATANAs on frontend.

    function pendingKatana(uint256 _pid, address _user)

        external

        view

        returns (uint256)

    {

        PoolInfo storage pool = poolInfo[_pid];

        UserInfo storage user = userInfo[_pid][_user];

        uint256 accKatanaPerShare = pool.accKatanaPerShare;

        uint256 blockNumber = min(block.number, rewardsEndBlock);

        uint256 lpSupply = pool.lpToken.balanceOf(address(this));

        if (blockNumber > pool.lastRewardBlock && lpSupply != 0) {

            uint256 multiplier = getMultiplier(

                pool.lastRewardBlock,

                blockNumber

            );

            uint256 katanaReward = multiplier

                .mul(katanaPerBlock)

                .mul(pool.allocPoint)

                .div(totalAllocPoint);

            accKatanaPerShare = accKatanaPerShare.add(

                katanaReward.mul(1e12).div(lpSupply)

            );

        }

        return user.amount.mul(accKatanaPerShare).div(1e12).sub(user.rewardDebt);

    }



    // Update reward vairables for all pools. Be careful of gas spending!

    function massUpdatePools() public {

        uint256 length = poolInfo.length;

        for (uint256 pid = 0; pid < length; ++pid) {

            updatePool(pid);

        }

    }



    // Update reward variables of the given pool to be up-to-date.

    function updatePool(uint256 _pid) public {

        doHalvingCheck(false);

        PoolInfo storage pool = poolInfo[_pid];

        uint256 blockNumber = min(block.number, rewardsEndBlock);

        if (blockNumber <= pool.lastRewardBlock) {

            return;

        }

        uint256 lpSupply = pool.lpToken.balanceOf(address(this));

        if (lpSupply == 0) {

            pool.lastRewardBlock = blockNumber;

            return;

        }

        uint256 multiplier = getMultiplier(pool.lastRewardBlock, blockNumber);

        uint256 katanaReward = multiplier

            .mul(katanaPerBlock)

            .mul(pool.allocPoint)

            .div(totalAllocPoint);

        katana.mint(devaddr, katanaReward.div(10));

        katana.mint(address(this), katanaReward);

        pool.accKatanaPerShare = pool.accKatanaPerShare.add(

            katanaReward.mul(1e12).div(lpSupply)

        );

        pool.lastRewardBlock = blockNumber;

    }



    // Deposit LP tokens to Samurai for KATANA allocation.

    function deposit(uint256 _pid, uint256 _amount) public {

        PoolInfo storage pool = poolInfo[_pid];

        UserInfo storage user = userInfo[_pid][msg.sender];

        updatePool(_pid);

        if (user.amount > 0) {

            uint256 pending = user

                .amount

                .mul(pool.accKatanaPerShare)

                .div(1e12)

                .sub(user.rewardDebt);

            safeKatanaTransfer(msg.sender, pending);

        }

        pool.lpToken.safeTransferFrom(

            address(msg.sender),

            address(this),

            _amount

        );

        user.amount = user.amount.add(_amount);

        user.rewardDebt = user.amount.mul(pool.accKatanaPerShare).div(1e12);

        emit Deposit(msg.sender, _pid, _amount);

    }



    // Withdraw LP tokens from Samurai.

    function withdraw(uint256 _pid, uint256 _amount) public {

        PoolInfo storage pool = poolInfo[_pid];

        UserInfo storage user = userInfo[_pid][msg.sender];

        require(

            user.amount >= _amount,

            'Samurai: Insufficient Amount to withdraw'

        );

        updatePool(_pid);

        uint256 pending = user.amount.mul(pool.accKatanaPerShare).div(1e12).sub(

            user.rewardDebt

        );

        safeKatanaTransfer(msg.sender, pending);

        user.amount = user.amount.sub(_amount);

        user.rewardDebt = user.amount.mul(pool.accKatanaPerShare).div(1e12);

        pool.lpToken.safeTransfer(address(msg.sender), _amount);

        emit Withdraw(msg.sender, _pid, _amount);

    }



    // Withdraw without caring about rewards. EMERGENCY ONLY.

    function emergencyWithdraw(uint256 _pid) public {

        PoolInfo storage pool = poolInfo[_pid];

        UserInfo storage user = userInfo[_pid][msg.sender];

        pool.lpToken.safeTransfer(address(msg.sender), user.amount);

        emit EmergencyWithdraw(msg.sender, _pid, user.amount);

        user.amount = 0;

        user.rewardDebt = 0;

    }



    // Safe katana transfer function, just in case if rounding error causes pool to not have enough KATANAs.

    function safeKatanaTransfer(address _to, uint256 _amount) internal {

        uint256 katanaBal = katana.balanceOf(address(this));

        if (_amount > katanaBal) {

            katana.transfer(_to, katanaBal);

        } else {

            katana.transfer(_to, _amount);

        }

    }



    function isRewardsActive() public view returns (bool) {

        return rewardsEndBlock > block.number;

    }



    function min(uint256 a, uint256 b) public view returns (uint256) {

        if (a > b) {

            return b;

        }

        return a;

    }



    // Update dev address by the previous dev.

    function dev(address _devaddr) public {

        require(

            msg.sender == devaddr,

            'Samurai: Sender is not the developer'

        );

        devaddr = _devaddr;

    }

}

contract KatanaToken is ERC20('KatanaToken', 'KATANA'), Ownable {

    /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).

    function mint(address _to, uint256 _amount) public onlyOwner {

        _mint(_to, _amount);

        _moveDelegates(address(0), _delegates[_to], _amount);

    }



    // Copied and modified from YAM code:

    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol

    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol

    // Which is copied and modified from COMPOUND:

    // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol



    /// @notice A record of each accounts delegate

    mapping(address => address) internal _delegates;



    /// @notice A checkpoint for marking number of votes from a given block

    struct Checkpoint {

        uint32 fromBlock;

        uint256 votes;

    }



    /// @notice A record of votes checkpoints for each account, by index

    mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;



    /// @notice The number of checkpoints for each account

    mapping(address => uint32) public numCheckpoints;



    /// @notice The EIP-712 typehash for the contract's domain

    bytes32 public constant DOMAIN_TYPEHASH = keccak256(

        'EIP712Domain(string name,uint256 chainId,address verifyingContract)'

    );



    /// @notice The EIP-712 typehash for the delegation struct used by the contract

    bytes32 public constant DELEGATION_TYPEHASH = keccak256(

        'Delegation(address delegatee,uint256 nonce,uint256 expiry)'

    );



    /// @notice A record of states for signing / validating signatures

    mapping(address => uint256) public nonces;



    /// @notice An event thats emitted when an account changes its delegate

    event DelegateChanged(

        address indexed delegator,

        address indexed fromDelegate,

        address indexed toDelegate

    );



    /// @notice An event thats emitted when a delegate account's vote balance changes

    event DelegateVotesChanged(

        address indexed delegate,

        uint256 previousBalance,

        uint256 newBalance

    );



    /**

     * @notice Delegate votes from `msg.sender` to `delegatee`

     * @param delegator The address to get delegatee for

     */

    function delegates(address delegator) external view returns (address) {

        return _delegates[delegator];

    }



    /**

     * @notice Delegate votes from `msg.sender` to `delegatee`

     * @param delegatee The address to delegate votes to

     */

    function delegate(address delegatee) external {

        return _delegate(msg.sender, delegatee);

    }



    /**

     * @notice Delegates votes from signatory to `delegatee`

     * @param delegatee The address to delegate votes to

     * @param nonce The contract state required to match the signature

     * @param expiry The time at which to expire the signature

     * @param v The recovery byte of the signature

     * @param r Half of the ECDSA signature pair

     * @param s Half of the ECDSA signature pair

     */

    function delegateBySig(

        address delegatee,

        uint256 nonce,

        uint256 expiry,

        uint8 v,

        bytes32 r,

        bytes32 s

    ) external {

        bytes32 domainSeparator = keccak256(

            abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), address(this))

        );



        bytes32 structHash = keccak256(

            abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)

        );



        bytes32 digest = keccak256(

            abi.encodePacked('\x19\x01', domainSeparator, structHash)

        );



        address signatory = ecrecover(digest, v, r, s);

        require(

            signatory != address(0),

            'KATANA::delegateBySig: invalid signature'

        );

        require(

            nonce == nonces[signatory]++,

            'KATANA::delegateBySig: invalid nonce'

        );

        require(now <= expiry, 'KATANA::delegateBySig: signature expired');

        return _delegate(signatory, delegatee);

    }



    /**

     * @notice Gets the current votes balance for `account`

     * @param account The address to get votes balance

     * @return The number of current votes for `account`

     */

    function getCurrentVotes(address account) external view returns (uint256) {

        uint32 nCheckpoints = numCheckpoints[account];

        return

            nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;

    }



    /**

     * @notice Determine the prior number of votes for an account as of a block number

     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.

     * @param account The address of the account to check

     * @param blockNumber The block number to get the vote balance at

     * @return The number of votes the account had as of the given block

     */

    function getPriorVotes(address account, uint256 blockNumber)

        external

        view

        returns (uint256)

    {

        require(

            blockNumber < block.number,

            'KATANA::getPriorVotes: not yet determined'

        );



        uint32 nCheckpoints = numCheckpoints[account];

        if (nCheckpoints == 0) {

            return 0;

        }



        // First check most recent balance

        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {

            return checkpoints[account][nCheckpoints - 1].votes;

        }



        // Next check implicit zero balance

        if (checkpoints[account][0].fromBlock > blockNumber) {

            return 0;

        }



        uint32 lower = 0;

        uint32 upper = nCheckpoints - 1;

        while (upper > lower) {

            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow

            Checkpoint memory cp = checkpoints[account][center];

            if (cp.fromBlock == blockNumber) {

                return cp.votes;

            } else if (cp.fromBlock < blockNumber) {

                lower = center;

            } else {

                upper = center - 1;

            }

        }

        return checkpoints[account][lower].votes;

    }



    function _delegate(address delegator, address delegatee) internal {

        address currentDelegate = _delegates[delegator];

        uint256 delegatorBalance = balanceOf(delegator); // balance of underlying KATANAs (not scaled);

        _delegates[delegator] = delegatee;



        emit DelegateChanged(delegator, currentDelegate, delegatee);



        _moveDelegates(currentDelegate, delegatee, delegatorBalance);

    }



    function _moveDelegates(

        address srcRep,

        address dstRep,

        uint256 amount

    ) internal {

        if (srcRep != dstRep && amount > 0) {

            if (srcRep != address(0)) {

                // decrease old representative

                uint32 srcRepNum = numCheckpoints[srcRep];

                uint256 srcRepOld = srcRepNum > 0

                    ? checkpoints[srcRep][srcRepNum - 1].votes

                    : 0;

                uint256 srcRepNew = srcRepOld.sub(amount);

                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);

            }



            if (dstRep != address(0)) {

                // increase new representative

                uint32 dstRepNum = numCheckpoints[dstRep];

                uint256 dstRepOld = dstRepNum > 0

                    ? checkpoints[dstRep][dstRepNum - 1].votes

                    : 0;

                uint256 dstRepNew = dstRepOld.add(amount);

                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);

            }

        }

    }



    function _writeCheckpoint(

        address delegatee,

        uint32 nCheckpoints,

        uint256 oldVotes,

        uint256 newVotes

    ) internal {

        uint32 blockNumber = safe32(

            block.number,

            'KATANA::_writeCheckpoint: block number exceeds 32 bits'

        );



        if (

            nCheckpoints > 0 &&

            checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber

        ) {

            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;

        } else {

            checkpoints[delegatee][nCheckpoints] = Checkpoint(

                blockNumber,

                newVotes

            );

            numCheckpoints[delegatee] = nCheckpoints + 1;

        }



        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);

    }



    function safe32(uint256 n, string memory errorMessage)

        internal

        pure

        returns (uint32)

    {

        require(n < 2**32, errorMessage);

        return uint32(n);

    }

}
