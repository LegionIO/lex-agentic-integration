# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Tapestry::Client do
  subject(:client) { described_class.new }

  let(:engine) { Legion::Extensions::Agentic::Integration::Tapestry::Helpers::LoomEngine.new }

  it 'includes Runners::CognitiveTapestry' do
    expect(client).to respond_to(:spin_thread)
    expect(client).to respond_to(:create_tapestry)
    expect(client).to respond_to(:weave)
    expect(client).to respond_to(:list_tapestries)
    expect(client).to respond_to(:loom_status)
  end

  describe '#spin_thread via client' do
    it 'returns a successful result' do
      result = client.spin_thread(
        thread_type: :memory, domain: :past, content: 'childhood memory', engine: engine
      )
      expect(result[:success]).to be true
    end
  end

  describe '#create_tapestry via client' do
    it 'returns a successful result' do
      result = client.create_tapestry(name: 'autobiography', pattern: :twill, engine: engine)
      expect(result[:success]).to be true
    end
  end

  describe '#weave via client' do
    it 'weaves thread into tapestry' do
      t   = engine.spin_thread(thread_type: :emotion, domain: :x, content: 'joy')
      tap = engine.create_tapestry(name: 'canvas', pattern: :satin)
      result = client.weave(thread_id: t.id, tapestry_id: tap.id, engine: engine)
      expect(result[:success]).to be true
    end
  end

  describe '#list_tapestries via client' do
    it 'returns empty tapestries on fresh engine' do
      result = client.list_tapestries(engine: engine)
      expect(result[:count]).to eq(0)
    end
  end

  describe '#loom_status via client' do
    it 'returns status report' do
      result = client.loom_status(engine: engine)
      expect(result[:success]).to be true
      expect(result[:report]).to be_a(Hash)
    end
  end
end
