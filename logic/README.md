# SWAT 4 — Game Logic Extraction

Extracted from the decompiled UnrealScript source (`SWAT 4 Source Extracted/source/`).

## Contents

### `game_logic.json` (2.6 MB)
Structured JSON of all 2760 classes with:
- Class name, parent, implements, native/config flags
- Variables (modifiers, type, name)
- Functions (kind, signature, has_body)
- States, enums, delegates

### `summary.json`
Per-package counts (classes, functions, variables, states, enums).

### `js_skeletons/` (977 files)
JavaScript class skeletons mirroring the UnrealScript class hierarchy:
- `SwatGame/` — 281 classes (SwatGameInfo, SwatPlayer, SwatPlayerController, etc.)
- `Engine/` — 260 classes (Actor, Pawn, Controller, etc.)
- `SwatAICommon/` — 300 classes (AI, officers, suspects)
- `Tyrion/` — 66 classes (AI framework)
- `SwatObjectives/` — 18 classes (mission objectives)
- `SwatProcedures/` — 20 classes (scoring procedures)
- `Gameplay/` — 23 classes (triggers, actions, messages)
- `Core/` — 9 classes (Object, Actor base)

Each .js file contains:
- Class declaration extending parent
- Variable declarations with JS types
- Method signatures with TODO markers
- Constructor stub

## Key Game Systems

### Mission Flow
1. `SwatGameInfo` (GameInfo subclass) manages mission lifecycle
2. `SwatGamePlayerController` handles player input and commands
3. `SwatPlayer` / `SwatPawn` represents the player character
4. `SwatOfficer` represents SWAT team members (AI)
5. `SwatEnemy` / `SwatSuspect` represents hostiles

### Objectives System (`SwatObjectives/`)
- `Do_*` classes: arrest/neutralize/rescue objectives
- `DoNot_*` classes: failure conditions (officer died, hostage died, etc.)
- Each objective has completion/failure logic

### Scoring (`SwatProcedures/`)
- `Procedure_*` classes define scoring rules
- Score based on arrests, neutralizations, casualties, time

### AI (`Tyrion/` + `SwatAICommon/`)
- Behavior trees (Tyrion framework)
- Officer AI (follow commands, clear rooms, arrest suspects)
- Suspect AI (flee, fight, surrender)
- Navigation (pathfinding, door handling)

### Equipment (`SwatEquipment/`)
- Weapons (pistols, rifles, shotguns, less-lethal)
- Tactical aids (flashbangs, CS gas, stinger grenades)
- Armor and protective gear

## Next Steps for Web Reimplementation
1. Set up Three.js scene with SWAT 4 level geometry (exported via umodel)
2. Implement player controller (WASD + mouse look) based on SwatPlayerController
3. Implement basic AI (officer follow commands) based on SwatOfficer/Tyrion
4. Implement objectives tracking based on SwatObjectives
5. Add weapons and interaction based on SwatEquipment

## Source Files
- UnrealScript: `../source/<Package>/<ClassName>.uc`
- Analysis: `../analysis/`
- Models: `../models/` (glTF exports)
