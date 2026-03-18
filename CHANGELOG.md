# Changelog

## [Unreleased]

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
