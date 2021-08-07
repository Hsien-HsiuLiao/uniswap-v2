pragma solidity ^0.7.3;

//interface for unisawp router contract
interface IUniswap {
    // https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/UniswapV2Router02.sol
  function swapExactTokensForETH(
    uint amountIn, 
    uint amountOutMin, 
    //path, two tokens we want to trade
    address[] calldata path, 
    address to, 
    uint deadline)
    external
    returns (uint[] memory amounts);
    //https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router01.sol
  function WETH() external pure returns (address);
}

interface IERC20 {
  function transferFrom(
    address sender, 
    address recipient, 
    uint256 amount) 
    external 
    returns (bool);
  function approve(address spender, uint256 amount) external returns (bool);
}

contract MyDeFiProject {
    //create pointer to uniswap
  IUniswap uniswap;

  constructor(address _uniswap) {
    uniswap = IUniswap(_uniswap);
  }

  function swapTokensForEth(address token, uint amountIn, uint amountOutMin, uint deadline) external {
    IERC20(token).transferFrom(msg.sender, address(this), amountIn);
    address[] memory path = new address[](2);
    path[0] = address(DAI);
    path[1] = uniswap.WETH();
    IERC20(token).approve(address(uniswap), amountIn);
    uniswap.swapExactTokensForETH(
      amountIn, 
      amountOutMin, 
      path, 
      msg.sender, 
      deadline
    );
  }
  //other swap functions
  //https://docs.uniswap.org/protocol/V2/reference/smart-contracts/router-02#swapexactethfortokens
}