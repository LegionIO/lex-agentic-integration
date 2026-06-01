# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Mosaic::Runners::CognitiveMosaic do
  let(:engine) { Legion::Extensions::Agentic::Integration::Mosaic::Helpers::MosaicEngine.new }

  let(:runner_host) do
    host = Object.new
    host.extend(described_class)
    host
  end

  describe '#create_tessera' do
    it 'returns success' do
      result = runner_host.create_tessera(
        material: :glass, domain: :reasoning, content: 'test', engine: engine
      )
      expect(result[:success]).to be true
      expect(result[:tessera][:material]).to eq(:glass)
    end

    it 'returns failure for invalid material' do
      result = runner_host.create_tessera(
        material: :plasma, domain: :x, content: 'y', engine: engine
      )
      expect(result[:success]).to be false
    end
  end

  describe '#create_mosaic' do
    it 'returns success' do
      result = runner_host.create_mosaic(
        name: 'test', pattern_category: :geometric, engine: engine
      )
      expect(result[:success]).to be true
      expect(result[:mosaic][:name]).to eq('test')
    end

    it 'returns failure for invalid pattern' do
      result = runner_host.create_mosaic(
        name: 'x', pattern_category: :random, engine: engine
      )
      expect(result[:success]).to be false
    end
  end

  describe '#place_tessera' do
    it 'places tessera successfully' do
      t = engine.create_tessera(material: :stone, domain: :x, content: 'a')
      m = engine.create_mosaic(name: 'wall', pattern_category: :organic)
      result = runner_host.place_tessera(
        tessera_id: t.id, mosaic_id: m.id, engine: engine
      )
      expect(result[:success]).to be true
    end

    it 'returns failure for missing tessera' do
      result = runner_host.place_tessera(
        tessera_id: 'nope', mosaic_id: 'nope', engine: engine
      )
      expect(result[:success]).to be false
    end
  end

  describe '#list_tesserae' do
    it 'returns all tesserae' do
      engine.create_tessera(material: :glass, domain: :x, content: 'a')
      result = runner_host.list_tesserae(engine: engine)
      expect(result[:count]).to eq(1)
    end

    it 'filters by material' do
      engine.create_tessera(material: :glass, domain: :x, content: 'a')
      engine.create_tessera(material: :stone, domain: :x, content: 'b')
      result = runner_host.list_tesserae(engine: engine, material: :glass)
      expect(result[:count]).to eq(1)
    end
  end

  describe '#list_mosaics' do
    it 'returns all mosaics' do
      engine.create_mosaic(name: 'a', pattern_category: :geometric)
      result = runner_host.list_mosaics(engine: engine)
      expect(result[:count]).to eq(1)
    end
  end

  describe '#mosaic_status' do
    it 'returns report' do
      result = runner_host.mosaic_status(engine: engine)
      expect(result[:success]).to be true
      expect(result[:report]).to have_key(:total_tesserae)
    end
  end
end
