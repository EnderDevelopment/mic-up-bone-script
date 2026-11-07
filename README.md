# Roblox Bone Tool Script

Mic Up Bone Script is a server-authoritative Roblox script that adds a throwable Bone tool to your own Roblox experience. This Roblox script includes a Tool, client input handling, server-side projectile validation, cooldown control, aim-distance limits, projectile lifetime management, and Humanoid damage handling.

## Install

1. Open your Roblox experience in Roblox Studio.
2. In `ServerScriptService`, create a `Script` named `BoneToolServer`.
3. Copy the contents of `src/ServerScriptService/BoneToolServer.server.lua` into the new Script.
4. In `StarterPlayer > StarterPlayerScripts`, create a `LocalScript` named `BoneToolClient`.
5. Copy the contents of `src/StarterPlayer/StarterPlayerScripts/BoneToolClient.client.lua` into the new LocalScript.
6. Save and publish your experience.

The server script automatically creates the required `BoneToolRemote` RemoteEvent in `ReplicatedStorage`. Players receive the Bone tool after their character spawns.

## Use

1. Start a play session in Roblox Studio.
2. Equip the Bone tool from the player Backpack.
3. Activate the tool while aiming with the mouse.
4. The Bone projectile travels toward the mouse position.
5. A projectile damages the first other Humanoid it touches for 18 damage.
6. Test multiplayer damage with `Test > Start` and at least two players.

The server validates that the player is holding the Bone tool, limits the maximum aim distance to 500 studs, and enforces a 1.25-second cooldown. Projectiles are removed after five seconds.

To customize the tool, edit the constants near the top of `BoneToolServer.server.lua`:

- `COOLDOWN_SECONDS`
- `PROJECTILE_SPEED`
- `PROJECTILE_LIFETIME`
- `DAMAGE`
- `MAX_AIM_DISTANCE`

The script uses Roblox mesh asset IDs for the visible Bone model. Replace them only with assets you are authorized to use in your experience. If the mesh cannot load, the projectile still functions as a basic Part.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/5333df4e-53ae-45c6-a66e-bb834ca85dad?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=5333df4e-53ae-45c6-a66e-bb834ca85dad
