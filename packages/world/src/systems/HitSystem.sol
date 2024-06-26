// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { Player } from "../codegen/tables/Player.sol";
import { ReversePlayer } from "../codegen/tables/ReversePlayer.sol";
import { PlayerMetadata } from "../codegen/tables/PlayerMetadata.sol";
import { ObjectType } from "../codegen/tables/ObjectType.sol";
import { Position } from "../codegen/tables/Position.sol";
import { ReversePosition } from "../codegen/tables/ReversePosition.sol";
import { Equipped } from "../codegen/tables/Equipped.sol";
import { Health } from "../codegen/tables/Health.sol";
import { Stamina } from "../codegen/tables/Stamina.sol";
import { ObjectTypeMetadata } from "../codegen/tables/ObjectTypeMetadata.sol";
import { PlayerActivity } from "../codegen/tables/PlayerActivity.sol";

import { VoxelCoord } from "@biomesaw/utils/src/Types.sol";
import { MAX_PLAYER_HEALTH, MAX_PLAYER_STAMINA, PLAYER_HAND_DAMAGE, HIT_STAMINA_COST } from "../Constants.sol";
import { AirObjectID, PlayerObjectID } from "../ObjectTypeIds.sol";
import { positionDataToVoxelCoord, callGravity, inSpawnArea } from "../Utils.sol";
import { useEquipped } from "../utils/InventoryUtils.sol";
import { regenHealth, regenStamina, despawnPlayer } from "../utils/PlayerUtils.sol";
import { inSurroundingCube, voxelCoordsAreEqual } from "@biomesaw/utils/src/VoxelCoordUtils.sol";

contract HitSystem is System {
  function hit(address hitPlayer) public {
    bytes32 playerEntityId = Player._get(_msgSender());
    require(playerEntityId != bytes32(0), "HitSystem: player does not exist");
    require(!PlayerMetadata._getIsLoggedOff(playerEntityId), "HitSystem: player isn't logged in");

    bytes32 hitEntityId = Player._get(hitPlayer);
    require(hitEntityId != bytes32(0), "HitSystem: hit player does not exist");
    require(playerEntityId != hitEntityId, "HitSystem: cannot hit yourself");
    require(!PlayerMetadata._getIsLoggedOff(hitEntityId), "HitSystem: hit player isn't logged in");

    VoxelCoord memory playerCoord = positionDataToVoxelCoord(Position._get(playerEntityId));
    VoxelCoord memory hitCoord = positionDataToVoxelCoord(Position._get(hitEntityId));
    require(!inSpawnArea(hitCoord), "HitSystem: cannot hit players in spawn area");
    require(inSurroundingCube(playerCoord, 1, hitCoord), "HitSystem: hit entity is not in surrounding cube of player");

    regenHealth(playerEntityId);
    regenStamina(playerEntityId, playerCoord);

    regenHealth(hitEntityId);

    // Update stamina and health
    uint32 currentStamina = Stamina._getStamina(playerEntityId);
    uint16 staminaRequired = HIT_STAMINA_COST;
    require(currentStamina >= staminaRequired, "HitSystem: player does not have enough stamina");
    Stamina._setStamina(playerEntityId, currentStamina - staminaRequired);

    uint16 receiverDamage = PLAYER_HAND_DAMAGE;
    bytes32 equippedEntityId = Equipped._get(playerEntityId);
    if (equippedEntityId != bytes32(0)) {
      receiverDamage = ObjectTypeMetadata._getDamage(ObjectType._get(equippedEntityId));
    }

    uint16 currentHealth = Health._getHealth(hitEntityId);
    uint16 newHealth = currentHealth > receiverDamage ? currentHealth - receiverDamage : 0;
    Health._setHealth(hitEntityId, newHealth);

    useEquipped(playerEntityId, equippedEntityId);

    PlayerActivity._set(playerEntityId, block.timestamp);

    if (newHealth == 0) {
      despawnPlayer(hitEntityId);

      VoxelCoord memory aboveCoord = VoxelCoord(hitCoord.x, hitCoord.y + 1, hitCoord.z);
      bytes32 aboveEntityId = ReversePosition._get(aboveCoord.x, aboveCoord.y, aboveCoord.z);
      if (aboveEntityId != bytes32(0) && ObjectType._get(aboveEntityId) == PlayerObjectID) {
        callGravity(aboveEntityId, aboveCoord);
      }
    } else {
      PlayerMetadata._setLastHitTime(hitEntityId, block.timestamp);
      PlayerActivity._set(hitEntityId, block.timestamp);
    }
  }
}
