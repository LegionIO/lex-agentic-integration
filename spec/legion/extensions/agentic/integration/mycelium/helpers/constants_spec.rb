# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Mycelium::Helpers::Constants do
  let(:c) { described_class }

  it 'defines MAX_NODES' do
    expect(c::MAX_NODES).to eq 200
  end

  it 'has 6 node types' do
    expect(c::NODE_TYPES.size).to eq 6
  end

  it 'has 6 nutrient types' do
    expect(c::NUTRIENT_TYPES.size).to eq 6
  end

  it 'has 6 fruiting types' do
    expect(c::FRUITING_TYPES.size).to eq 6
  end

  describe '.label_for' do
    it 'returns health labels' do
      expect(c.label_for(c::NETWORK_HEALTH_LABELS, 0.9)).to eq :thriving
      expect(c.label_for(c::NETWORK_HEALTH_LABELS, 0.1)).to eq :depleted
    end
  end
end
