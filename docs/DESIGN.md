# Design outline

The mod deepens the relationship between Catalonia (`CAT`) and Spain (`SPR`, including its
civil-war forms) and resolves it along one of several paths.

## Core mechanic: Catalan autonomy

A single global variable, `global.hcat_autonomy` (0–100), tracks where Catalonia stands.

| Value | Meaning |
|------:|---------|
| 0     | Fully integrated into a centralised Spain |
| 50    | 1932 Statute of Autonomy (game start) |
| 100   | De facto independence |

Change it only through `hcat_change_autonomy = { VALUE = <n> }`, which clamps the result.
When a path is locked in, call `hcat_settle_catalan_question = { OUTCOME = <outcome> }`.

## Catalonia as an Autonomous Community

In 1936 Catalonia (`CAT`) is playable as a subject of Spain at a custom level,
`hcat_autonomy_autonomous_community` ("Autonomous Community"), which represents the 1932 Statute.

- It owns state 165, cannot declare war and must join Spain's wars.
- The AI never moves it up or down the native autonomy ladder: mod content does.
- Only `CAT` under a Spanish overlord may hold the level.
- From the 1939 bookmark the state belongs to Spain again and `CAT` does not exist.

**Civil War**: the Generalitat stays loyal to the Republic. HoI4 has no on_action for a civil
war starting, so `on_daily_CAT` runs `hcat_catalonia_follow_the_republic`. If Catalonia's
overlord is the non-Republican side of a Spanish civil war, the subject relationship moves to
the Republican side and Catalonia joins the war against its former overlord.

## Paths

### Spanish side: integration
Spain works to reduce autonomy and fold Catalonia into the state.

### Catalan side
- **Status quo**: Catalonia stays an autonomous part of Spain.
- **Independence**, then one of:
  - **Mediterranean Democracy**: a liberal republic tied to the Western democracies.
  - **Restore the Crown of Aragó**: claim the lands of the old Crown (Aragon, Valencia, Balearics).
  - **Home of Anarchy**: CNT-FAI revolutionary Catalonia.

## Conventions

- Mod-owned scripted effects, triggers, variables, flags, decisions and loc keys use the `hcat_` prefix.
- Focus IDs use the `CAT_` / `SPR_` tag prefix, as vanilla does.
- Vanilla files are never overwritten; content goes in new `hcat_*` files.
- Localisation ships in English and Spanish (HoI4 has no Catalan language slot).
  Files must be UTF-8 with BOM.

## Vanilla overrides

These replace vanilla files of the same name. Re-check them whenever HoI4 updates.

| File | Change |
|------|--------|
| `history/states/165-Catalonia.txt` | owner `CAT` in 1936, `SPR` from 1939 |
| `history/countries/CAT - Catalonia.txt` | `SPR` makes `CAT` an Autonomous Community (pre-1938 starts) |

## In-game test checklist

- 1936 start: Catalonia shows as "Generalitat de Catalunya", a subject of Spain, and is selectable.
- The two Spanish divisions and the fleet based in Barcelona (province 9764) load without errors.
- The Civil War, with and without La Résistance, starting as either side: Catalonia ends up
  on the Republican side and at war with the Nationalists.
- 1939 start: no Catalonia, state 165 is Spanish.
- `error.log` has no entries mentioning `hcat_` or `CAT`.

## Vanilla reference

- Catalonia state: `165` (cored by `CAT` and `SPR`).
- Old Crown of Aragon states: `165` Catalonia, `166` Western Aragon, `794` Eastern Aragon,
  `167` Valencia, `177` Balearic Islands.
