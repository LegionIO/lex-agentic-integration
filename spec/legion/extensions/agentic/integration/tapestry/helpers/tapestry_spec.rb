# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Tapestry do
  subject(:tapestry) do
    described_class.new(name: 'life story', pattern: :brocade, capacity: 10)
  end

  let(:thread_klass) { Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Thread }

  def make_thread(type: :experience, strength: 0.5)
    thread_klass.new(thread_type: type, domain: :reasoning, content: 'event', strength: strength)
  end

  describe '#initialize' do
    it 'sets name' do
      expect(tapestry.name).to eq('life story')
    end

    it 'sets pattern' do
      expect(tapestry.pattern).to eq(:brocade)
    end

    it 'sets capacity' do
      expect(tapestry.capacity).to eq(10)
    end

    it 'generates a uuid id' do
      expect(tapestry.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'starts empty' do
      expect(tapestry.empty?).to be true
    end

    it 'starts not full' do
      expect(tapestry.full?).to be false
    end

    it 'records created_at' do
      expect(tapestry.created_at).to be_a(Time)
    end

    it 'rejects unknown pattern' do
      expect do
        described_class.new(name: 'x', pattern: :zigzag)
      end.to raise_error(ArgumentError, /unknown pattern/)
    end

    it 'clamps capacity to at least 1' do
      t = described_class.new(name: 'x', pattern: :plain, capacity: 0)
      expect(t.capacity).to eq(1)
    end
  end

  describe '#weave_thread' do
    let(:t) { make_thread }

    it 'adds thread id and returns true' do
      expect(tapestry.weave_thread(t.id)).to be true
    end

    it 'rejects duplicate thread' do
      tapestry.weave_thread(t.id)
      expect(tapestry.weave_thread(t.id)).to be false
    end

    it 'rejects when full' do
      10.times do
        th = make_thread
        tapestry.weave_thread(th.id)
      end
      extra = make_thread
      expect(tapestry.weave_thread(extra.id)).to be false
    end
  end

  describe '#unravel_thread' do
    let(:t) { make_thread }

    it 'removes thread and returns true' do
      tapestry.weave_thread(t.id)
      expect(tapestry.unravel_thread(t.id)).to be true
    end

    it 'returns false for unknown thread' do
      expect(tapestry.unravel_thread('nope')).to be false
    end
  end

  describe '#size' do
    it 'starts at zero' do
      expect(tapestry.size).to eq(0)
    end

    it 'increments after weave' do
      tapestry.weave_thread('t-1')
      expect(tapestry.size).to eq(1)
    end
  end

  describe '#completeness' do
    it 'returns 0.0 when empty' do
      expect(tapestry.completeness).to eq(0.0)
    end

    it 'returns fraction of capacity' do
      5.times { tapestry.weave_thread(SecureRandom.uuid) }
      expect(tapestry.completeness).to eq(0.5)
    end

    it 'returns 1.0 when full' do
      10.times { tapestry.weave_thread(SecureRandom.uuid) }
      expect(tapestry.completeness).to eq(1.0)
    end
  end

  describe '#gap_count' do
    it 'equals capacity minus size' do
      tapestry.weave_thread(SecureRandom.uuid)
      expect(tapestry.gap_count).to eq(9)
    end
  end

  describe '#fraying?' do
    it 'returns false with no threads' do
      expect(tapestry.fraying?([])).to be false
    end

    it 'returns true when avg strength < 0.3' do
      t = make_thread(strength: 0.1)
      tapestry.weave_thread(t.id)
      expect(tapestry.fraying?([t])).to be true
    end

    it 'returns false when avg strength >= 0.3' do
      t = make_thread(strength: 0.8)
      tapestry.weave_thread(t.id)
      expect(tapestry.fraying?([t])).to be false
    end
  end

  describe '#masterwork?' do
    it 'returns false when empty' do
      expect(tapestry.masterwork?([])).to be false
    end

    it 'returns true when threads taut and completeness high' do
      cap = 3
      tap = described_class.new(name: 'x', pattern: :brocade, capacity: cap)
      threads = Array.new(cap) do
        make_thread(strength: 0.95).tap { |t| tap.weave_thread(t.id) }
      end
      expect(tap.masterwork?(threads)).to be true
    end

    it 'returns false when completeness low' do
      t = make_thread(strength: 0.95)
      tapestry.weave_thread(t.id)
      expect(tapestry.masterwork?([t])).to be false
    end
  end

  describe '#coherence_score' do
    it 'returns 0.0 for empty tapestry' do
      expect(tapestry.coherence_score([])).to eq(0.0)
    end

    it 'returns a float between 0 and 1' do
      t = make_thread(strength: 0.7)
      tapestry.weave_thread(t.id)
      score = tapestry.coherence_score([t])
      expect(score).to be_between(0.0, 1.0)
    end

    it 'benefits from higher pattern coherence factor (brocade > plain)' do
      plain_tap = described_class.new(name: 'p', pattern: :plain, capacity: 5)
      brocade_tap = described_class.new(name: 'b', pattern: :brocade, capacity: 5)
      t = make_thread(strength: 0.7)
      plain_tap.weave_thread(t.id)
      brocade_tap.weave_thread(t.id)
      expect(brocade_tap.coherence_score([t])).to be > plain_tap.coherence_score([t])
    end
  end

  describe '#completeness_label' do
    it 'returns a symbol' do
      expect(tapestry.completeness_label).to be_a(Symbol)
    end
  end

  describe '#complexity_label' do
    it 'returns a symbol' do
      t = make_thread(strength: 0.7)
      tapestry.weave_thread(t.id)
      expect(tapestry.complexity_label([t])).to be_a(Symbol)
    end
  end

  describe '#to_h' do
    it 'includes all expected keys' do
      h = tapestry.to_h([])
      %i[id name pattern capacity size completeness completeness_label
         coherence_score gap_count full empty fraying masterwork
         thread_ids created_at].each do |k|
        expect(h).to have_key(k)
      end
    end

    it 'thread_ids is a dup (not the same array)' do
      tap_h = tapestry.to_h([])
      tap_h[:thread_ids] << 'injected'
      expect(tapestry.thread_ids).not_to include('injected')
    end
  end

  describe '#age!' do
    it 'returns the fray_rate (no state mutation on tapestry itself)' do
      result = tapestry.age!
      expect(result).to be_a(Numeric)
    end
  end

  describe '#repair!' do
    it 'returns the boost value' do
      result = tapestry.repair!
      expect(result).to eq(0.1)
    end
  end
end
