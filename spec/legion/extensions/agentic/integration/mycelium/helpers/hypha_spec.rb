# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Mycelium::Helpers::Hypha do
  let(:hypha) do
    described_class.new(source_id: 'src', target_id: 'tgt',
                        nutrient_type: :information)
  end

  describe '#initialize' do
    it 'assigns UUID' do
      expect(hypha.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'starts in growing state' do
      expect(hypha.state).to eq :growing
    end

    it 'raises on invalid nutrient_type' do
      expect do
        described_class.new(source_id: 'a', target_id: 'b',
                            nutrient_type: :bogus)
      end.to raise_error(ArgumentError, /unknown nutrient type/)
    end
  end

  describe '#reinforce!' do
    it 'increases strength' do
      hypha.reinforce!(amount: 0.2)
      expect(hypha.strength).to eq 0.7
    end

    it 'transitions to mature at 0.6' do
      hypha.reinforce!(amount: 0.2)
      expect(hypha.state).to eq :mature
    end
  end

  describe '#decay!' do
    it 'decreases strength' do
      original = hypha.strength
      hypha.decay!
      expect(hypha.strength).to be < original
    end

    it 'transitions to decaying when below 0.2' do
      hypha.instance_variable_set(:@strength, 0.2)
      hypha.decay!(rate: 0.05)
      expect(hypha.state).to eq :decaying
    end
  end

  describe '#transfer_capacity' do
    it 'returns strength * efficiency' do
      expected = (0.5 * 0.8).round(10)
      expect(hypha.transfer_capacity).to eq expected
    end
  end

  describe '#active?' do
    it 'true when growing' do
      expect(hypha.active?).to be true
    end

    it 'false when decaying' do
      hypha.instance_variable_set(:@state, :decaying)
      expect(hypha.active?).to be false
    end
  end
end
