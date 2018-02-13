pragma solidity ^0.4.18;

contract Otoshidama {

  // トークンのメタ情報を設定します (一部のウォレットが利用するそうです)
  string public name     = 'Otoshidama';
  string public symbol   = 'OTD';
  uint   public decimals = 18;

  // トークンの合計供給量を保持します
  uint public totalSupply;

  // 各アカウントの残高を保持します
  mapping(address => uint) public balances;

  /**
  * コントラクトを初期化します
  */
  function Otoshidama() public {
    uint _initialSupply = 10000;

    balances[msg.sender] = _initialSupply;
    totalSupply          = _initialSupply;
  }

  /**
   * トークンの合計供給量を取得します
   * @return トークンの合計供給量を表す uint 値
   */
  function totalSupply() public view returns (uint) {
    return (totalSupply);
  }

  /**
  * _owner アカウントの残高を取得します
  * @param _owner 残高を取得するアカウントのアドレス
  * @return 渡されたアドレスが所有する残高を表す uint 値
  */
  function balanceOf(address _owner) public view returns (uint) {
    return (balances[_owner]);
  }

  /**
  * msg.sender が _to アカウントに指定した量のトークンを転送します
  * @param _to トークンを転送するアカウントのアドレス
  * @param _value 転送するトークンの量
  * @return トークンの転送が成功したかどうかを表す bool 値
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_value <= balances[msg.sender]);

    balances[msg.sender] -= _value;
    balances[_to] += _value;

    Transfer(msg.sender, _to, _value);
    return true;
  }

  event Transfer(address indexed from, address indexed to, uint value);

  // 各アカウントによる転送を許可したトークンの量を保持します
  mapping(address => mapping (address => uint)) internal allowed;

  /**
   * _from アカウントから _to アカウントに指定した量のトークンを転送します
   * @param _from トークンの転送元アドレス
   * @param _to address トークンの転送先アドレス
   * @param _value 転送するトークンの量
   * @return トークンの転送が成功したかどうかを表す bool 値
   */
  function transferFrom(address _from, address _to, uint _value) public returns (bool) {
    require(_value <= balances[_from]);
    // require(_value <= allowed[_from][msg.sender]);

    balances[_from] -= _value;
    balances[_to] += _value;
    // allowed[_from][msg.sender] -= _value;

    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * msg.sender が _spender アカウントが指定した量のトークンを転送することを承認します
   * @param _spender トークンを転送したいアドレス
   * @param _value 転送を許可するトークンの量
   */
  function approve(address _spender, uint _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;

    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * _spender アカウントが _owner アカウントから転送できるトークンの量を取得します
   * @param _owner トークンを所持するアドレス
   * @param _spender トークンを転送したいアドレス
   * @return _spender アカウントが _owner アカウントから転送可能なトークンの量を表す uint の値
   */
  function allowance(address _owner, address _spender) public view returns (uint) {
    return allowed[_owner][_spender];
  }

  event Approval(address indexed owner, address indexed spender, uint value);
}
