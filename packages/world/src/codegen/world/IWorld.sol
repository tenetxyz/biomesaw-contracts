// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";

import { IActivateSystem } from "./IActivateSystem.sol";
import { IAdminTerrainSystem } from "./IAdminTerrainSystem.sol";
import { IBuildSystem } from "./IBuildSystem.sol";
import { ICraftSystem } from "./ICraftSystem.sol";
import { IDropSystem } from "./IDropSystem.sol";
import { IEquipSystem } from "./IEquipSystem.sol";
import { IGravitySystem } from "./IGravitySystem.sol";
import { IHitSystem } from "./IHitSystem.sol";
import { IInitDyedBlocksSystem } from "./IInitDyedBlocksSystem.sol";
import { IInitHandBlocksSystem } from "./IInitHandBlocksSystem.sol";
import { IInitInteractablesSystem } from "./IInitInteractablesSystem.sol";
import { IInitPlayersSystem } from "./IInitPlayersSystem.sol";
import { IInitTerrainBlocksSystem } from "./IInitTerrainBlocksSystem.sol";
import { IInitThermoblastSystem } from "./IInitThermoblastSystem.sol";
import { IInitWorkbenchSystem } from "./IInitWorkbenchSystem.sol";
import { IInitSpawnSystem } from "./IInitSpawnSystem.sol";
import { ILoginSystem } from "./ILoginSystem.sol";
import { ILogoffSystem } from "./ILogoffSystem.sol";
import { IMineSystem } from "./IMineSystem.sol";
import { IMoveSystem } from "./IMoveSystem.sol";
import { IProcGenSystem } from "./IProcGenSystem.sol";
import { IReadSystem } from "./IReadSystem.sol";
import { ISpawnSystem } from "./ISpawnSystem.sol";
import { ITerrainSystem } from "./ITerrainSystem.sol";
import { ITransferSystem } from "./ITransferSystem.sol";
import { IUnequipSystem } from "./IUnequipSystem.sol";

/**
 * @title IWorld
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @notice This interface integrates all systems and associated function selectors
 * that are dynamically registered in the World during deployment.
 * @dev This is an autogenerated file; do not edit manually.
 */
interface IWorld is
  IBaseWorld,
  IActivateSystem,
  IAdminTerrainSystem,
  IBuildSystem,
  ICraftSystem,
  IDropSystem,
  IEquipSystem,
  IGravitySystem,
  IHitSystem,
  IInitDyedBlocksSystem,
  IInitHandBlocksSystem,
  IInitInteractablesSystem,
  IInitPlayersSystem,
  IInitTerrainBlocksSystem,
  IInitThermoblastSystem,
  IInitWorkbenchSystem,
  IInitSpawnSystem,
  ILoginSystem,
  ILogoffSystem,
  IMineSystem,
  IMoveSystem,
  IProcGenSystem,
  IReadSystem,
  ISpawnSystem,
  ITerrainSystem,
  ITransferSystem,
  IUnequipSystem
{}
