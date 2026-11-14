# Roblox Studio Ability Tester (Rojo Project)

A clean Roblox Studio + Rojo project template for testing `AbiSkill1` through `AbiSkill5` RemoteEvents with toggle loops and server-side validation.

## Folder Structure

- `default.project.json` - Rojo project configuration mapping folders to Roblox Studio services.
- `src/client/AbilityTester.client.lua` - Client UI script with 5 independent toggle loops (`AbiSkill1` to `AbiSkill5`).
- `src/server/AbilityHandler.server.lua` - Server script that creates the `Stuff` folder, generates `AbiSkill1` through `AbiSkill5` RemoteEvents, and handles cooldowns.
- `src/shared/AbilityConfig.lua` - Shared configuration table defining loop delays and server cooldowns.

## Setup Instructions

1. Upload this repository to GitHub.
2. Install **Rojo** in VS Code and the **Rojo Plugin** in Roblox Studio.
3. Run `rojo serve` in your project directory and click **Connect** in Roblox Studio.
4. Optional: Replace the fallback UI in `AbilityTester.client.lua` with `require(ReplicatedStorage.Shared.RayfieldModule)` once you place the Rayfield `ModuleScript` inside `src/shared/`.
