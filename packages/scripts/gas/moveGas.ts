import { setupGasTest } from "./common";
import { VoxelCoord } from "@latticexyz/utils";

export async function printMoveGasCosts(
  preMoveCoords: VoxelCoord[],
  moveCoords: VoxelCoord[],
  preFillTerrain: boolean = false
) {
  const { spawnCoord, txOptions, terrainTxOptions, callTx } = await setupGasTest();

  await callTx(
    {
      ...txOptions,
      functionName: "move",
      args: [preMoveCoords],
    },
    "pre move " + preMoveCoords.length
  );

  for (let i = 0; i < moveCoords.length; i++) {
    const moveCoord = moveCoords[i];

    if (preFillTerrain) {
      await callTx(
        {
          ...txOptions,
          functionName: "fillObjectTypeWithComputedTerrainCache",
          args: [moveCoord],
        },
        "fill"
      );

      const belowCoord = { x: moveCoord.x, y: moveCoord.y - 1, z: moveCoord.z };
      await callTx(
        {
          ...txOptions,
          functionName: "fillObjectTypeWithComputedTerrainCache",
          args: [belowCoord],
        },
        "fill below"
      );
    }
  }

  await callTx(
    {
      ...txOptions,
      functionName: "move",
      args: [moveCoords],
    },
    "move " + moveCoords.length
  );
}
