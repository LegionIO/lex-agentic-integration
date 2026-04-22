# lex-agentic-integration

Domain consolidation gem for global integration theories and cross-domain synthesis. Bundles 17 source extensions into one loadable unit under `Legion::Extensions::Agentic::Integration`.

## Overview

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

| Actor | Interval | What It Does |
|-------|----------|--------------|
| `GlobalWorkspace::Actors::Competition` | interval | Runs workspace competition cycle — selects winner for global broadcast |
| `Integration::Actor::Decay` | Every 120s | Decays stale cross-domain integration representations |
| `Labyrinth::Actors::ThreadWalker` | interval | Advances thread walker through labyrinth |
| `Map::Actors::Decay` | interval | Decays cognitive map node strength |
| `PhenomenalBinding::Actor::Decay` | Every 120s | Decays phenomenal binding units |
| `Synthesis::Actor::Decay` | Every 300s | Decays inactive synthesis streams |

## Installation

```ruby
gem 'lex-agentic-integration'
```

## Development

```bash
bundle install
bundle exec rspec        # 1446 examples, 0 failures
bundle exec rubocop      # 0 offenses
```

## License

MIT
