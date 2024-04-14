// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { VoxelCoord } from "@biomesaw/utils/src/Types.sol";

/**
 * @title ITerrainSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface ITerrainSystem {
  function getTerrainObjectTypeId(VoxelCoord memory coord) external view returns (uint8);

  function getTerrainObjectTypeIdWithCacheSet(VoxelCoord memory coord) external returns (uint8);

  function computeTerrainObjectTypeId(VoxelCoord memory coord) external view returns (uint8);
}
