<!-- .github/copilot-instructions.md
     Purpose: Give AI coding assistants focused, repository-specific guidance so they
     can be immediately productive editing and extending this LÖVE2D + Lua game.
-->

# Quick agent instructions — Battle Tactics Arena

Keep this short and concrete. Prefer edits that match existing style (Lua, small modules,
functional tables) and follow the file patterns under `core/`, `states/`, and `config/`.

- Project type: LÖVE2D game written in Lua (single-process, single-threaded runtime).
- Run locally with: `love .` (requires LÖVE2D installed; see `README.md`).

Key directories and responsibilities
- `main.lua` — entry point. Calls `states.setup()` and `states.switch("menu")` and sets window size.
- `states/` — game states (e.g., `menu.lua`, `game.lua`). State modules expose `load`, `update`, `draw`, and input handlers (mouse/keyboard).
- `core/` — small, single-responsibility modules:
  - `core/gameState.lua` — turn/AP tracking and win logic. Use `state:spendAP(amount)` and `state:currentTeam()`.
  - `core/map.lua` — tile layout drawing and hovered-tile detection. Tiles are identified by tags like "1,1" mapping to a tileset grid.
  - `core/character.lua` — character data and simple methods (draw, moveTo, takeDamage, heal). Character sprite grid and anims are loaded per class.
  - `core/combat.lua` — pure game logic for attack/heal resolution; returns structured result tables (ok, reason/type, animTag, etc.). Prefer calling this from UI/state code and drive FX from the returned table.
  - `core/animationRegistry.lua` and `core/tilesetRegistry.lua` — centralized loading and cloning of anim8 animations and tileset grids. Use `registry:getCharacter(class)` and `tilesets:getTileset(tag)` to avoid reloading images.

Important patterns & conventions
- Animation/tilesets: config-driven under `config/` (e.g., `config/characters.lua`, `config/tilesets.lua`, `config/fx.lua`). `AnimationRegistry:loadCharacters()` builds prototype anims; callers should clone via `getCharacter()` before mutating.
- Naming: classes and registry keys use camelCase (e.g., `ninjaDark`, `gladiatorBlue`) matching folder names under `assets/sprites/chars/`.
- Coordinates: Characters store integer tile coordinates `x,y`. `Map.tileSize` converts tiles → pixels. Use `map.tileSize` when drawing or placing FX.
- Combat API: `Combat.attack(attacker, defender, state)` and `Combat.heal(attacker, target, state)` both validate team/range/AP and return a table with keys like `ok`, `type`, `result`, `animTag`, `damage`, `ko`, `reason`.
- Side effects: Core modules generally do not mutate graphics state; `Combat` mutates Character HP/alive and `GameState` when AP is spent — UI should handle visual feedback using returned result tables.

Quick examples (follow these call sites)
- Play an attack and spawn FX:
  - call `local res = Combat.attack(attacker, defender, state)`
  - if `res.ok and res.animTag` → `local fx = registry:getFX(res.animTag)` then `fx.anim:gotoFrame(1)` and `table.insert(activeFX, {fx=fx, x=defender.x, y=defender.y})`
  - update remaining counts and remove units when `res.ko == true`.
- Get character anims:
  - `local charAnims = registry:getCharacter("NinjaDark")` returns `{ image, animations = { idle=..., walk=... } }`.

Files to inspect for behavior and examples
- `states/game.lua` — how map, registry, characters, FX, and `GameState` interact (draw/update/mousepressed patterns)
- `core/animationRegistry.lua` and `core/tilesetRegistry.lua` — cloning pattern for anims and tilesets
- `core/combat.lua` — canonical shape of result tables and helper functions (distance, pickAnimTag)
- `config/characters.lua`, `config/tilesets.lua`, `config/fx.lua` — canonical config shapes for assets

Developer workflows
- Run game locally: `love .`
- Image loading expects paths like `assets/sprites/chars/<Class>/SpriteSheet.png` and config paths in `config/*`.
- No automated tests present; keep changes small and run the game to verify runtime behavior.

What to avoid / gotchas
- Do not re-load images per-frame. Use the registries (`AnimationRegistry`, `TilesetRegistry`) to create shared prototypes and clone animations for instances.
- `anim8` animations are mutated (use `:clone()` before modifying). See `AnimationRegistry:getCharacter` and `getFX`.
- Coordinate mismatches: many modules assume top-left tile origin and 1-based Lua arrays; use existing `Map` helpers for hovered tiles.

If you need more context
- Read `README.md` for high-level goals; inspect `assets/` for class folders and `config/` for how animations/tiles are declared.

If anything here is unclear, tell me which area (graphics, combat, state flow, or file X) and I'll expand with concrete examples or add missing config keys.
