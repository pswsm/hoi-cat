# HoI IV - Catalunya

A Hearts of Iron IV mod that adds depth to the relationship between Catalonia and Spain.

Targets HoI4 1.19.x. See [docs/DESIGN.md](docs/DESIGN.md) for the design outline.

## Layout

```
descriptor.mod                 mod metadata
common/autonomous_states/      Autonomous Community subject level
common/national_focus/         Catalan focus tree
common/decisions/              "The Catalan Question" decisions
common/scripted_effects/       autonomy track helpers
common/scripted_triggers/      shared triggers
common/on_actions/             startup initialisation
history/                       vanilla overrides (see docs/DESIGN.md)
localisation/{english,spanish} text (UTF-8 with BOM)
tools/                         dev helpers
```

## Development

```sh
tools/link-dev-mod.sh   # registers this checkout with the launcher
```

Then enable "HoI IV - Catalunya" in a playset. In game, run `debug` in the console to see
the debug decisions that move the autonomy track.
