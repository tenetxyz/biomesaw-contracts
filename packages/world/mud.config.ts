import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  tables: {
    ObjectType: {
      schema: {
        entityId: "bytes32",
        objectTypeId: "uint8",
      },
      key: ["entityId"],
      codegen: {
        storeArgument: true,
      },
    },
    Position: {
      schema: {
        entityId: "bytes32",
        x: "int16",
        y: "int16",
        z: "int16",
      },
      key: ["entityId"],
      codegen: {
        storeArgument: true,
      },
    },
    ReversePosition: {
      schema: {
        x: "int16",
        y: "int16",
        z: "int16",
        entityId: "bytes32",
      },
      key: ["x", "y", "z"],
      codegen: {
        storeArgument: true,
      },
    },
    LastKnownPosition: {
      schema: {
        entityId: "bytes32",
        x: "int16",
        y: "int16",
        z: "int16",
      },
      key: ["entityId"],
      codegen: {
        storeArgument: true,
      },
    },
    Player: {
      schema: {
        player: "address",
        entityId: "bytes32",
      },
      key: ["player"],
      codegen: {
        storeArgument: true,
      },
    },
    ReversePlayer: {
      schema: {
        entityId: "bytes32",
        player: "address",
      },
      key: ["entityId"],
      codegen: {
        storeArgument: true,
      },
    },
    PlayerMetadata: {
      schema: {
        entityId: "bytes32",
        isLoggedOff: "bool",
        lastMoveBlock: "uint256",
        lastHitTime: "uint256",
        numMovesInBlock: "uint16",
      },
      key: ["entityId"],
      codegen: {
        storeArgument: true,
      },
    },
    Inventory: {
      schema: {
        entityId: "bytes32",
        ownerEntityId: "bytes32",
      },
      key: ["entityId"],
      codegen: {
        storeArgument: true,
      },
    },
    ReverseInventory: {
      schema: {
        ownerEntityId: "bytes32",
        entityIds: "bytes32[]",
      },
      key: ["ownerEntityId"],
      codegen: {
        storeArgument: true,
      },
    },
    ItemMetadata: {
      schema: {
        entityId: "bytes32",
        numUsesLeft: "uint24",
      },
      key: ["entityId"],
      codegen: {
        storeArgument: true,
      },
    },
    InventorySlots: {
      schema: {
        ownerEntityId: "bytes32",
        numSlotsUsed: "uint16",
      },
      key: ["ownerEntityId"],
      codegen: {
        storeArgument: true,
      },
    },
    InventoryCount: {
      schema: {
        ownerEntityId: "bytes32",
        objectTypeId: "uint8",
        count: "uint16",
      },
      key: ["ownerEntityId", "objectTypeId"],
      codegen: {
        storeArgument: true,
      },
    },
    Equipped: {
      schema: {
        entityId: "bytes32",
        inventoryEntityId: "bytes32",
      },
      key: ["entityId"],
      codegen: {
        storeArgument: true,
      },
    },
    Health: {
      schema: {
        entityId: "bytes32",
        lastUpdatedTime: "uint256",
        health: "uint16",
      },
      key: ["entityId"],
      codegen: {
        storeArgument: true,
      },
    },
    Stamina: {
      schema: {
        entityId: "bytes32",
        lastUpdatedTime: "uint256",
        stamina: "uint32",
      },
      key: ["entityId"],
      codegen: {
        storeArgument: true,
      },
    },
  },
  systems: {
    GravitySystem: {
      name: "GravitySystem",
      openAccess: false,
      accessList: [],
    },
  },
  modules: [
    {
      name: "UniqueEntityModule",
      root: true,
      args: [],
    },
  ],
});