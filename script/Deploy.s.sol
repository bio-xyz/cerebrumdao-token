// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {CerebrumDAOToken} from "../src/CerebrumDAOToken.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        CerebrumDAOToken token = new CerebrumDAOToken(0xb35d6796366B93188AD5a01F60C0Ba45f1BDf11d);
        console.log("CerebrumDAOToken deployed at: ", address(token));
    }
}
