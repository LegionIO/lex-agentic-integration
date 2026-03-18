# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Thread do
  subject(:thread) do
    described_class.new(thread_type: :experience, domain: :reasoning, content: 'a past event')
  end

  describe '#initialize' do
    it 'sets thread_type' do
      expect(thread.thread_type).to eq(:experience)
    end

    it 'sets domain as symbol' do
      expect(thread.domain).to eq(:reasoning)
    end

    it 'sets content as string' do
      expect(thread.content).to eq('a past event')
    end

    it 'generates a uuid id' do
      expect(thread.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'defaults strength to 0.5' do
      expect(thread.strength).to eq(0.5)
    end

    it 'assigns a default color based on type' do
      expect(thread.color).to eq(:gold)
    end

    it 'starts as loose (not woven)' do
      expect(thread.loose?).to be true
    end

    it 'starts with nil tapestry_id' do
      expect(thread.tapestry_id).to be_nil
    end

    it 'records created_at' do
      expect(thread.created_at).to be_a(Time)
    end

    it 'clamps strength above 1.0' do
      t = described_class.new(thread_type: :belief, domain: :x, content: 'y', strength: 2.0)
      expect(t.strength).to eq(1.0)
    end

    it 'clamps strength below 0.0' do
      t = described_class.new(thread_type: :memory, domain: :x, content: 'y', strength: -0.5)
      expect(t.strength).to eq(0.0)
    end

    it 'accepts custom color' do
      t = described_class.new(thread_type: :emotion, domain: :x, content: 'y', color: :amber)
      expect(t.color).to eq(:amber)
    end

    it 'rejects unknown thread_type' do
      expect do
        described_class.new(thread_type: :unknown, domain: :x, content: 'y')
      end.to raise_error(ArgumentError, /unknown thread_type/)
    end
  end

  describe '#woven_into!' do
    it 'sets tapestry_id' do
      thread.woven_into!('tap-1')
      expect(thread.tapestry_id).to eq('tap-1')
    end

    it 'marks thread as woven' do
      thread.woven_into!('tap-1')
      expect(thread.woven?).to be true
    end

    it 'returns self' do
      expect(thread.woven_into!('tap-1')).to eq(thread)
    end
  end

  describe '#unwoven!' do
    before { thread.woven_into!('tap-1') }

    it 'clears tapestry_id' do
      thread.unwoven!
      expect(thread.tapestry_id).to be_nil
    end

    it 'marks thread as loose' do
      thread.unwoven!
      expect(thread.loose?).to be true
    end
  end

  describe '#reinforce!' do
    it 'increases strength by TENSION_RATE by default' do
      before = thread.strength
      thread.reinforce!
      expect(thread.strength).to eq((before + Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Constants::TENSION_RATE).round(10))
    end

    it 'accepts custom rate' do
      thread.reinforce!(rate: 0.1)
      expect(thread.strength).to eq(0.6)
    end

    it 'clamps at 1.0' do
      t = described_class.new(thread_type: :narrative, domain: :x, content: 'y', strength: 0.99)
      t.reinforce!(rate: 0.5)
      expect(t.strength).to eq(1.0)
    end

    it 'returns self' do
      expect(thread.reinforce!).to eq(thread)
    end
  end

  describe '#fray!' do
    it 'decreases strength by FRAY_RATE by default' do
      before = thread.strength
      thread.fray!
      expect(thread.strength).to eq((before - Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Constants::FRAY_RATE).round(10))
    end

    it 'accepts custom rate' do
      thread.fray!(rate: 0.2)
      expect(thread.strength).to eq(0.3)
    end

    it 'clamps at 0.0' do
      t = described_class.new(thread_type: :experience, domain: :x, content: 'y', strength: 0.01)
      t.fray!(rate: 0.5)
      expect(t.strength).to eq(0.0)
    end

    it 'returns self' do
      expect(thread.fray!).to eq(thread)
    end
  end

  describe '#snap?' do
    it 'returns false when strength is positive' do
      expect(thread.snap?).to be false
    end

    it 'returns true when strength is zero' do
      t = described_class.new(thread_type: :belief, domain: :x, content: 'y', strength: 0.0)
      expect(t.snap?).to be true
    end
  end

  describe '#taut?' do
    it 'returns false at default strength' do
      expect(thread.taut?).to be false
    end

    it 'returns true at 0.9 or above' do
      t = described_class.new(thread_type: :memory, domain: :x, content: 'y', strength: 0.95)
      expect(t.taut?).to be true
    end
  end

  describe '#thread_integrity' do
    it 'returns a symbol label' do
      expect(thread.thread_integrity).to be_a(Symbol)
    end

    it 'returns masterwork for high strength' do
      t = described_class.new(thread_type: :emotion, domain: :x, content: 'y', strength: 0.95)
      expect(t.thread_integrity).to eq(:masterwork)
    end

    it 'returns rags for near-zero strength' do
      t = described_class.new(thread_type: :narrative, domain: :x, content: 'y', strength: 0.05)
      expect(t.thread_integrity).to eq(:rags)
    end
  end

  describe '#to_h' do
    it 'includes all expected keys' do
      h = thread.to_h
      %i[id thread_type domain content strength color thread_integrity
         woven loose snap taut tapestry_id created_at].each do |k|
        expect(h).to have_key(k)
      end
    end

    it 'reflects current woven state' do
      thread.woven_into!('t-1')
      expect(thread.to_h[:woven]).to be true
      expect(thread.to_h[:loose]).to be false
    end
  end

  describe 'color defaults per thread_type' do
    {
      experience: :gold,
      belief:     :silver,
      memory:     :blue,
      emotion:    :crimson,
      narrative:  :violet
    }.each do |type, expected_color|
      it "assigns #{expected_color} for #{type}" do
        t = described_class.new(thread_type: type, domain: :x, content: 'y')
        expect(t.color).to eq(expected_color)
      end
    end
  end
end
