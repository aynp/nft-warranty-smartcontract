// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract WarrentyNFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
  address internal contractOwner;

  mapping(address => bool) private isAdmin;

  mapping(address => bool) private isSeller;

  mapping(uint256 => bool) private transferable;

  mapping(uint256 => string) private issueDate;

  mapping(uint256 => string) private warrentyPeriod;

  constructor() ERC721('Warrenty', 'W') {
    contractOwner = msg.sender;
  }

  /**
   * @notice Add a new admin
   * @dev Only the contract owner and an existing admin can add a new admin
   * @param _admin The new admin address
   */
  function addAdmin(address _admin) public {
    require((msg.sender == contractOwner) || (isAdmin[msg.sender] == true));
    isAdmin[_admin] = true;
  }

  /**
   * @notice Add a new seller
   * @dev Only the contract owner and the admins can add a new seller
   * @param _seller The new seller address
   */
  function addSeller(address _seller) public {
    require((msg.sender == contractOwner) || (isAdmin[msg.sender] == true));
    isSeller[_seller] = true;
  }

  /**
   * @notice mints a new token for the given buyer
   * @dev serialNo of product is used as token id
   * @param buyer wallet address of the buyer
   * @param serialNo serial number of the product
   * @param isSoulbound true if the product is soulbound
   * @param dataURI URI of the product
   */
  function mintWarrentyNFT(
    address buyer,
    uint256 serialNo,
    bool isSoulbound,
    string memory dataURI
  ) public {
    if (isSoulbound) {
      transferable[serialNo] = false;
    }
    _mint(buyer, serialNo);
    _setTokenURI(serialNo, dataURI);
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal virtual override {
    if (transferable[tokenId] == false) {
      require(
        from == address(0) || to == address(0),
        'Cannot transfer soulbound tokens'
      );
    }
  }

  function _afterTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal virtual override {}

  // The following functions are overrides required by Solidity.

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(tokenId);
  }

  function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
  {
    return super.tokenURI(tokenId);
  }
}
