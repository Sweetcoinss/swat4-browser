# SWAT 4 — Extracted Source & Assets

Extracted from the portable installation located at:
`C:\Users\RDP.runnervmbpeip\Downloads\SWAT 4 Portable\Content`

Game: SWAT 4 (Irrational Games, 2005) — Unreal Engine 2.5 (file version 129).
Packages: 35 `.u` files (UnrealScript bytecode) + config/data files.

## Folder layout

- `source/` — decompiled UnrealScript source, one subfolder per package, one `.uc` file per class.
  - 2848 classes total, 0 decompilation failures.
  - `source/<Package>/<ClassName>.uc`
  - Each file contains class declaration, enums, vars, delegates, functions with bodies, states, defaultproperties where present.
- `analysis/` — machine-readable package metadata.
  - `packages_summary.json` — per-package counts (names, imports, exports, classes, functions, states, properties, enums, structs, consts).
  - `packages/<Package>.json` — full class list with inheritance, function/property/state names per class.
  - `classes.txt` — `package\tclass\tsuper=...` for every class.
  - `functions.txt` — `package\tClass.Function` for every function (10237 total).
- `text_assets/` — 116 text/config files copied verbatim (`.ini`, `.int`, `.txt`, `.pak` catalogs, etc.), preserving folder structure.

## Decompilation method

Unreal Engine 2.5 stores script as bytecode inside `.u` packages. The decompiler used is
Eliot VU's UELib (https://github.com/EliotVU/Unreal-Library) with the SWAT4 build profile,
driven by a small wrapper (`DecompileAll.exe`) that initializes each package and writes one
`.uc` file per `UClass`.

A second pass resolved every `__NFUN_<n>__` placeholder to its real native function name by
scanning all packages for `UFunction` exports with `FUNC_Native` and matching their `iNative`
index (0 collisions across 219 declarations, covering all 174 distinct native tokens). A final
pass removed UELib debug markers (`BadToken`, `End:0x...`) and normalized whitespace.

Result: no `__NFUN__` placeholders, no debug markers remain. Control flow is rendered with
structured `if`/`for`/`while`/`switch` where UELib could recover it (1740 `goto` statements
remain for complex branches).

## Counts

| Item | Count |
|---|---|
| Packages (.u) | 35 |
| Classes | 2848 |
| Functions | 10237 |
| Text assets | 116 |
| Total source bytes | ~5.4 MB |

## Largest packages by class count

| Package | Classes |
|---|---|
| SwatDesignerClasses | 758 |
| SwatGame | 320 |
| SwatAICommon | 312 |
| Engine | 290 |
| SwatEffects | 269 |
| SwatSimpleEquipment | 97 |
| SwatEquipmentModels | 85 |
| UWindow | 78 |
| SwatEquipment | 74 |
| SwatGui | 72 |

## Notes

- `SwatDesignerClasses` contains mostly designer-authored level/equipment subclasses.
- Some `.u` files are editor-only (`SwatEd`, `Editor`).
- Native calls appear as `__NFUN_<id>__(...)`; the original C++ native implementation is not
  part of these packages (it lives in the engine DLLs).
- Default properties blocks are included where UELib recovered them.
