# ⚔️ Battle Tactics Arena: Refactored & Remastered

```txt
___________.__             ________         .__  .__                 __   
\__    ___/|  |__   ____   \_____  \   ____ |  | |__| ____   _______/  |_ 
  |    |   |  |  \_/ __ \   /   |   \ /    \|  | |  |/ __ \ /  ___/\   __\
  |    |   |   Y  \  ___/  /    |    \   |  \  |_|  \  ___/ \___ \  |  |  
  |____|   |___|  /\___  > \_______  /___|  /____/__|\___  >____  > |__|  
                \/     \/          \/     \/             \/     \/        
/\        _____          __    __                   __  .__             /\
\ \      /     \ _____ _/  |__/  |______    _______/  |_|__| ____      / /
 \ \    /  \ /  \\__  \\   __\   __\__  \  /  ___/\   __\  |/ ___\    / / 
  \ \  /    Y    \/ __ \|  |  |  |  / __ \_\___ \  |  | |  \  \___   / /  
   \ \ \____|__  (____  /__|  |__| (____  /____  > |__| |__|\___  > / /   
    \/         \/     \/                \/     \/               \/  \/    
```

[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-bd93f9?style=for-the-badge&logoColor=white&labelColor=6272a4)](https://creativecommons.org/licenses/by-sa/4.0/)
![Language](https://img.shields.io/badge/Lua-LÖVE2D-bd93f9?style=for-the-badge&logo=githubpages&logoColor=white&labelColor=6272a4)
![Status](https://img.shields.io/badge/Status-WIP-yellow?style=for-the-badge&logoColor=white&labelColor=6272a4)

## 🔭 Overview

**Battle Tactics Arena (BTA)** is a **2D turn‑based tactical RPG prototype** built with **Lua** and the **LÖVE2D framework**.  

Originally created as a class project, the game has been **rebuilt from the ground up** to showcase clean, modular design and professional coding practices.

## ✨ Features

- Grid‑based tactical combat
- Distinct character classes (ninja, gladiator, mage, ranger, etc.)
- Action Point (AP) economy for movement, attacks, and heals
- Animated sprites and FX powered by [`anim8`](https://github.com/kikito/anim8)
- Modular architecture for easy extension

## 🛠️ Refactor Journey

The original prototype lived in a single `inGame.lua` file with global tables and hard‑coded logic.  
The **remastered version** introduces:

- **Modular design**: `/core`, `/states`, `/config` folders
- **Encapsulated entities**: `Character`, `GameState`, `Combat`, `Map`
- **Data‑driven configs**: Add new classes, FX, or tilesets without touching core logic
- **Registries**: Centralized asset management (`AnimationRegistry`, `TilesetRegistry`, `UIRegistry`)
- **Documentation**: Includes a [Devlog](devlog.md) chronicling the rebuild process

This repo is both a **playable prototype** and a **portfolio piece** demonstrating my growth as a developer.

## 🎮 Gameplay

- **Pass & Play**: Two players alternate turns on the same machine
- **Action Points**: Spend AP to move, attack, or heal
- **Victory Condition**: Eliminate all opposing units
- **Combat Resolution**: Hit, miss, dodge, and KO mechanics

## 🚀 Getting Started

### Prerequisites

- [LÖVE2D](https://love2d.org/) (11.3+ recommended)

### Run the Game

```bash
love .
```

## 🗺️ Repo Structure

```
/assets        → Sprites, tilesets, UI
/core          → Game logic (character, combat, map, gameState, registries)
/config        → Data‑driven definitions (characters, fx, tilesets, ui)
/states        → Game states (menu, game)
/lib           → Third‑party libraries (anim8, timer)
devlog.md      → Development log of the refactor
```

## ☄️ Skills Demonstrated

- Lua scripting & LÖVE2D framework
- Modular architecture & state management
- Animation systems (`anim8`)
- Data‑driven design
- Documentation & developer storytelling

## 🛸 License

This project is licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

## 👽 Contact

Curious about my projects? Want to collaborate or hire for entry-level IT/support/dev roles? Shoot me an email or connect on GitHub—I reply quickly and love new challenges.

[![Portfolio](https://img.shields.io/badge/Portfolio-bd93f9?style=for-the-badge&logo=githubpages&logoColor=white&labelColor=6272a4)](https://theonliestmattastic.github.io/)  
[![GitHub](https://img.shields.io/badge/GitHub-Profile-bd93f9?style=for-the-badge&logo=github&logoColor=white&labelColor=6272a4)](https://github.com/theonliestmattastic)  
[![Email](https://img.shields.io/badge/Email-matthew.poole485%40gmail.com-bd93f9?style=for-the-badge&logo=gmail&logoColor=white&labelColor=6272a4)](mailto:matthew.poole485@gmail.com)

> “Sometimes the questions are complicated and the answers are simple.” — Dr. Seuss
