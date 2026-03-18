# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Mycelium::Helpers::FruitingBody do
  let(:body) do
    described_class.new(fruiting_type: :insight, source_node_id: 'node-1',
                        content: 'breakthrough discovery')
  end

  describe '#initialize' do
    it 'assigns UUID' do
      expect(body.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'sets fruiting_type' do
      expect(body.fruiting_type).to eq :insight
    end

    it 'raises on invalid type' do
      expect do
        described_class.new(fruiting_type: :bogus, source_node_id: 'x',
                            content: 'x')
      end.to raise_error(ArgumentError, /unknown fruiting type/)
    end
  end

  describe '#to_h' do
    it 'includes expected keys' do
      %i[id fruiting_type source_node_id content potency emerged_at].each do |key|
        expect(body.to_h).to have_key(key)
      end
    end
  end
end
