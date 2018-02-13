pragma solidity ^0.4.2;

contract SingleNumRegister {
  uint storedData;
  function set(uint x) public {
      storedData = x;
  }

  function get() public constant returns (uint retVal) {
  return storedData;
  }

  function sample_method_test1() constant returns (uint retVal) {
    return 111;
  }

  function sampleMethodTest2() constant returns (uint retVal) {
    return 222;
  }

}
