# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Mycelium::Helpers::MycelialNode do
  let(:node) do
    described_class.new(node_type: :knowledge_cluster, domain: :semantic,
                        content: 'test node')
  end

  describe '#initialize' do
    it 'assigns UUID' do
      expect(node.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'sets node_type' do
      expect(node.node_type).to eq :knowledge_cluster
    end

    it 'defaults nutrient_level to 0.5' do
      expect(node.nutrient_level).to eq 0.5
    end

    it 'raises on invalid type' do
      expect do
        described_class.new(node_type: :bogus, domain: :x, content: 'x')
      end.to raise_error(ArgumentError, /unknown node type/)
    end
  end

  describe '#absorb!' do
    it 'increases nutrient_level' do
      node.absorb!(0.2)
      expect(node.nutrient_level).to eq 0.7
    end

    it 'clamps at 1.0' do
      node.absorb!(5.0)
      expect(node.nutrient_level).to eq 1.0
    end
  end

  describe '#deplete!' do
    it 'decreases nutrient_level' do
      node.deplete!(0.2)
      expect(node.nutrient_level).to eq 0.3
    end

    it 'clamps at 0.0' do
      node.deplete!(5.0)
      expect(node.nutrient_level).to eq 0.0
    end
  end

  describe '#fruiting_ready?' do
    it 'true when nutrient >= threshold' do
      node.absorb!(0.3)
      expect(node.fruiting_ready?).to be true
    end

    it 'false when below threshold' do
      expect(node.fruiting_ready?).to be false
    end
  end

  describe '#starving?' do
    it 'true when nutrient < 0.1' do
      node.deplete!(0.45)
      expect(node.starving?).to be true
    end
  end

  describe '#to_h' do
    it 'includes expected keys' do
      %i[id node_type domain content nutrient_level connections_count
         fruiting_ready starving created_at].each do |key|
        expect(node.to_h).to have_key(key)
      end
    end
  end
end
