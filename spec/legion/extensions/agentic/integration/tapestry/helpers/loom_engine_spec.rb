# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Tapestry::Helpers::LoomEngine do
  subject(:engine) { described_class.new }

  def spin(type: :experience, domain: :test, content: 'data', strength: 0.5)
    engine.spin_thread(thread_type: type, domain: domain, content: content, strength: strength)
  end

  def create_tap(name: 'story', pattern: :plain, capacity: 10)
    engine.create_tapestry(name: name, pattern: pattern, capacity: capacity)
  end

  describe '#spin_thread' do
    it 'returns a Thread instance' do
      expect(spin).to be_a(Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Thread)
    end

    it 'stores the thread internally' do
      t = spin
      expect(engine.all_threads).to include(t)
    end

    it 'raises ArgumentError for invalid thread_type' do
      expect { engine.spin_thread(thread_type: :bogus, domain: :x, content: 'y') }
        .to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when limit reached' do
      stub_const('Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Constants::MAX_THREADS', 1)
      engine.spin_thread(thread_type: :belief, domain: :x, content: '1')
      expect { engine.spin_thread(thread_type: :belief, domain: :x, content: '2') }
        .to raise_error(ArgumentError, /limit/)
    end
  end

  describe '#create_tapestry' do
    it 'returns a Tapestry instance' do
      expect(create_tap).to be_a(Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Tapestry)
    end

    it 'stores the tapestry internally' do
      tap = create_tap
      expect(engine.all_tapestries).to include(tap)
    end

    it 'raises ArgumentError for invalid pattern' do
      expect { engine.create_tapestry(name: 'x', pattern: :invalid) }
        .to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when limit reached' do
      stub_const('Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Constants::MAX_TAPESTRIES', 1)
      engine.create_tapestry(name: 'one', pattern: :plain)
      expect { engine.create_tapestry(name: 'two', pattern: :plain) }
        .to raise_error(ArgumentError, /limit/)
    end
  end

  describe '#weave' do
    let(:t)   { spin }
    let(:tap) { create_tap }

    it 'returns the Thread' do
      result = engine.weave(thread_id: t.id, tapestry_id: tap.id)
      expect(result).to be_a(Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Thread)
    end

    it 'marks the thread as woven' do
      engine.weave(thread_id: t.id, tapestry_id: tap.id)
      expect(t.woven?).to be true
    end

    it 'adds thread id to tapestry' do
      engine.weave(thread_id: t.id, tapestry_id: tap.id)
      expect(tap.thread_ids).to include(t.id)
    end

    it 'raises ArgumentError when thread already woven' do
      engine.weave(thread_id: t.id, tapestry_id: tap.id)
      tap2 = create_tap(name: 'second', pattern: :twill)
      expect { engine.weave(thread_id: t.id, tapestry_id: tap2.id) }
        .to raise_error(ArgumentError, /already woven/)
    end

    it 'raises ArgumentError when tapestry is full' do
      small_tap = engine.create_tapestry(name: 'tiny', pattern: :plain, capacity: 1)
      t1 = spin(content: 'a')
      t2 = spin(content: 'b')
      engine.weave(thread_id: t1.id, tapestry_id: small_tap.id)
      expect { engine.weave(thread_id: t2.id, tapestry_id: small_tap.id) }
        .to raise_error(ArgumentError, /full/)
    end

    it 'raises ArgumentError for missing thread' do
      expect { engine.weave(thread_id: 'nope', tapestry_id: tap.id) }
        .to raise_error(ArgumentError, /thread not found/)
    end

    it 'raises ArgumentError for missing tapestry' do
      expect { engine.weave(thread_id: t.id, tapestry_id: 'nope') }
        .to raise_error(ArgumentError, /tapestry not found/)
    end
  end

  describe '#unravel' do
    let(:t)   { spin }
    let(:tap) { create_tap }

    before { engine.weave(thread_id: t.id, tapestry_id: tap.id) }

    it 'returns the Thread' do
      result = engine.unravel(thread_id: t.id, tapestry_id: tap.id)
      expect(result).to be_a(Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Thread)
    end

    it 'marks thread as loose' do
      engine.unravel(thread_id: t.id, tapestry_id: tap.id)
      expect(t.loose?).to be true
    end

    it 'removes thread from tapestry' do
      engine.unravel(thread_id: t.id, tapestry_id: tap.id)
      expect(tap.thread_ids).not_to include(t.id)
    end
  end

  describe '#fray_all!' do
    it 'returns stats hash' do
      spin
      result = engine.fray_all!
      expect(result).to have_key(:total)
      expect(result).to have_key(:snapped)
    end

    it 'decreases thread strengths' do
      t = spin(strength: 0.5)
      engine.fray_all!
      expect(t.strength).to be < 0.5
    end

    it 'counts snapped threads' do
      t = spin(strength: 0.0)
      result = engine.fray_all!
      expect(result[:snapped]).to be >= 1
      expect(t).to be_snap
    end
  end

  describe '#most_complete' do
    it 'returns tapestries sorted by completeness descending' do
      tap1 = create_tap(name: 'a', pattern: :plain, capacity: 2)
      create_tap(name: 'b', pattern: :twill, capacity: 10)
      engine.spin_thread(thread_type: :experience, domain: :x, content: 'c').tap do |t|
        engine.weave(thread_id: t.id, tapestry_id: tap1.id)
      end
      result = engine.most_complete(limit: 2)
      expect(result.first.id).to eq(tap1.id)
    end

    it 'respects the limit' do
      3.times { |i| create_tap(name: "t#{i}", pattern: :plain) }
      expect(engine.most_complete(limit: 2).size).to eq(2)
    end
  end

  describe '#most_coherent' do
    it 'returns tapestries' do
      create_tap
      result = engine.most_coherent(limit: 1)
      expect(result).not_to be_empty
    end
  end

  describe '#thread_inventory' do
    it 'returns counts per thread type' do
      spin(type: :belief)
      spin(type: :memory)
      inv = engine.thread_inventory
      expect(inv[:belief]).to eq(1)
      expect(inv[:memory]).to eq(1)
      expect(inv[:experience]).to eq(0)
    end
  end

  describe '#tapestry_report' do
    it 'includes expected keys' do
      result = engine.tapestry_report
      %i[total_threads total_tapestries loose_count by_type fraying_count avg_completeness].each do |k|
        expect(result).to have_key(k)
      end
    end

    it 'counts loose threads' do
      spin
      expect(engine.tapestry_report[:loose_count]).to eq(1)
    end
  end

  describe '#loose_threads' do
    it 'returns unplaced threads' do
      t = spin
      expect(engine.loose_threads).to include(t)
    end

    it 'excludes woven threads' do
      t   = spin
      tap = create_tap
      engine.weave(thread_id: t.id, tapestry_id: tap.id)
      expect(engine.loose_threads).not_to include(t)
    end
  end

  describe '#all_threads and #all_tapestries' do
    it 'returns all threads' do
      spin
      expect(engine.all_threads.size).to eq(1)
    end

    it 'returns all tapestries' do
      create_tap
      expect(engine.all_tapestries.size).to eq(1)
    end
  end
end
