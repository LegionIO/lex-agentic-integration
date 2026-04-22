# Changelog

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
