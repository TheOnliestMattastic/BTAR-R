# Game Specification: Battle Tactics Arena (BTAR-R)

## Overview

**Battle Tactics Arena (BTAR-R)** is a 2D turn-based tactical RPG prototype built with Lua and the LÖVE2D framework. The game features grid-based combat, multiple character classes, an Action Point (AP) economy, and modular architecture designed for easy extension.

### Core Concept

- **Turn-Based Strategy**: Players alternate turns commanding their units on a grid-based battlefield.
- **Pass & Play**: Local multiplayer for two players on the same device.
- **Victory Condition**: Eliminate all enemy units.
- **Modular Design**: Data-driven configuration allows adding new classes, maps, and mechanics without core code changes.

## Game Mechanics

### Turn Structure

- **Team Turns**: Alternating turns between Green (odd turns) and Red (even turns) teams.
- **Action Points (AP)**: Each team starts with 3 AP per turn, maximum 5 AP.
- **Turn End**: AP resets to 3 for the next team when turn ends.
- **AP Costs**:
  - Basic Attack: 1 AP
  - Heal: 2 AP
  - Movement: Free (limited by character speed)

### Grid-Based Movement

- **Tile Grid**: 32x32 pixel tiles forming a rectangular battlefield.
- **Movement Range**: Limited by character `spd` stat (Manhattan distance).
- **Pathfinding**: Direct movement to target tile if within range.
- **Animation**: Smooth walking animations with directional sprites.

### Combat System

#### Attack Resolution

1. **Range Check**: Manhattan distance ≤ attacker's `rng` stat.
2. **Team Check**: Cannot attack allies.
3. **Accuracy Calculation**:
   - Base hit chance: 60%
   - Attacker bonus: `dex * 8`
   - Defender dodge: `dex * 5` chance to dodge if hit roll succeeds.
4. **Outcomes**: Hit, Miss, or Dodge.
5. **Damage**: `max(1, attacker.pwr - defender.def)`

#### Healing

- **Target**: Same-team units within range.
- **Effect**: Restore HP up to max (25).
- **Restrictions**: Only healer classes can heal (currently none implemented beyond basic checks).

#### Special Abilities

- Framework exists for class-specific animations and effects.
- Planned: Slash, Bash, Projectile, Fire, Dual-wield attacks.

### Character System

#### Stats

- **HP** (Health Points): 25 max, reduced by damage.
- **PWR** (Power): Damage multiplier/heal amount.
- **DEF** (Defense): Damage reduction.
- **DEX** (Dexterity): Accuracy bonus/evasion.
- **SPD** (Speed): Movement range/turn order influence.
- **RNG** (Range): Attack distance.

#### Current Classes

| Class | HP | PWR | DEF | DEX | SPD | RNG | Notes |
|-------|----|-----|-----|-----|-----|-----|-------|
| Ninja | 25 | 5 | 2 | 5 | 4 | 2 | High mobility, good evasion |
| Gladiator | 25 | 7 | 5 | 2 | 2 | 1 | High damage, tanky |

#### Character States

- **Alive/Dead**: HP ≤ 0 marks death.
- **Selected**: Visual highlight for active unit.
- **Animating**: Walking, attacking, or idle animations.

## Map System

### Generation

- **Randomized Tiles**: Procedural tile placement from tileset.
- **Tilesets**: Configurable sprite sheets with frame dimensions.
- **Size**: Fits window (960x640) with 32px tiles.

### Interaction

- **Hover Detection**: Highlight hovered tiles.
- **Movement Highlight**: Show reachable tiles for selected character.
- **Obstacle Check**: Characters block movement paths.

## User Interface

### Game States

- **Menu**: Title screen with start option.
- **Game**: Active battlefield with units and map.
- **Win/Loss**: Game over screen.

### Visual Feedback

- **Selection**: Yellow outline around selected character.
- **Movement Range**: Highlighted tiles within movement distance.
- **Messages**: Text feedback for actions (movement, attacks, errors).
- **FX**: Animated effects for attacks and abilities.

### Input

- **Mouse**: Click to select units, move, or attack.
- **Selection Logic**:
  - Click ally: Select
  - Click enemy: Attack (if in range)
  - Click empty tile: Move (if in range)
  - Click selected: Deselect

## Technical Architecture

### Code Structure

```
/core          → Game logic modules
  ├── character.lua      → Unit entities and stats
  ├── gameState.lua      → Turn and AP management
  ├── combat.lua         → Attack/heal resolution
  ├── map.lua            → Grid and tile rendering
  ├── gameHelpers.lua    → Utility functions
  └── registries/        → Asset management
/config        → Data definitions
  ├── characters.lua     → Class configs
  ├── tilesets.lua       → Map tile assets
  └── fx.lua             → Effect animations
/states        → Game state management
  ├── menu.lua           → Title screen
  └── game.lua           → Battlefield
/assets        → Sprites and graphics
/lib           → Third-party libraries (anim8, timer)
```

### Key Modules

#### Character Module

- **Responsibilities**: Stats, position, animations, movement.
- **Methods**: `new()`, `update()`, `draw()`, `moveTo()`, `takeDamage()`, `heal()`.
- **Animation System**: Uses `anim8` library with directional sprites.

#### GameState Module

- **Responsibilities**: Turn progression, AP tracking, win conditions.
- **AP Management**: Spend, reset, and clamp AP values.

#### Combat Module

- **Responsibilities**: Hit resolution, damage calculation, range checking.
- **Balance Config**: Tunable constants for accuracy, damage, AP costs.

#### Map Module

- **Responsibilities**: Tile rendering, hover detection, movement highlighting.
- **Data Structure**: 2D array of tile coordinates.

### Registries

- **AnimationRegistry**: Loads character and FX animations.
- **TilesetRegistry**: Manages map tile assets.
- **UIRegistry**: Handles UI elements (planned).

### Data-Driven Design

- **Configuration Files**: Add content without code changes.
- **Example**: New character class requires only config entry with stats and sprite path.

## Animation and Effects

### Character Animations

- **Directions**: 4-directional (down, up, left, right).
- **States**: Idle, walking, attacking.
- **Library**: `anim8` for sprite sheet animation.

### FX System

- **Attack Effects**: Slash, bash, projectile animations.
- **Placement**: Tile-based positioning.
- **Lifecycle**: Auto-remove completed animations.

## Balance and Tuning

### AP Economy

- **Turn Reset**: 3 AP per turn.
- **Max Cap**: 5 AP (prevents infinite accumulation).
- **Action Costs**: Attack (1), Heal (2), Move (0).

### Stat Balance

- **Ninja**: Mobile skirmisher (high SPD/DEX, low DEF).
- **Gladiator**: Frontline fighter (high PWR/DEF, low SPD).

### Combat Probabilities

- **Base Hit**: 60% + 8% per DEX point.
- **Dodge**: 5% per DEX point (after hit roll).
- **Minimum Damage**: 1 (guaranteed impact).

## Future Enhancements

### Planned Features

1. **More Character Classes**: Mage, Ranger, etc. with unique abilities.
2. **Special Attacks**: Beyond basic attacks (skills, spells).
3. **AI Opponent**: Computer-controlled enemy turns.
4. **Enhanced UI**: In-game menus, health bars, ability buttons.
5. **Save/Load**: Persistent game state.
6. **Multiplayer**: Network support.
7. **Sound**: Audio effects and music.
8. **Testing**: Unit tests for core modules.

### Technical Improvements

- **State Machine**: More robust game state transitions.
- **Pathfinding**: Advanced movement algorithms.
- **Modding Support**: User-created content.
- **Performance**: Optimization for larger maps/battles.

## Development Guidelines

### Code Style

- **Modular**: Separate concerns into focused modules.
- **Data-Driven**: Config files for game content.
- **Encapsulated**: Use metatables for OOP-style entities.
- **Commented**: ADHD-friendly reminder comments for code blocks.
- **Consistent Naming**: camelCase for variables/functions, PascalCase for modules.

### Best Practices

- **Error Handling**: Use `pcall` for risky operations (drawing, updating).
- **Global Avoidance**: Local tables and require statements.
- **Version Control**: Regular commits with clear messages.
- **Documentation**: Update AGENT.md and spec.md with changes.

## Conclusion

BTAR-R serves as both a playable tactical RPG prototype and a demonstration of clean, professional game development practices. The modular architecture and data-driven design make it an excellent foundation for expansion into a full-featured game, while the current implementation provides engaging turn-based combat with strategic depth.
