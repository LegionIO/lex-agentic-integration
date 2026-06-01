# lex-agentic-integration

Domain consolidation gem for global integration theories and cross-domain synthesis. Bundles 17 source extensions into one loadable unit under `Legion::Extensions::Agentic::Integration`.

## Key Sub-Modules

| Sub-Module | Purpose |
|---|---|
| `Integration::Tapestry` | Weaving threads and tapestries — thread lifecycle, loom engine |
| `Integration::GlobalWorkspace` | Baars/Dehaene GWT — capacity-1 workspace, broadcast to all processors |
| `Integration::Gestalt` | Holistic pattern perception — the whole exceeds the parts |
| `Integration::DistributedCognition` | Hutchins — cognition spread across agent, tools, environment |
| `Integration::Map` | Spatial cognitive map — location graph, Dijkstra pathfinding |
| `Integration::SituationModel` | Zwaan/Radvansky situation model for text comprehension |

## Key Implementation Notes

- `Integration::Tapestry::Helpers::LoomEngine` uses `Helpers::Thread` (not `Tapestry::Helpers::Thread`) to reference the `Thread` value-object class. This avoids constant lookup shadowing since `Tapestry` resolves to `Helpers::Tapestry` within the `Helpers` namespace.
- `Labyrinth::Actors::ThreadWalker` was fixed in the audit remediation — it no longer calls a non-existent method and correctly delegates to `walk_thread`.
