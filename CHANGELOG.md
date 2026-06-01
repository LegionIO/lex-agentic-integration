# Changelog

## [0.1.7] - 2026-06-01
### Fixed
- Nil dereference in `PhenomenalBinding::Runners::PhenomenalBinding#register_stream` — guard against `nil` return from `engine.register_stream` when stream_type is invalid; returns `{ status: :rejected, reason: :unknown_stream_type }` instead of crashing on `.salience`
- `Tapestry::Helpers::Tapestry#age!` and `#repair!` were no-op stubs that accepted params but did nothing — now `age!` frays thread strength via a `@decay_factor` (returned as a float) and `repair!` boosts it; `to_h` includes `decay_factor`
- `Tapestry::Helpers::Thread` class renamed to `ThreadStrand` to avoid shadowing Ruby's built-in `Thread` constant; all internal references updated
- Removed `extend self` from `Tapestry::Runners::CognitiveTapestry`, `Labyrinth::Runners::CognitiveLabyrinth`, `Mosaic::Runners::CognitiveMosaic`, and `Mycelium::Runners::CognitiveMycelium` — standardized to instance-module pattern (`include Lex` + private `engine`/`resolve_engine`) matching all other sub-module runners
- Standardized `include Legion::Extensions::Helpers::Lex` guard to use `const_defined?` double-check (matches project-wide pattern) in mosaic and mycelium runners
- Updated corresponding runner specs to use `runner_host = Object.new.tap { |o| o.extend(described_class) }` pattern instead of module-level calls

## [0.1.6] - 2026-04-22
### Fixed
- ThreadWalker actor now calls `follow_thread` (navigation) instead of `list_labyrinths` (read-only query)
- Added error logging to labyrinth runner rescue blocks
### Added
- 3 new decay actors: PhenomenalBinding::Decay (120s), CognitiveIntegration::Decay (120s), CognitiveSynthesis::Decay (300s)

## [0.1.5] - 2026-04-15
### Changed
- Set `mcp_tools?` and `mcp_tools_deferred?` to `false` — internal cognitive pipeline extension, not an LLM-callable tool

## [0.1.4] - 2026-03-30

### Changed
- update to rubocop-legion 0.1.7, resolve all offenses

## [0.1.3] - 2026-03-26

### Changed
- fix remote_invocable? to use class method for local dispatch

## [0.1.2] - 2026-03-22

### Changed
- Add 7 runtime sub-gem dependencies to gemspec (legion-cache, legion-crypt, legion-data, legion-json, legion-logging, legion-settings, legion-transport)
- Update spec_helper to use real sub-gem helpers (legion/logging, legion/settings, legion/cache/helper, legion/crypt/helper, legion/data/helper, legion/json/helper, legion/transport/helper) and properly compose Helpers::Lex with all helper modules

## [0.1.1] - 2026-03-18

### Changed
- Enforce STREAM_TYPES validation in PhenomenalBinding::BindingEngine#register_stream (returns nil for invalid types)
- Enforce BINDING_TYPES validation in PhenomenalBinding::BindingEngine#create_binding (returns nil for invalid types)

## [0.1.0] - 2026-03-18

### Added
- Initial release as domain consolidation gem
- Consolidated source extensions into unified domain gem under `Legion::Extensions::Agentic::<Domain>`
- All sub-modules loaded from single entry point
- Full spec suite with zero failures
- RuboCop compliance across all files
