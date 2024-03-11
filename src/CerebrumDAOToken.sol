// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

/*
                        ###############              
                      ##################             
                                      ####           
            ##########    #########     ####         
          ##############    #########    #####       
        #####        #####        ####     #####     
      #####            #####        ####     ###     
     ####    #######     ########     ###    ###     
     ####    #########     ######    ####    ###     
       ####        #####           #####     ###     
         ####        #####        ####     ####      
          #########    #############     #####       
                                       #####         
                                      ####           
                ################     ###             
                  ################                   
                               #####                 
                                 #####               
                                   ##                
*/
/// @custom:security-contact tech@molecule.to
contract CerebrumDAOToken is ERC20, Ownable, ERC20Permit, ERC20Burnable {
    constructor(address initialOwner)
        ERC20("Cerebrum DAO Token", "NEURON")
        Ownable(initialOwner)
        ERC20Permit("Cerebrum DAO Token")
    {
        _mint(initialOwner, 86000000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
