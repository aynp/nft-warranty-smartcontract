# Smart Contract for Warrenties using NFT

## Assumptions

- Product ID - Identify a particular product.
- Serial Number - Identify a particular product instance.
- A product can be uniquely identified given its Product ID and Serial Number.
- Token ID of NFT genrated for a product is `[Product ID][serial number]`.

## Project

### Planned Structure

- #### Owner
  Deployer of the smart contract.
- #### Admin
  Admins of the smart contract.
  - Can add/remove sellers.
- #### Seller
  Seller of the product/warranty (Brands).
  - Add/remove products (specify warranty period of each product)

### Planning

- Tracking repairs and replacements.
- Add mapping for isAdmin and isSeller so that frontend can check if user is admin or seller and display corresponding panel accordingly.
- Soulbound NFTs

### Yet to Plan

- **Loyalty Program**.
- Implement automatic burn of tokens after warranty expries.
