# lex-agentic-integration

**Parent**: `../CLAUDE.md`

## What Is This Gem?

Domain consolidation gem for global integration theories and cross-domain synthesis. Bundles 17 source extensions into one loadable unit under `Legion::Extensions::Agentic::Integration`.

**Gem**: `lex-agentic-integration`
**Version**: 0.1.6
**Namespace**: `Legion::Extensions::Agentic::Integration`

## Sub-Modules

| Sub-Module | Source Gem | Purpose |
|---|---|---|
| `Integration::Integration` | `lex-cognitive-integration` | Cross-domain integration of cognitive signals |
| `Integration::Synthesis` | `lex-cognitive-synthesis` | Active synthesis of disparate cognitive streams |
| `Integration::Tapestry` | `lex-cognitive-tapestry` | Weaving threads and tapestries — thread lifecycle, loom engine |
| `Integration::Mosaic` | `lex-cognitive-mosaic` | Mosaic pattern assembly from fragments |
| `Integration::Tessellation` | `lex-cognitive-tessellation` | Tessellating cognitive patterns without gaps |
| `Integration::Mycelium` | `lex-cognitive-mycelium` | Fungal network knowledge propagation |
| `Integration::Zeitgeist` | `lex-cognitive-zeitgeist` | Emergent cultural/contextual cognitive patterns |
| `Integration::Map` | `lex-cognitive-map` | Spatial cognitive map — location graph, Dijkstra pathfinding |
| `Integration::Labyrinth` | `lex-cognitive-labyrinth` | Maze-like navigation of complex conceptual spaces |
| `Integration::GlobalWorkspace` | `lex-global-workspace` | Baars/Dehaene GWT — capacity-1 workspace, broadcast to all processors |
| `Integration::PhenomenalBinding` | `lex-phenomenal-binding` | Binding of phenomenal consciousness elements |
| `Integration::Gestalt` | `lex-gestalt` | Holistic pattern perception — the whole exceeds the parts |
| `Integration::DistributedCognition` | `lex-distributed-cognition` | Hutchins — cognition spread across agent, tools, environment |
| `Integration::Qualia` | `lex-qualia` | Subjective experience representation |
| `Integration::Context` | `lex-context` | Context-dependent cognition |
| `Integration::SituationModel` | `lex-situation-model` | Zwaan/Radvansky situation model for text comprehension |
| `Integration::Boundary` | `lex-cognitive-boundary` | Cognitive domain boundary management |

## Actors

| Actor | Interval | Target Method |
|-------|----------|---------------|
| `GlobalWorkspace::Actors::Competition` | interval | `run_competition` on `GlobalWorkspace::Runners::GlobalWorkspace` |
| `Integration::Actor::Decay` | Every 120s | `decay` on `Integration::Runners::CognitiveIntegration` |
| `Labyrinth::Actors::ThreadWalker` | interval | `walk_thread` on `Labyrinth::Runners::CognitiveLabyrinth` |
| `Map::Actors::Decay` | interval | `decay_nodes` on `Map::Runners::CognitiveMap` |
| `PhenomenalBinding::Actor::Decay` | Every 120s | `decay_all` on `PhenomenalBinding::Runners::PhenomenalBinding` |
| `Synthesis::Actor::Decay` | Every 300s | `decay_streams` on `Synthesis::Runners::CognitiveSynthesis` |

## Key Implementation Notes

- `Integration::Tapestry::Helpers::LoomEngine` uses `Helpers::Thread` (not `Tapestry::Helpers::Thread`) to reference the `Thread` value-object class. This avoids constant lookup shadowing since `Tapestry` resolves to `Helpers::Tapestry` within the `Helpers` namespace.
- `Labyrinth::Actors::ThreadWalker` was fixed in the audit remediation — it no longer calls a non-existent method and correctly delegates to `walk_thread`.

## Dependencies

**Runtime** (from gemspec):
- `legion-cache` >= 1.3.11
- `legion-crypt` >= 1.4.9
- `legion-data` >= 1.4.17
- `legion-json` >= 1.2.1
- `legion-logging` >= 1.3.2
- `legion-settings` >= 1.3.14
- `legion-transport` >= 1.3.9

## Development

```bash
bundle install
bundle exec rspec        # 1446 examples, 0 failures
bundle exec rubocop      # 0 offenses
```
