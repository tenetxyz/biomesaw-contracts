// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { VoxelCoord } from "@biomesaw/utils/src/Types.sol";

/**
 * @title IDropSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IDropSystem {
  function drop(uint8 dropObjectTypeId, uint16 numToDrop, VoxelCoord memory coord) external;

  function dropTool(bytes32 toolEntityId, VoxelCoord memory coord) external;
}
