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
  // Product ID to warrenty period
  mapping(uint256 => uint256) private warrentyPeriod;
  // tokenID to time stamp of when the token was created
  mapping(uint256 => uint256) private issueTime;

  event Repair(uint256 indexed tokenID, string note);
  event Replace(
    uint256 indexed tokenID,
    uint256 indexed newTokenID,
    string note
  );

  constructor() ERC721('Warrenty', 'W') {
    contractOwner = msg.sender;
  }

  /**
   * @notice Add a new admin
   * @dev Only the contract owner and an existing admin can add a new admin
   * @param _admin The new admin address
   */
  function addAdmin(address _admin) public {
    require(
      (msg.sender == contractOwner) || (isAdmin[msg.sender] == true),
      'Only the contract owner or an existing admin can add a new admin'
    );
    isAdmin[_admin] = true;
  }

  /**
   * @notice Remove an admin
   * @dev Only the contract owner and an existing admin can remove an admin. An admin can remove themselves.
   * @param _admin The admins address to remove
   */
  function removeAdmin(address _admin) public {
    require(
      (msg.sender == contractOwner) || (isAdmin[msg.sender] == true),
      'Only the contract owner or an existing admin can remove an admin'
    );
    isAdmin[_admin] = false;
  }

  /**
   * @notice Add a new seller
   * @dev Only the contract owner and the admins can add a new seller
   * @param _seller The new seller address to add
   */
  function addSeller(address _seller) public {
    require(
      (msg.sender == contractOwner) || (isAdmin[msg.sender] == true),
      'Only the contract owner or an existing admin can add a new seller'
    );
    isSeller[_seller] = true;
  }

  /**
   * @notice Remove a seller
   * @dev Only the contract owner and the admins can remove seller
   * @param _seller The sellers address to remove
   */
  function removeSeller(address _seller) public {
    require(
      (msg.sender == contractOwner) || (isAdmin[msg.sender] == true),
      'Only the contract owner or an existing admin can remove a seller'
    );
    isSeller[_seller] = false;
  }

  /**
   * @notice add a new product
   * @dev only a registered seller can add a new product
   * @param productID product ID of new product
   * @param _warrentyPeriod warrenty period offered on the product
   * @param _isSoulbound if the product warrenty is transferable or not
   */
  function addProduct(
    uint256 productID,
    uint256 _warrentyPeriod,
    bool _isSoulbound
  ) public {
    warrentyPeriod[productID] = _warrentyPeriod;
    transferable[productID] = !_isSoulbound;
  }

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
    issueTime[serialNo] = block.timestamp;
    _safeMint(buyer, serialNo);
    _setTokenURI(serialNo, dataURI);
  }

  /**
   * @notice Emits an event when the product is repaired
   * @param serialNo serial number of the product repaired
   * @param note note about repair
   */
  function repairProduct(uint256 serialNo, string memory note) public {
    require(isSeller[msg.sender] == true, 'Only sellers can repair a product');
    emit Repair(serialNo, note);
  }

  /**
   * @notice Emits an event when the product is replaced
   * @param tokenID token ID of the product to be replaced
   * @param newTokenID token ID of the new product
   * @param note note about replacement
   */
  function replaceProduct(
    uint256 tokenID,
    uint256 newTokenID,
    string memory note
  ) public {
    require(isSeller[msg.sender] == true, 'Only sellers can replace a product');
    issueTime[newTokenID] = issueTime[tokenID];
    emit Replace(tokenID, newTokenID, note);
  }

  /**
   * @dev Prevents transfering of soulbound tokens
   */
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
