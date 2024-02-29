// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IWorld } from "../codegen/world/IWorld.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { SystemSwitch } from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import { IMoveSystem } from "../codegen/world/IMoveSystem.sol";
import { getUniqueEntity } from "@latticexyz/world-modules/src/modules/uniqueentity/getUniqueEntity.sol";
import { Player } from "../codegen/tables/Player.sol";
import { PlayerMetadata } from "../codegen/tables/PlayerMetadata.sol";
import { ObjectType } from "../codegen/tables/ObjectType.sol";
import { ObjectTypeMetadata } from "../codegen/tables/ObjectTypeMetadata.sol";
import { Position } from "../codegen/tables/Position.sol";
import { ReversePosition } from "../codegen/tables/ReversePosition.sol";
import { Stamina } from "../codegen/tables/Stamina.sol";
import { Inventory } from "../codegen/tables/Inventory.sol";

import { VoxelCoord } from "@everlonxyz/utils/src/Types.sol";
import { MAX_PLAYER_BUILD_MINE_HALF_WIDTH } from "../Constants.sol";
import { AirObjectID, PlayerObjectID } from "../ObjectTypeIds.sol";
import { positionDataToVoxelCoord, getTerrainObjectTypeId } from "../Utils.sol";
import { addToInventoryCount, useEquipped } from "../utils/InventoryUtils.sol";
import { regenHealth, regenStamina } from "../utils/PlayerUtils.sol";
import { applyGravity } from "../utils/GravityUtils.sol";
import { inSurroundingCube } from "@everlonxyz/utils/src/VoxelCoordUtils.sol";

contract MineSystem is System {
  function mine(bytes32 objectTypeId, VoxelCoord memory coord) public returns (bytes32) {
    require(ObjectTypeMetadata.getIsBlock(objectTypeId), "MineSystem: object type is not a block");
    require(objectTypeId != AirObjectID, "MineSystem: cannot mine air");

    bytes32 playerEntityId = Player.get(_msgSender());
    require(playerEntityId != bytes32(0), "MineSystem: player does not exist");
    require(
      inSurroundingCube(
        positionDataToVoxelCoord(Position.get(playerEntityId)),
        MAX_PLAYER_BUILD_MINE_HALF_WIDTH,
        coord
      ),
      "MineSystem: player is too far from the block"
    );
    regenHealth(playerEntityId);
    regenStamina(playerEntityId);
    useEquipped(playerEntityId);

    // Spend stamina for mining
    uint32 currentStamina = Stamina.getStamina(playerEntityId);
    uint32 staminaRequired = ObjectTypeMetadata.getMass(objectTypeId) * 5;
    require(currentStamina >= staminaRequired, "MineSystem: not enough stamina");
    Stamina.setStamina(playerEntityId, currentStamina - staminaRequired);

    bytes32 entityId = ReversePosition.get(coord.x, coord.y, coord.z);
    if (entityId == bytes32(0)) {
      // Check terrain block type
      require(getTerrainObjectTypeId(coord) == objectTypeId, "MineSystem: block type does not match with terrain type");

      // Create new entity
      entityId = getUniqueEntity();
      ObjectType.set(entityId, objectTypeId);

      // Make the position here air
      bytes32 airEntityId = getUniqueEntity();
      ObjectType.set(airEntityId, AirObjectID);
      Position.set(airEntityId, coord.x, coord.y, coord.z);
      ReversePosition.set(coord.x, coord.y, coord.z, airEntityId);
    } else {
      require(ObjectType.get(entityId) == objectTypeId, "MineSystem: invalid block type");

      Position.deleteRecord(entityId);
      ReversePosition.deleteRecord(coord.x, coord.y, coord.z);
    }

    Inventory.set(entityId, playerEntityId);
    addToInventoryCount(playerEntityId, PlayerObjectID, objectTypeId, 1);

    // Apply gravity
    VoxelCoord memory aboveCoord = VoxelCoord(coord.x, coord.y + 1, coord.z);
    bytes32 aboveEntityId = ReversePosition.get(aboveCoord.x, aboveCoord.y, aboveCoord.z);
    if (aboveEntityId != bytes32(0) && ObjectType.get(aboveEntityId) == PlayerObjectID) {
      applyGravity(_msgSender(), aboveEntityId, aboveCoord);
    }

    return entityId;
  }
}
