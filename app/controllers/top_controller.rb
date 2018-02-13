class TopController < ApplicationController
  ETHEREUM_ADDRESS  = "/Users/shu/work/labo/eth_private_net/geth.ipc"
  CONTRACT_PATH     = "#{Rails.root}/lib/solidity/Otoshidama.sol"
  ETHEREUM_ACCOUNTS = [
    "0x5917c62f74aa03cdc3068de68d3fb864b588e1ea",
    "0xb7ec7ffe3d1f147a85b193c3a6cb3d5aa3d79f38",
    "0x5abb1d28d4c60e2a4362bd8b41acfb54dec31314",
  ]

  def index
    client = Ethereum::IpcClient.new(ETHEREUM_ADDRESS)
    puts "[ ---------- client ---------- ]"; client.tapp;

    contract = Ethereum::Contract.create(file: CONTRACT_PATH, client: client)
    # contract = Ethereum::Contract.create(name: "MyContract", truffle: { paths: [ '/Users/shu/work/labo/erc20_token_sample' ] }, client: client, address: '0x01a4d1A62F01ED966646acBfA8BB0b59960D06dd')
    puts "[ ---------- contract ---------- ]"; contract.tapp;

    @address = contract.deploy_and_wait
    puts "[ ---------- @address ---------- ]"; @address.tapp;

    puts "[ ---------- name ---------- ]"; contract.call.name.tapp;
    puts "[ ---------- symbol ---------- ]"; contract.call.symbol.tapp;
    puts "[ ---------- decimals ---------- ]"; contract.call.decimals.tapp;
    puts "[ ---------- total_supply ---------- ]"; contract.call.total_supply.tapp;

    # 残高表示
    puts "[ ---------- balanceOf 0 ---------- ]"; contract.call.balance_of(ETHEREUM_ACCOUNTS[0]).tapp;
    puts "[ ---------- balanceOf 1 ---------- ]"; contract.call.balance_of(ETHEREUM_ACCOUNTS[1]).tapp;
    puts "[ ---------- balanceOf 2 ---------- ]"; contract.call.balance_of(ETHEREUM_ACCOUNTS[2]).tapp;

    # トークン発行者からETHEREUM_ACCOUNTS[1]アカウントへ100付与
    transfer_result = contract.transact_and_wait.transfer(ETHEREUM_ACCOUNTS[1], 100)

    puts "[ ---------- transfer_result ---------- ]"; transfer_result.tapp;

    puts "[ ---------- balanceOf 0 ---------- ]"; contract.call.balance_of(ETHEREUM_ACCOUNTS[0]).tapp;
    puts "[ ---------- balanceOf 1 ---------- ]"; contract.call.balance_of(ETHEREUM_ACCOUNTS[1]).tapp;
    puts "[ ---------- balanceOf 2 ---------- ]"; contract.call.balance_of(ETHEREUM_ACCOUNTS[2]).tapp;

    # # approveメソッドで、トークン所有者であるETHEREUM_ACCOUNTS[1]からETHEREUM_ACCOUNTS[2]に10転送を承認
    # # approve_result = contract.call.approve(ETHEREUM_ACCOUNTS[2], 10, { from: ETHEREUM_ACCOUNTS[1] })
    # # approve_result = contract.call.approve(ETHEREUM_ACCOUNTS[2], 10)
    # approve_result = contract.transact_and_wait.approve(ETHEREUM_ACCOUNTS[2], 10)

    # puts "[ ---------- approve_result ---------- ]"; approve_result.tapp;

    # # 承認結果をallowanceメソッドで確認
    # # allowance_result = contract.call.allowance(ETHEREUM_ACCOUNTS[1], ETHEREUM_ACCOUNTS[2])
    # allowance_result = contract.transact_and_wait.allowance(ETHEREUM_ACCOUNTS[1], ETHEREUM_ACCOUNTS[2])

    # puts "[ ---------- allowance_result ---------- ]"; allowance_result.tapp;

    # # web3.eth.accounts[2]に10の転送が承認されたので、再度ETHEREUM_ACCOUNTS[1]からETHEREUM_ACCOUNTS[2]へのトークンを転送
    # # transfer_from_result = contract.call.transfer_from(ETHEREUM_ACCOUNTS[1], ETHEREUM_ACCOUNTS[2], 10, { from: ETHEREUM_ACCOUNTS[0] })
    # # transfer_from_result = contract.call.transfer_from(ETHEREUM_ACCOUNTS[1], ETHEREUM_ACCOUNTS[2], 10)
    transfer_from_result = contract.transact_and_wait.transfer_from(ETHEREUM_ACCOUNTS[1], ETHEREUM_ACCOUNTS[2], 10)

    puts "[ ---------- transfer_from_result ---------- ]"; transfer_from_result.tapp;


    puts "[ ---------- balanceOf 0 ---------- ]"; contract.call.balance_of(ETHEREUM_ACCOUNTS[0]).tapp;
    puts "[ ---------- balanceOf 1 ---------- ]"; contract.call.balance_of(ETHEREUM_ACCOUNTS[1]).tapp;
    puts "[ ---------- balanceOf 2 ---------- ]"; contract.call.balance_of(ETHEREUM_ACCOUNTS[2]).tapp;

    @balance_of_0 = contract.call.balance_of(ETHEREUM_ACCOUNTS[0])
    @balance_of_1 = contract.call.balance_of(ETHEREUM_ACCOUNTS[1])
    @balance_of_2 = contract.call.balance_of(ETHEREUM_ACCOUNTS[2])
  end
end
