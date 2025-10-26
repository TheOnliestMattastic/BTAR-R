# ⚔️ Battle Tactics Arena (Remastered)

[![License: CC BY-SA 4.0](https://licensebuttons.net/l/by-sa/4.0/88x31.png)](https://creativecommons.org/licenses/by-sa/4.0/)
![Language](https://img.shields.io/badge/Lua-LÖVE2D-green)
![Status](https://img.shields.io/badge/Status-WIP-yellow)

## 📖 Overview
**Battle Tactics Arena (BTA)** is a **2D turn‑based tactical RPG prototype** built with **Lua** and the **LÖVE2D framework**.  

Originally created as a class project, the game has been **rebuilt from the ground up** to showcase clean, modular design and professional coding practices.

Features:
- Grid‑based tactical combat
- Distinct character classes (ninja, gladiator, mage, ranger, etc.)
- Action Point (AP) economy for movement, attacks, and heals
- Animated sprites and FX powered by [`anim8`](https://github.com/kikito/anim8)
- Modular architecture for easy extension

---

## 🛠️ Refactor Journey
The original prototype lived in a single `inGame.lua` file with global tables and hard‑coded logic.  
The **remastered version** introduces:
- **Modular design**: `/core`, `/states`, `/config` folders
- **Encapsulated entities**: `Character`, `GameState`, `Combat`, `Map`
- **Data‑driven configs**: Add new classes, FX, or tilesets without touching core logic
- **Registries**: Centralized asset management (`AnimationRegistry`, `TilesetRegistry`, `UIRegistry`)
- **Documentation**: Includes a [Devlog](devlog.md) chronicling the rebuild process

This repo is both a **playable prototype** and a **portfolio piece** demonstrating my growth as a developer.

---

## 🎮 Gameplay
- **Pass & Play**: Two players alternate turns on the same machine
- **Action Points**: Spend AP to move, attack, or heal
- **Victory Condition**: Eliminate all opposing units
- **Combat Resolution**: Hit, miss, dodge, and KO mechanics

---

## 🚀 Getting Started

### Prerequisites
- [LÖVE2D](https://love2d.org/) (11.3+ recommended)

### Run the Game
```bash
love .
```

---

## 📂 Project Structure
```
/assets        → Sprites, tilesets, UI
/core          → Game logic (character, combat, map, gameState, registries)
/config        → Data‑driven definitions (characters, fx, tilesets, ui)
/states        → Game states (menu, game)
/lib           → Third‑party libraries (anim8, timer)
devlog.md      → Development log of the refactor
```

---

## 🧑‍💻 Skills Demonstrated
- Lua scripting & LÖVE2D framework
- Modular architecture & state management
- Animation systems (`anim8`)
- Data‑driven design
- Documentation & developer storytelling

---

## 📜 License


---

## 👤 Author
I’m **Matthew** — a CompTIA A+ certified technologist, indie game developer, and open‑source contributor.  
I build tools, games, and automation that make tech more accessible, reliable, and fun.

- [Portfolio](https://theonliestmattastic.github.io/)
- [GitHub](https://github.com/TheOnliestMattastic)
