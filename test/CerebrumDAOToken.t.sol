// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import { CerebrumDAOToken } from "../src/CerebrumDAOToken.sol";
import {SigUtils} from "./helpers/SigUtils.sol"; 

contract CerebrumDAOTokenTest is Test {

    CerebrumDAOToken internal token;

    address deployer = makeAddr("moleculeDeployer");
    address alice = makeAddr("alice");
    uint256 alicePk;

    address bob = makeAddr("bob");
    address charlie = makeAddr("charlie");

    address cerebrumDao = 0xb35d6796366B93188AD5a01F60C0Ba45f1BDf11d;
    SigUtils sigUtils;

    function setUp() public {
        (, alicePk) = makeAddrAndKey("alice");

        vm.startPrank(deployer);
        token = new CerebrumDAOToken(cerebrumDao);
        sigUtils = new SigUtils(token.DOMAIN_SEPARATOR());

        vm.stopPrank();
    }

    function preMint() public {
        vm.startPrank(cerebrumDao);
        token.mint(cerebrumDao, 86_000_000_000 * 10 ** 18);
        vm.stopPrank();
    }

    function testStateAfterDeployment() public {
        assertEq(token.name(), "Cerebrum DAO Token");
        assertEq(token.symbol(), "NEURON");
        assertEq(token.decimals(), 18);
        assertEq(token.owner(), cerebrumDao);
        
        assertEq(token.totalSupply(), 0);
    }

    function testTransfers() public {
        preMint();
        vm.startPrank(cerebrumDao); 
        token.transfer(alice, 1000 ether);
        assertEq(token.balanceOf(alice), 1000 ether);
        assertEq(token.balanceOf(cerebrumDao), 86000000000 * 10 ** 18 - 1000 ether);
        vm.stopPrank();

        vm.startPrank(alice);
        token.transfer(bob, 100 ether);
        assertEq(token.balanceOf(bob), 100 ether);
    }

    function testTokenBurn() public {
        preMint();
        vm.startPrank(cerebrumDao);
        token.transfer(alice, 1000 ether);
        vm.stopPrank();
        
        assertEq(token.totalSupply(), 86000000000 * 10 ** 18);

        vm.startPrank(alice);
        token.burn(100 ether);
        assertEq(token.balanceOf(alice), 900 ether);
        assertEq(token.totalSupply(), 86000000000 * 10 ** 18 - 100 ether);
    }

    function testPermits() public {
        preMint();
      vm.startPrank(cerebrumDao);
      token.transfer(alice, 1000 ether);
      vm.stopPrank();

      vm.startPrank(alice);
      SigUtils.Permit memory permit = SigUtils.Permit({
            owner: alice,
            spender: bob,
            value: 1000 ether,
            nonce: 0,
            deadline: 1 days
        });

        bytes32 digest = sigUtils.getTypedDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(alicePk, digest);

      vm.stopPrank();

      vm.startPrank(bob);      
      token.permit(permit.owner, permit.spender, permit.value, permit.deadline, v, r, s);

      assertEq(token.allowance(alice, bob), 1000 ether);
      assertEq(token.nonces(alice), 1);

      token.transferFrom(alice, charlie, 500 ether);
      assertEq(token.balanceOf(charlie), 500 ether);
      
    }
}