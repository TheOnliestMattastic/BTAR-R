# Devlog – Rebuilding Battle Tactics Arena

## October 20, 2025

### What I Started With
This project began as my final class project a few years ago: a tactical RPG prototype built in LÖVE (Lua). The original code worked, but it was very **monolithic**:
- A single `inGame.lua` file handled map rendering, character logic, UI, and input all at once.
- Game state was tracked in a global `game` table with cryptic indices (`game[1]`, `game[2]`, etc.).
- Characters were stored in a giant `char` table with mixed data and flags.
- Adding new classes, attacks, or maps required editing multiple places in the same file.

It was a great learning experience, but not something I’d want to showcase.

---

### What I’ve Done So Far
I’ve started **rebuilding the game from the ground up** with best practices in mind:

1. **Modular Design**
   - Created a `Character` module (`character.lua`) that encapsulates stats, position, sprite, and methods like `update`, `draw`, `takeDamage`, and `heal`.
   - This replaces the old global `char` table with clean, object‑like entities.

2. **GameState Manager**
   - Built a `GameState` module (`gameState.lua`) to handle turns, action points, and win conditions.
   - This centralizes logic that was previously scattered across `inGame.lua`.

3. **Clearer Project Structure**
   - Planning a `/core` folder for reusable modules (`character.lua`, `map.lua`, `gameState.lua`, `ui.lua`).
   - States (`menu.lua`, `game.lua`) will live in `/states`.
   - Assets (sprites, fonts) are separated into `/assets`.

---

### Why This Matters
- **Readability**: Others can immediately see clean, modular code instead of one giant file.
- **Scalability**: Adding new classes, maps, or abilities will be data‑driven, not hard‑coded.
- **Professionalism**: The repo will include a polished `README.md` and this `devlog.md` to show my growth and thought process.

---

### Next Steps
- Extract map logic into a `Map` module.
- Build a reusable `UI` module for buttons and HUD elements.
- Refactor input handling into a state machine (`idle → selecting → moving → attacking`).
- Document the rebuild process with screenshots and GIFs for the GitHub README.