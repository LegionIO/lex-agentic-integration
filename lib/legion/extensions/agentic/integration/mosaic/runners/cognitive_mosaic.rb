# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Integration
        module Mosaic
          module Runners
            module CognitiveMosaic
              include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                          Legion::Extensions::Helpers.const_defined?(:Lex, false)

              def create_tessera(material:, domain:, content:,
                                 color: nil, fit_quality: nil, engine: nil, **)
                eng = resolve_engine(engine)
                t   = eng.create_tessera(material: material, domain: domain,
                                         content: content, color: color,
                                         fit_quality: fit_quality)
                log.debug("[cognitive_mosaic] create_tessera: material=#{material} domain=#{domain}")
                { success: true, tessera: t.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def create_mosaic(name:, pattern_category:, capacity: 50,
                                grout_strength: nil, engine: nil, **)
                eng = resolve_engine(engine)
                m   = eng.create_mosaic(name: name, pattern_category: pattern_category,
                                        capacity: capacity, grout_strength: grout_strength)
                log.debug("[cognitive_mosaic] create_mosaic: name=#{name} pattern=#{pattern_category}")
                { success: true, mosaic: m.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def place_tessera(tessera_id:, mosaic_id:, engine: nil, **)
                eng = resolve_engine(engine)
                eng.place_tessera(tessera_id: tessera_id, mosaic_id: mosaic_id)
                log.debug("[cognitive_mosaic] place_tessera: tessera=#{tessera_id[0..7]} mosaic=#{mosaic_id[0..7]}")
                { success: true }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def list_tesserae(engine: nil, material: nil, **)
                eng     = resolve_engine(engine)
                results = eng.all_tesserae
                results = results.select { |t| t.material == material.to_sym } if material
                log.debug("[cognitive_mosaic] list_tesserae: count=#{results.size}")
                { success: true, tesserae: results.map(&:to_h), count: results.size }
              end

              def list_mosaics(engine: nil, **)
                eng = resolve_engine(engine)
                mosaics = eng.all_mosaics
                log.debug("[cognitive_mosaic] list_mosaics: count=#{mosaics.size}")
                { success: true, mosaics: mosaics.map(&:to_h),
                  count: mosaics.size }
              end

              def mosaic_status(engine: nil, **)
                eng = resolve_engine(engine)
                log.debug('[cognitive_mosaic] mosaic_status')
                { success: true, report: eng.mosaic_report }
              end

              private

              def resolve_engine(engine)
                engine || default_engine
              end

              def default_engine
                @default_engine ||= Helpers::MosaicEngine.new
              end
            end
          end
        end
      end
    end
  end
end
