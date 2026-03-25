# lex-agentic-integration

**Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`

## What Is This Gem?

Domain consolidation gem for global integration theories and cross-domain synthesis. Bundles 17 source extensions into one loadable unit under `Legion::Extensions::Agentic::Integration`.

**Gem**: `lex-agentic-integration`
**Version**: 0.1.0
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

- `Integration::GlobalWorkspace::Actors::Competition` — interval actor, runs workspace competition cycle
- `Integration::Labyrinth::Actors::ThreadWalker` — interval actor, advances labyrinth thread walker
- `Integration::Map::Actors::Decay` — interval actor, decays cognitive map node strength

## Key Implementation Note

`Integration::Tapestry::Helpers::LoomEngine` uses `Helpers::Thread` (not `Tapestry::Helpers::Thread`) to reference the `Thread` value-object class. This avoids constant lookup shadowing since `Tapestry` resolves to the `Helpers::Tapestry` class within the `Helpers` namespace.

## Development

```bash
bundle install
bundle exec rspec        # 1446 examples, 0 failures
bundle exec rubocop      # 0 offenses
```
