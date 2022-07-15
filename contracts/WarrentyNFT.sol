// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract WarrentyNFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
  constructor() ERC721('Warrenty', 'W') {}

  /**
   * @notice mints a new token for the given buyer
   * @dev serialNo of product is used as token id
   * @param buyer wallet address of the buyer
   * @param serialNo serial number of the product
   * @param dataURI URI of the product
   */

  function mintWarrentyNFT(
    address buyer,
    uint256 serialNo,
    string memory dataURI
  ) public {
    _mint(buyer, serialNo);
    _setTokenURI(serialNo, dataURI);
  }

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
