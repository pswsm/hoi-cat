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

HoI4 scripted effects take no parameters, so change it with:

```
add_to_variable = { global.hcat_autonomy = <n> tooltip = hcat_autonomy_change_tt }
hcat_clamp_autonomy = yes
```

When a path is locked in, set `hcat_outcome_<integration|status_quo|independence>` as a global
flag, then call `hcat_settle_catalan_question = yes`.

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
Spain works to reduce autonomy and fold Catalonia into the state. Only with La Résistance:
the branch is a set of shared focuses (`common/national_focus/hcat_spain_shared.txt`) hooked
into `spanish_focus`, to the right of the vanilla tree (x 66–71).

```
                 The Catalan Question
               /                      \
  The Generalitat and the Republic    Against Separatism (Nationalists)
       /                \                    |
 Honour the Statute   Recentralise      Abolish the Statute (-30)
   (+10)                (-15)                 |
       |                  |               One Spain (-20)
 Partners in the      Restore Public Order (-15)
 War Effort (+5)          \               /
                        Integrate Catalonia
```

- The Republican path forks: honouring the Statute (no integration) or recentralising after
  the May Days, as in 1937.
- The Nationalists only get Catalonia as a subject by winning the civil war: in
  `on_civil_war_end_before_annexation` the winner takes Catalonia over from the loser.
- **Integrate Catalonia** needs autonomy ≤ 25. It annexes `CAT` and starts *Catalan
  Discontent*: `global.hcat_discontent` = 30 + 2 × remaining autonomy (30–80), fading by 1 a
  month. At 80 it gives −8% stability to the owner and −32% factory output and recruitable
  population in state 165. `CAT` keeps its core, so the question can return.

### Catalan side

```
                   The Catalan Question (+5)
                  /                          \
  Road to Independence (+10)            Within Spain: floor 30
               |                              |
  Mobilise Civil Society (+10)          The Statute Defended: floor 40
               |                              |
  Proclaim the Catalan State (≥ 80)     Industry of the Republic
     /         |          \
 Mediterranean  Crown of   Home of        (Anarchy: TODO)
 Democracy      Aragó      Anarchy
```

#### Mediterranean Democracy

```
                     A Mediterranean Democracy (+A Fragile Republic)
              /                    |                        \
 Parliament of Catalonia   Port of Barcelona        Seek International Recognition
              |                    |                        |
 The Rabassaires Law       Factory of the Med.      The Army of Catalonia
              |                    |                        |
 A Republic of Citizens    Mediterranean Trade      Hold the Ebro and the Pyrenees
              \                    |                   /              \
               \                   |         Entente with France  |  Mediterranean Accord
                \                  |                   \              /
                     The Beacon of the Mediterranean
```

- The root makes Catalonia democratic if it is not and adds *A Fragile Republic*
  (−15% PP, −10% stability, −10% construction). The politics column upgrades it to
  *A Republic Finds Its Feet*, then *A Republic of Citizens* (+5% stability, +10% PP).
- Economy: naval base +2 and a dockyard in Barcelona, two civilian factories, and the
  *Mediterranean Trade Routes* spirit.
- Foreign policy and defence: an opinion bonus with democratic majors, the *A Citizen Army*
  spirit, then level 2 border bunkers and coastal bunkers in every core state.
- Allies, mutually exclusive: *Entente with France* joins France's faction (or gets a French
  guarantee if France has none); *The Mediterranean Accord* founds a defensive democratic
  faction from `faction_template_defensive_democratic`.
- The capstone needs all three columns and gives a research slot.

#### Restore the Crown of Aragó

```
                  Restore the Crown of Aragó (+A Disputed Crown)
                                   |
                  The Count of Barcelona (35 days: the contest for the Crown)
              /                    |                       \
 The Corts Generals        The Lands of the Crown       The Almogàvers
              |                    |                       |
 The Usatges of Barcelona  Reclaim Aragon               The Consulate of the Sea
              |                    |                       |
              |            Reclaim Valencia and Isles   Northern Catalonia
              |                    |                       |
              |            The Crown United             The Mediterranean Kingdoms
               \                   |                      /
                       The Crown of Aragon Reborn
```

- The contest for the Crown: *The Count of Barcelona* is the only way into the branch and
  takes 35 days. Its `select_effect` (`hcat_start_the_crown_contest`) sets base support in
  four country variables, `hcat_claim_<house>` (Bourbon 4, Barcelona 4, Habsburg 2,
  Urgell 2), and queues five events (`events/hcat_crown.txt`, days 3, 10, 17, 24, 31).
  Each event's options add support to one or more houses, and the last one lets you spend
  25 PP to add 3 to one house. Their descriptions show the current standings. An event
  only fires while the focus is still in progress, and only once per contest, so
  cancelling the focus stops it. On completion `hcat_crown_the_leading_claimant` crowns the
  leader (ties go to Barcelona, Bourbon, Habsburg, then Urgell) and announces it with
  `hcat_catalonia.4`, *The Corts Have Chosen*.
- Every winner makes the government non-aligned without elections and takes vanilla's
  `CAT_aragon` cosmetic tag ("Crown of Aragon", with its own non-aligned flag), then
  crowns a claimant (`common/characters/hcat_CAT.txt`, effects in
  `hcat_crown_house_of_<house>`) with a permanent dynasty spirit:

  | House | Claimant | Spirit | Other effects |
  |---|---|---|---|
  | House of Bourbon | Juan de Borbón | +10% PP, −5% stability | +40 opinion with Spain, both ways |
  | Refound the House of Barcelona | Ramon Berenguer (fictional) | +10% stability, +5% war support, −10% PP | +5% stability |
  | Austrian candidate | Otto von Habsburg | +5% PP, +5% army org, −5% stability | +40 opinion from Austria and Hungary, −25 from Germany |
  | House of Urgell (Caspe, 1412) | Jaume d'Urgell (fictional) | +10% war support, −15% wargoal time, −5% stability | +5% war support |

  Each also sets a `hcat_dynasty_<house>` country flag for later content.

  *A Disputed Crown* becomes *The Corts of the Crown*, and the capstone turns that into *The Crown of Aragon Reborn*.
  *The Usatges* spirit cuts the time to justify wargoals.
- The lands of the Crown: claims on 166, 794, 167 and 177. Each Reclaim focus creates a
  `take_state_focus` wargoal against whoever controls the states, and is bypassed if
  Catalonia already owns them. *The Crown United* needs all five states and cores them.
- The sea: an army spirit, then dockyards and a trade/dockyard spirit, then a claim and
  wargoal on Roussillon (22, France), then claims on Sardinia (114), Sicily (115) and
  Naples (117), with a wargoal on Sardinia.
- The capstone also cores the overseas states Catalonia fully controls.

**Raising autonomy**: focuses; two repeatable decisions in "The Catalan Question"
(Negotiate Competences, 50 PP, +5 every 90 days; Mobilise Civil Society, 75 PP, +8 every
120 days, unlocked by its focus); and Spanish weakness, +2 a month while Spain is in a civil
war and +1 while its stability is below 30% (`on_monthly_CAT`).

**Breakaway**: Proclaim the Catalan State needs autonomy ≥ 80 and fires `hcat_spain.1` to
Spain. It also raises the Catalan forces in Barcelona
(`hcat_raise_the_catalan_forces`, OOB `history/units/hcat_CAT_catalan_forces.txt`): three *Milícies Catalanes* militia divisions, two
*Mossos d'Esquadra* infantry divisions with military police, and the *Regiment Pirinenc
núm. 1* mountaineer division. *Let Catalonia go* frees it peacefully and settles the question as independence.
*Crush the separatists* frees it and Spain declares an annexation war
(`hcat_war_of_catalan_independence`). The AI mostly refuses unless it is in a civil war or
below 30% stability. The three ideological focuses need Catalonia to be independent.

**Status quo**: Within Spain and The Statute Defended set an autonomy floor
(`global.hcat_autonomy_floor`, enforced by `hcat_clamp_autonomy`) of 30, then 40. Spain's
integration needs autonomy ≤ 25, so it must first break the pact: Recentralise the Republic
and Abolish the Statute call `hcat_break_the_statute_pact`, which clears the floor, costs
Catalonia stability and fires `hcat_catalonia.3`.

## Conventions

- Mod-owned scripted effects, triggers, variables, flags, decisions and loc keys use the `hcat_` prefix.
- Focus IDs use the `CAT_` / `SPR_` tag prefix, as vanilla does.
- Vanilla files are never overwritten; content goes in new `hcat_*` files.
- Localisation ships in English and Spanish (HoI4 has no Catalan language slot).
  Files must be UTF-8 with BOM.
- Script files under `common/` and `events/` must have **no** BOM: a BOM breaks the scripted
  effects file and every `hcat_` effect then reads as unknown. Keep them ASCII outside
  comments. Accented unit and template names go in `history/units/` OOB files (UTF-8 with
  BOM, like vanilla) loaded with `load_oob`.

## Vanilla overrides

These replace vanilla files of the same name. Re-check them whenever HoI4 updates.

| File | Change |
|------|--------|
| `history/states/165-Catalonia.txt` | owner `CAT` in 1936, `SPR` from 1939 |
| `history/countries/CAT - Catalonia.txt` | `SPR` makes `CAT` an Autonomous Community (pre-1938 starts) |
| `common/national_focus/spain.txt` | one `shared_focus = SPR_hcat_the_catalan_question` line in `spanish_focus` |

## In-game test checklist

- 1936 start: Catalonia shows as "Generalitat de Catalunya", a subject of Spain, and is selectable.
- The two Spanish divisions and the fleet based in Barcelona (province 9764) load without errors.
- The Civil War, with and without La Résistance, starting as either side: Catalonia ends up
  on the Republican side and at war with the Nationalists.
- Catalan side: the decisions raise autonomy and go on cooldown, the monthly drift applies
  during the Civil War, Proclaim the Catalan State fires Spain's event, and both answers
  free Catalonia (the refusal at war). The status quo floor holds until Spain recentralises.
- 1939 start: no Catalonia, state 165 is Spanish.
- Spanish branch (LaR): it appears right of the vanilla tree without overlapping, the
  Republican and Nationalist halves unlock for the right side, and Integrate Catalonia annexes
  Catalonia and applies Catalan Discontent, which fades monthly.
- A Nationalist victory leaves Catalonia as a Nationalist subject, not independent.
- `error.log` has no entries mentioning `hcat_` or `CAT`.

## Vanilla reference

- Catalonia state: `165` (cored by `CAT` and `SPR`).
- Old Crown of Aragon states: `165` Catalonia, `166` Western Aragon, `794` Eastern Aragon,
  `167` Valencia, `177` Balearic Islands.
