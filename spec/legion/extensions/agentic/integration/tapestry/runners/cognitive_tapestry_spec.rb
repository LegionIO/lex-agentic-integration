# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Tapestry::Runners::CognitiveTapestry do
  let(:engine) { Legion::Extensions::Agentic::Integration::Tapestry::Helpers::LoomEngine.new }

  let(:runner_host) do
    host = Object.new
    host.extend(described_class)
    host
  end

  describe '#spin_thread' do
    it 'returns success with thread hash' do
      result = runner_host.spin_thread(
        thread_type: :experience, domain: :test, content: 'something happened',
        engine: engine
      )
      expect(result[:success]).to be true
      expect(result[:thread][:thread_type]).to eq(:experience)
    end

    it 'returns failure for invalid thread_type' do
      result = runner_host.spin_thread(
        thread_type: :bogus, domain: :x, content: 'y', engine: engine
      )
      expect(result[:success]).to be false
      expect(result[:error]).to include('unknown thread_type')
    end

    it 'accepts optional strength and color' do
      result = runner_host.spin_thread(
        thread_type: :belief, domain: :x, content: 'core belief',
        strength: 0.8, color: :amber, engine: engine
      )
      expect(result[:success]).to be true
      expect(result[:thread][:strength]).to eq(0.8)
      expect(result[:thread][:color]).to eq(:amber)
    end

    it 'absorbs extra keyword args via **' do
      expect do
        runner_host.spin_thread(
          thread_type: :memory, domain: :x, content: 'y',
          engine: engine, unknown_key: 'ignored'
        )
      end.not_to raise_error
    end
  end

  describe '#create_tapestry' do
    it 'returns success with tapestry hash' do
      result = runner_host.create_tapestry(
        name: 'my story', pattern: :brocade, engine: engine
      )
      expect(result[:success]).to be true
      expect(result[:tapestry][:name]).to eq('my story')
      expect(result[:tapestry][:pattern]).to eq(:brocade)
    end

    it 'returns failure for invalid pattern' do
      result = runner_host.create_tapestry(
        name: 'x', pattern: :hexagonal, engine: engine
      )
      expect(result[:success]).to be false
    end

    it 'accepts custom capacity' do
      result = runner_host.create_tapestry(
        name: 'limited', pattern: :plain, capacity: 5, engine: engine
      )
      expect(result[:success]).to be true
      expect(result[:tapestry][:capacity]).to eq(5)
    end
  end

  describe '#weave' do
    let(:thread_result) do
      runner_host.spin_thread(thread_type: :narrative, domain: :x, content: 'a', engine: engine)
    end
    let(:tapestry_result) do
      runner_host.create_tapestry(name: 'canvas', pattern: :satin, engine: engine)
    end

    it 'successfully weaves thread into tapestry' do
      result = runner_host.weave(
        thread_id:   thread_result[:thread][:id],
        tapestry_id: tapestry_result[:tapestry][:id],
        engine:      engine
      )
      expect(result[:success]).to be true
    end

    it 'returns failure when thread is already woven' do
      first_tap = runner_host.create_tapestry(name: 'first', pattern: :plain, engine: engine)
      runner_host.weave(
        thread_id:   thread_result[:thread][:id],
        tapestry_id: first_tap[:tapestry][:id],
        engine:      engine
      )
      result = runner_host.weave(
        thread_id:   thread_result[:thread][:id],
        tapestry_id: tapestry_result[:tapestry][:id],
        engine:      engine
      )
      expect(result[:success]).to be false
      expect(result[:error]).to include('already woven')
    end

    it 'returns failure for unknown thread_id' do
      result = runner_host.weave(
        thread_id: 'nonexistent', tapestry_id: tapestry_result[:tapestry][:id], engine: engine
      )
      expect(result[:success]).to be false
    end

    it 'returns failure for unknown tapestry_id' do
      result = runner_host.weave(
        thread_id: thread_result[:thread][:id], tapestry_id: 'nonexistent', engine: engine
      )
      expect(result[:success]).to be false
    end
  end

  describe '#list_tapestries' do
    before do
      runner_host.create_tapestry(name: 'plain one', pattern: :plain, engine: engine)
      runner_host.create_tapestry(name: 'twill one', pattern: :twill, engine: engine)
    end

    it 'returns all tapestries when no filter' do
      result = runner_host.list_tapestries(engine: engine)
      expect(result[:success]).to be true
      expect(result[:count]).to eq(2)
    end

    it 'filters by pattern' do
      result = runner_host.list_tapestries(engine: engine, pattern: :plain)
      expect(result[:count]).to eq(1)
      expect(result[:tapestries].first[:pattern]).to eq(:plain)
    end

    it 'filters fraying_only' do
      weak_t = engine.spin_thread(thread_type: :emotion, domain: :x, content: 'y', strength: 0.05)
      tap3   = engine.create_tapestry(name: 'fragile', pattern: :satin, capacity: 5)
      engine.weave(thread_id: weak_t.id, tapestry_id: tap3.id)
      result = runner_host.list_tapestries(engine: engine, fraying_only: true)
      expect(result[:count]).to be >= 1
    end

    it 'returns empty array when no match' do
      result = runner_host.list_tapestries(engine: engine, pattern: :brocade)
      expect(result[:count]).to eq(0)
      expect(result[:tapestries]).to be_empty
    end
  end

  describe '#loom_status' do
    it 'returns success with report' do
      result = runner_host.loom_status(engine: engine)
      expect(result[:success]).to be true
      expect(result[:report]).to have_key(:total_threads)
      expect(result[:report]).to have_key(:total_tapestries)
    end

    it 'report includes loose_count' do
      runner_host.spin_thread(thread_type: :belief, domain: :x, content: 'y', engine: engine)
      result = runner_host.loom_status(engine: engine)
      expect(result[:report][:loose_count]).to eq(1)
    end

    it 'report includes fraying_count' do
      result = runner_host.loom_status(engine: engine)
      expect(result[:report]).to have_key(:fraying_count)
    end
  end
end
