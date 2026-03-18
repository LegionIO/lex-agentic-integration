# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Mycelium::Client do
  let(:client) { described_class.new }

  it 'responds to runner methods' do
    expect(client).to respond_to(:create_node, :connect, :fruit,
                                 :network_status)
  end

  describe '#create_node' do
    it 'delegates' do
      result = client.create_node(node_type: :knowledge_cluster,
                                  domain: :semantic, content: 'x')
      expect(result[:success]).to be true
    end
  end

  describe '#network_status' do
    it 'returns report' do
      result = client.network_status
      expect(result[:report]).to be_a Hash
    end
  end
end
