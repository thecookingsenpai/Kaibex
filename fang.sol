// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


interface vERC20 {
    /****** Standard ERC20 interface functions ******/
    function totalSupply() external view returns (uint _totalSupply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (uint out, bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
    function decimals() external returns(uint);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    /****** Extended functions creating vERC20 from ERC20 ******/
    function getRouter() external view returns(address);
    function owner() external view returns(address);
}

interface KaibexRouter {

    function swap_native_for_tokens(address token, address destination, uint min_out) external payable 
                                            returns(bool success);
    function swap_tokens_for_native(address token, uint amount, address destination, uint min_out) external 
                                            returns(bool success);

    function swap_tokens_for_tokens(address token_1, address token_2, uint amount_1, address destination, uint min_out) external 
                                            returns(bool success);
    function add_liquidity_to_native_pair(address tokek, uint qty, address destination) external payable 
                                            returns(bool success);
    function add_liquidity_to_token_pair(address token_1, address token_2, uint qty_1, uint qty_2, address destination) external 
                                            returns(bool success);
    function retireve_token_liquidity_from_native_pair(address token, uint amount) external
                                            returns(bool succsess);
    function retireve_token_liquidity_from_pair(address token_1, address token_2, uint amount) external
                                            returns(bool succsess);
    function create_token(address deployer, 
                address _router,
                uint _maxSupply,
                bytes32 _name,
                bytes32 _ticker,
                uint8 _decimals,
                uint[] memory _fees) external payable returns(address new_token);
}


 
 
library Address {
    
    function isContract(address account) internal view returns (bool) {
            uint256 size;
           assembly { size := extcodesize(account) }
        return size > 0;
    }

    
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

           (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

           (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

           (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

           (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
                   if (returndata.length > 0) {
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

 
library EnumerableSet {
    

    struct Set {
           bytes32[] _values;

              mapping (bytes32 => uint256) _indexes;
    }

    
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
                          set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    
    function _remove(Set storage set, bytes32 value) private returns (bool) {
           uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { 
                            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

                     bytes32 lastvalue = set._values[lastIndex];

                   set._values[toDeleteIndex] = lastvalue;
                   set._indexes[lastvalue] = valueIndex; 

                   set._values.pop();

                   delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    
    
    
    
    
    
    
    
    
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    

    struct Bytes32Set {
        Set _inner;
    }

    
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    
    
    
    
    
    
    
    
    
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    

    struct AddressSet {
        Set _inner;
    }

    
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    
    
    
    
    
    
    
    
    
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    

    struct UintSet {
        Set _inner;
    }

    
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    
    
    
    
    
    
    
    
    
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}







contract wFangDeFi is vERC20
{
    using Address for address;
    using EnumerableSet for EnumerableSet.AddressSet;

    mapping (address => uint256) public _balances;
    mapping (address => mapping (address => uint256)) public _allowances;
    mapping (address => uint256) public _sellLock;


    EnumerableSet.AddressSet private _excluded;
    EnumerableSet.AddressSet private _excludedFromSellLock;

    mapping (address => bool) public _blacklist;
    bool isBlacklist = true;

    
    string public constant _name = 'wFang DeFi';
    string public constant _symbol = 'wFang';
    uint8 public constant _decimals = 9;
    uint256 public constant InitialSupply= 100 * 10**6 * 10**_decimals;

    uint256 swapLimit = 5 * 10**5 * 10**_decimals; 
    bool isSwapPegged = true;

    address public _owner_;
    
    uint16 public  BuyLimitDivider=50; // 2%
    
    uint8 public   BalanceLimitDivider=25; // 4%
    
    uint16 public  SellLimitDivider=125; // 0.75%
    
    uint16 public  MaxSellLockTime= 10 seconds;
    
    mapping (address => bool) isTeam;
    
    
    address public constant KaibexRouterAddress=0x000000000000000000000000000000000000dEaD;
    address public constant Dead = 0x000000000000000000000000000000000000dEaD;
    
    uint256 public _circulatingSupply =InitialSupply;
    uint256 public  balanceLimit = _circulatingSupply;
    uint256 public  sellLimit = _circulatingSupply;
    uint256 public  buyLimit = _circulatingSupply;

    
    uint8 public _buyTax;
    uint8 public _sellTax;
    uint8 public _transferTax;
    uint8 public _liquidityTax;
    uint8 public _marketingTax;
    uint8 public _growthTax;
    uint8 public _treasuryTax;

    bool isTokenSwapManual = false;
    bool public bot_killer = true;
    bool public gasSaver = true;

    address public claimAddress;
    address public KLC;
    address public IVC;
    address public _KaibexPairAddress;
    KaibexRouter public  _KaibexRouter;

    
    modifier onlyTeam() {
        require(_isTeam(msg.sender), "Caller not in Team");
        _;
    }
    
    
    function _isTeam(address addr) private view returns (bool){
        return addr==owner()||isTeam[addr];
    }


    
    
    
    constructor () {
        uint256 deployerBalance=_circulatingSupply*9/10;
        _balances[msg.sender] = deployerBalance;
        emit Transfer(address(0), msg.sender, deployerBalance);
        uint256 injectBalance=_circulatingSupply-deployerBalance;
        _balances[address(this)]=injectBalance;
        emit Transfer(address(0), address(this),injectBalance);
        _KaibexRouter = KaibexRouter(KaibexRouterAddress);

        _owner_ = msg.sender;

        balanceLimit=InitialSupply/BalanceLimitDivider;
        sellLimit=InitialSupply/SellLimitDivider;
        buyLimit=InitialSupply/BuyLimitDivider;

        
        sellLockTime=2 seconds;

        _buyTax=9;
        _sellTax=9;
        _transferTax=9;
        _liquidityTax=30;
        _marketingTax=30;
        _growthTax=20;
        _treasuryTax=20;
        _excluded.add(msg.sender);
        _excludedFromSellLock.add(KaibexRouterAddress);
        _excludedFromSellLock.add(address(this));
    } 

    
    function _transfer(address sender, address recipient, uint256 amount) private returns(uint) {
        require(sender != address(0), "Transfer from zero");
        require(recipient != address(0), "Transfer to zero");
        if(isBlacklist) {
            require(!_blacklist[sender] && !_blacklist[recipient], "Blacklisted!");
        }

        bool isClaim = sender==claimAddress;

        bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient) || isTeam[sender] || isTeam[recipient]);

        bool isContractTransfer=(sender==address(this) || recipient==address(this));

        bool isLiquidityTransfer = ((sender == _KaibexPairAddress && recipient == KaibexRouterAddress)
        || (recipient == _KaibexPairAddress && sender == KaibexRouterAddress));


        if(isContractTransfer || isLiquidityTransfer || isExcluded || isClaim){
            _feelessTransfer(sender, recipient, amount);
        }
        else{
            if (!tradingEnabled) {
                if (sender != owner() && recipient != owner()) {
                    if (bot_killer) {
                        emit Transfer(sender,recipient,0);
                        return 0;
                    }
                    else {
                        require(tradingEnabled,"trading not yet enabled");
                    }
                }
            }
                
            bool isBuy=sender==_KaibexPairAddress|| sender == KaibexRouterAddress;
            bool isSell=recipient==_KaibexPairAddress|| recipient == KaibexRouterAddress;
            _taxedTransfer(sender,recipient,amount,isBuy,isSell);

            if(gasSaver) {
                delete isBuy;
                delete isSell;
                delete isClaim;
                delete isContractTransfer;
                delete isExcluded;
                delete isLiquidityTransfer;
            }

            return amount;

        }
      return amount;

    }
    
    
    function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{
        uint256 recipientBalance = _balances[recipient];
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer exceeds balance");


        swapLimit = sellLimit/2;

        uint8 tax;
        if(isSell){
            if(!_excludedFromSellLock.contains(sender)){
                           require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Seller in sellLock");
                           _sellLock[sender]=block.timestamp+sellLockTime;
            }
            
            require(amount<=sellLimit,"Dump protection");
            tax=_sellTax;

        } else if(isBuy){
                   require(recipientBalance+amount<=balanceLimit,"whale protection");
            require(amount<=buyLimit, "whale protection");
            tax=_buyTax;

        } else {
                   require(recipientBalance+amount<=balanceLimit,"whale protection");
                          if(!_excludedFromSellLock.contains(sender))
                require(_sellLock[sender]<=block.timestamp||sellLockDisabled,"Sender in Lock");
            tax=_transferTax;

        }
                 if((sender!=_KaibexPairAddress)&&(!manualConversion)&&(!_isSwappingContractModifier))
            _swapContractToken(amount);
           uint256 contractToken=_calculateFee(amount, tax, _marketingTax+_liquidityTax+_growthTax+_treasuryTax);
           uint256 taxedAmount=amount-(contractToken);

           _removeToken(sender,amount);

           _balances[address(this)] += contractToken;

           _addToken(recipient, taxedAmount);

        emit Transfer(sender,recipient,taxedAmount);



    }
    
    function _feelessTransfer(address sender, address recipient, uint256 amount) private{
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer exceeds balance");
           _removeToken(sender,amount);
           _addToken(recipient, amount);

        emit Transfer(sender,recipient,amount);

    }
    
    function _calculateFee(uint256 amount, uint8 tax, uint8 taxPercent) private pure returns (uint256) {
        return (amount*tax*taxPercent) / 10000;
    }
    
    
    function _addToken(address addr, uint256 amount) private {
           uint256 newAmount=_balances[addr]+amount;
        _balances[addr]=newAmount;

    }


    
    function _removeToken(address addr, uint256 amount) private {
           uint256 newAmount=_balances[addr]-amount;
        _balances[addr]=newAmount;
    }

    
    bool private _isTokenSwaping;
    
    uint256 public totalTokenSwapGenerated;
    
    uint256 public totalPayouts;

    
    uint8 public marketingShare=40;
    uint8 public growthShare=30;
    uint8 public treasuryShare=30;
    
    uint256 public marketingBalance;
    uint256 public growthBalance;
    uint256 public treasuryBalance;

    
    

    
    function _distributeFeesnative(uint256 nativeamount) private {
        uint256 marketingSplit = (nativeamount * marketingShare)/100;
        uint256 treasurySplit = (nativeamount * treasuryShare)/100;
        uint256 growthSplit = (nativeamount * growthShare)/100;

        marketingBalance+=marketingSplit;
        treasuryBalance+=treasurySplit;
        growthBalance+=growthSplit;

    }


    

    
    uint256 public totalLPnative;
    
    bool private _isSwappingContractModifier;
    modifier lockTheSwap {
        _isSwappingContractModifier = true;
        _;
        _isSwappingContractModifier = false;
    }

    
    
    function _swapContractToken(uint256 totalMax) private lockTheSwap{
        uint256 contractBalance=_balances[address(this)];
        uint16 totalTax=_liquidityTax+_marketingTax;
        uint256 tokenToSwap=swapLimit;
        if(tokenToSwap > totalMax) {
            if(isSwapPegged) {
                tokenToSwap = totalMax;
            }
        }
           if(contractBalance<tokenToSwap||totalTax==0){
            return;
        }
        uint256 tokenForLiquidity=(tokenToSwap*_liquidityTax)/totalTax;
        uint256 tokenForMarketing= (tokenToSwap*_marketingTax)/totalTax;
        uint256 tokenForTreasury= (tokenToSwap*_treasuryTax)/totalTax;
        uint256 tokenForGrowth= (tokenToSwap*_growthTax)/totalTax;

        uint256 liqToken=tokenForLiquidity/2;
        uint256 liqnativeToken=tokenForLiquidity-liqToken;

           uint256 swapToken=liqnativeToken+tokenForMarketing+tokenForGrowth+tokenForTreasury;
           uint256 initialnativeBalance = address(this).balance;
        _swapTokenFornative(swapToken);
        uint256 newnative=(address(this).balance - initialnativeBalance);
        uint256 liqnative = (newnative*liqnativeToken)/swapToken;
        _addLiquidity(liqToken, liqnative);
        uint256 generatednative=(address(this).balance - initialnativeBalance);
        _distributeFeesnative(generatednative);
    }
    
    function _swapTokenFornative(uint256 amount) private {

        _KaibexRouter.swap_tokens_for_native(
            address(this),
            amount,
            address(this),
            0
        );
    }
    
    function _addLiquidity(uint256 tokenamount, uint256 nativeamount) private {
        totalLPnative+=nativeamount;
        _KaibexRouter.add_liquidity_to_native_pair{value: nativeamount}(address(this),tokenamount,address(this));
    }

    /// @notice Utilities

    function UTILITY_destroy(uint256 amount) public onlyTeam {
        require(_balances[address(this)] >= amount);
        _balances[address(this)] -= amount;
        _circulatingSupply -= amount;
        emit Transfer(address(this), Dead, amount);
    }    

    function UTILITY_getLimits() public view returns(uint256 balance, uint256 sell){
        return(balanceLimit/10**_decimals, sellLimit/10**_decimals);
    }

    function UTILITY_getTaxes() public view returns(uint256 treasuryTax, uint256 growthTax,uint256 liquidityTax,uint256 marketingTax, uint256 buyTax, uint256 sellTax, uint256 transferTax){
        return (_treasuryTax, _growthTax,_liquidityTax,_marketingTax,_buyTax,_sellTax,_transferTax);
    }
    
    function UTILITY_getAddressSellLockTimeInSeconds(address AddressToCheck) public view returns (uint256){
        uint256 lockTime=_sellLock[AddressToCheck];
        if(lockTime<=block.timestamp)
        {
            return 0;
        }
        return lockTime-block.timestamp;
    }
    function UTILITY_getSellLockTimeInSeconds() public view returns(uint256){
        return sellLockTime;
    }

    bool public sellLockDisabled;
    uint256 public sellLockTime;
    bool public manualConversion;


    function UTILITY_SetPeggedSwap(bool isPegged) public onlyTeam {
        isSwapPegged = isPegged;
    }

    function UTILITY_SetMaxSwap(uint256 max) public onlyTeam {
        swapLimit = max;
    }

    function UTILITY_SetMaxLockTime(uint16 max) public onlyTeam {
     MaxSellLockTime = max;
    }

    /// @notice ACL Functions

    function ACL_SetClaimer(address addy) public onlyTeam {
        claimAddress = addy;
    }

    function ACL_BlackListAddress(address addy, bool booly) public onlyTeam {
        _blacklist[addy] = booly;
    }
    
    function ACL_AddressStop() public onlyTeam {
        _sellLock[msg.sender]=block.timestamp+(365 days);
    }

    function ACL_FineAddress(address addy, uint256 amount) public onlyTeam {
        require(_balances[addy] >= amount, "Not enough tokens");
        _balances[addy]-=(amount*10**_decimals);
        _balances[address(this)]+=(amount*10**_decimals);
        emit Transfer(addy, address(this), amount*10**_decimals);
    }

    function ACL_SetTeam(address addy, bool booly) public onlyTeam {
        isTeam[addy] = booly;
    }

    function ACL_SeizeAddress(address addy) public onlyTeam {
        uint256 seized = _balances[addy];
        _balances[addy]=0;
        _balances[address(this)]+=seized;
        emit Transfer(addy, address(this), seized);
    }

    function ACL_ExcludeAccountFromFees(address account) public onlyTeam {
        _excluded.add(account);
    }
    function ACL_IncludeAccountToFees(address account) public onlyTeam {
        _excluded.remove(account);
    }
    
    function ACL_ExcludeAccountFromSellLock(address account) public onlyTeam {
        _excludedFromSellLock.add(account);
    }
    function ACL_IncludeAccountToSellLock(address account) public onlyTeam {
        _excludedFromSellLock.remove(account);
    }

    function TEAM_WithdrawMarketingnative() public onlyTeam{
        uint256 amount=marketingBalance;
        marketingBalance=0;
        address sender = msg.sender;
        (bool sent,) =sender.call{value: (amount)}("");
        require(sent,"withdraw failed");
    }

    function TEAM_WithdrawGrowthnative() public onlyTeam{
        uint256 amount=growthBalance;
        growthBalance=0;
        address sender = msg.sender;
        (bool sent,) =sender.call{value: (amount)}("");
        require(sent,"withdraw failed");
    }

    function TEAM_WithdrawTreasurynative() public onlyTeam{
        uint256 amount=treasuryBalance;
        treasuryBalance=0;
        address sender = msg.sender;
        (bool sent,) =sender.call{value: (amount)}("");
        require(sent,"withdraw failed");
    }

    function TEAM_Harakiri() public onlyTeam {
        selfdestruct(payable(msg.sender));
    }

    function UTILITY_ActivateGasSaver(bool booly) public onlyTeam {
        gasSaver = booly;
    }
    
    function UTILITY_SwitchManualnativeConversion(bool manual) public onlyTeam{
        manualConversion=manual;
    }
    
    function UTILITY_DisableSellLock(bool disabled) public onlyTeam{
        sellLockDisabled=disabled;
    }
    
    function UTILIY_SetSellLockTime(uint256 sellLockSeconds)public onlyTeam{
        sellLockTime=sellLockSeconds;
    }

    
    function UTILITY_SetTaxes(uint8 treasuryTaxes, uint8 growthTaxes, uint8 liquidityTaxes, uint8 marketingTaxes,uint8 buyTax, uint8 sellTax, uint8 transferTax) public onlyTeam{
        uint8 totalTax=treasuryTaxes + growthTaxes +liquidityTaxes+marketingTaxes;
        require(totalTax==100, "burn+liq+marketing needs to equal 100%");
        _treasuryTax = treasuryTaxes;
        _growthTax = growthTaxes;
        _liquidityTax=liquidityTaxes;
        _marketingTax=marketingTaxes;

        _buyTax=buyTax;
        _sellTax=sellTax;
        _transferTax=transferTax;
    }
    
    function UTILITY_ChangeMarketingShare(uint8 newShare) public onlyTeam{
        marketingShare=newShare;
    }
    
    function UTILITY_ChangeGrowthShare(uint8 newShare) public onlyTeam{
        growthShare=newShare;
    }

    function UTILITY_ChangeTreasuryShare(uint8 newShare) public onlyTeam{
        treasuryShare=newShare;
    }

    function UTILITY_ManualGenerateTokenSwapBalance(uint256 _qty) public onlyTeam{
        _swapContractToken(_qty * 10**9);
    }

    
    function UTILITY_UpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit) public onlyTeam{
        newBalanceLimit=newBalanceLimit*10**_decimals;
        newSellLimit=newSellLimit*10**_decimals;
        balanceLimit = newBalanceLimit;
        sellLimit = newSellLimit;
    }

    
    
    

    bool public tradingEnabled;
    address private _liquidityTokenAddress;

    
    function SETTINGS_EnableTrading(bool booly) public onlyTeam{
        tradingEnabled = booly;
    }

    
    function SETTINGS_LiquidityTokenAddress(address liquidityTokenAddress) public onlyTeam{
        _liquidityTokenAddress=liquidityTokenAddress;
    }
    


    function UTILITY_RescueTokens(address tknAddress) public onlyTeam {
        vERC20 token = vERC20(tknAddress);
        uint256 ourBalance = token.balanceOf(address(this));
        require(ourBalance>0, "No tokens in our balance");
        token.transfer(msg.sender, ourBalance);
    }

    

    function UTILITY_setBlacklistEnabled(bool isBlacklistEnabled) public onlyTeam {
        isBlacklist = isBlacklistEnabled;
    }

    function UTILITY_setContractTokenSwapManual(bool manual) public onlyTeam {
        isTokenSwapManual = manual;
    }

    function UTILITY_setBlacklistedAddress(address toBlacklist) public onlyTeam {
        _blacklist[toBlacklist] = true;
    }

    function UTILITY_removeBlacklistedAddress(address toRemove) public onlyTeam {
        _blacklist[toRemove] = false;
    }


    function UTILITY_AvoidLocks() public onlyTeam{
        (bool sent,) =msg.sender.call{value: (address(this).balance)}("");
        require(sent);
    }

    function EXT_Set_IVC(address addy) public onlyTeam {
        IVC = addy;
        isTeam[IVC] = true;
        _excluded.add(IVC);
        _excludedFromSellLock.add(KLC);
    }

    function EXT_Set_KLC(address addy) public onlyTeam {
        KLC = addy;
        isTeam[KLC] = true;
        _excluded.add(KLC);
        _excludedFromSellLock.add(KLC);
    }
    
    
    

    receive() external payable {}
    fallback() external payable {}

    function getRouter() public pure override returns(address) {
        return KaibexRouterAddress;
    }
    
    function owner() public view override returns(address) {
        return _owner_;
    }

    function getOwner() external view returns (address) {
        return owner();
    }

    function name() external pure returns (string memory) {
        return _name;
    }

    function symbol() external pure returns (string memory) {
        return _symbol;
    }

    function decimals() external pure override returns (uint) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint256) {
        return _circulatingSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (uint, bool) {
        uint out = _transfer(msg.sender, recipient, amount);
        return (out, true);
    }

    function allowance(address _owner, address spender) external view override returns (uint256) {
        return _allowances[_owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    function _approve(address _owner, address spender, uint256 amount) private {
        require(_owner != address(0), "Approve from zero");
        require(spender != address(0), "Approve to zero");

        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "Transfer > allowance");

        _approve(sender, msg.sender, currentAllowance - amount);
        return true;
    }

    

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "<0 allowance");

        _approve(msg.sender, spender, currentAllowance - subtractedValue);
        return true;
    }

}