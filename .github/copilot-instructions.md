<!-- .github/copilot-instructions.md
Purpose: Focused, repository‑specific guidance so AI coding agents can be immediately productive
in editing and extending this LÖVE2D + Lua game (Battle Tactics Arena).
-->

# Copilot instructions — Battle Tactics Arena (concise)

This file documents the concrete, repo‑specific patterns and APIs an AI agent should know.
Keep edits small and follow the existing module style (Lua tables, small single‑responsibility modules).

- Project type: LÖVE2D game (Lua). Run locally with: `love .` (no build step).
- Entry: `main.lua` → calls `states.setup()` and `states.switch("menu")`.

## Big picture (architecture & why)
- Modular runtime: `main.lua` delegates to `states/*`. Each state (e.g., `states/game.lua`) manages UI + game objects.
- Pure game logic lives in `core/` (no drawing): `combat`, `gameState`, `character`, `map`, registries. UI/state code composes these modules and drives animations/FX.
- Asset registries (`core/animationRegistry.lua`, `core/tilesetRegistry.lua`) centralize image loading and produce prototype anims/grids; callers clone prototypes to avoid per‑frame reloads or mutation bugs.
- Config driven: `config/*.lua` declares characters, tilesets, and FX; add data here to extend assets without changing core logic.

## Key files & responsibilities (examples)
- `main.lua` — window setup and state switching.
- `states/game.lua` — example orchestration: builds `Map`, loads `AnimationRegistry`/`TilesetRegistry`, creates `Character` instances, and handles mouse input to call `Combat.*` and spawn FX.
- `core/combat.lua` — canonical API: `Combat.attack(attacker, defender, state)` and `Combat.heal(attacker, target, state)` return result tables (see below).
- `core/gameState.lua` — AP & turn management: use `state:spendAP(amount)`, `state:currentTeam()`, `state:endTurn()`.
- `core/animationRegistry.lua` — `loadCharacters()`, `loadFX()`, `getCharacter(class)` → returns {image, animations={...}} (cloned anims), `getFX(tag)` → {image, anim=clone}.
- `core/map.lua` — layout is a 2D array of strings like "col,row" (e.g., "1,1"); `Map.tileSize` is the tile pixel size.

## Concrete patterns / examples (copyable)
- Combat call site (state code):
  - local res = Combat.attack(attacker, defender, state)
  - if not res.ok then handle error (res.reason)
  - if res.animTag then local fx = registry:getFX(res.animTag); fx.anim:gotoFrame(1); table.insert(activeFX, {fx=fx, x=target.x, y=target.y})
  - if res.ko then remove the unit and decrement `state.remaining` accordingly (see `states/game.lua`).

- AnimationRegistry usage:
  - registry:loadCharacters()
  - local proto = registry:getCharacter("ninjaDark")
  - if proto then proto.animations.idle is safe to assign to a Character instance (it's already cloned).

- Map tiles and hovered tile:
  - Layout cells are strings in `"col,row"` form. `Map.new(tileSize, layout, tilesets, tilesetTag)` expects that format.
  - Use `map:getHoveredTile(x, y)` which returns the hovered tile coordinates (1‑based indices used in this repo).

## Project conventions & gotchas (do these exactly)
- Do NOT load images inside draw/update loops. Use the registries to load once and clone anims when needed.
- `anim8` animations are mutated; always use `protoAnim:clone()` before mutating frames or switching speed.
- Coordinates are tile indices (integers like `x=2, y=4`) and map draws using `x * map.tileSize` / `y * map.tileSize`.
- Tileset frame tags are 1‑based strings (`"1,1"`). `Map:draw` expects these strings and uses the tileset grid accordingly.

## Integration points & extension notes
- Add a new character class:
  1. Add sprite sheet to `assets/sprites/chars/<class>/SpriteSheet.png`.
  2. Add an entry in `config/characters.lua` with `path`, `frameW/frameH`, and `animations` (see existing entries).
  3. Use `registry:loadCharacters()` at state init, then `local charAnims = registry:getCharacter("yourClass")` and assign `char.anim = charAnims.animations.idle`.

- Add new FX:
  - Add file under `assets/sprites/fx/`, add config in `config/fx.lua`, then call `registry:getFX(tag)` where needed.

## Developer workflow & quick checks
- Run: `love .` (LÖVE2D must be installed). No build step or tests in repo.
- If the game errors at startup, the usual causes are missing assets or misconfigured `frameW/frameH` in `config/*`.
- Use `print()` or `pcall()` in states for fast debugging. The code uses `pcall()` defensively in several places.

## Minimal contract for changes (when editing core modules)
- Inputs: keep function signatures unchanged where callers in `states/` expect them (e.g., `Combat.attack(attacker, defender, state)`).
- Outputs: `Combat.*` must continue returning the result table shape `{ ok=bool, type=string, animTag=string?, result=..., damage=number?, ko=bool?, reason=string? }`.
- Side effects: `Combat` may mutate `defender.hp`/`alive` and call `state:spendAP()`; do not mutate graphics or registries inside core logic.

## Quick reference (files to open first)
- `states/game.lua` — orchestration and examples of best practices
- `core/combat.lua` — canonical result shapes
- `core/animationRegistry.lua` — how to load & clone anims
- `config/*.lua` — how to declare assets

If you want, I can also:
- add a short example PR that adds a new character config + sprite placeholder, and wire it into `states/game.lua` as a sample; or
- expand this doc with a short checklist for adding new tilesets or an example of a failing runtime error and how to diagnose it.

If any area is unclear (graphics, combat, state flow, or a specific file), tell me which one and I will expand with code snippets or a tiny automated sanity check.
