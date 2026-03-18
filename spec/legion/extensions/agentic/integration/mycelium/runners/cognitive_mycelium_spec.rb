# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Mycelium::Runners::CognitiveMycelium do
  let(:engine) { Legion::Extensions::Agentic::Integration::Mycelium::Helpers::MyceliumEngine.new }
  let(:runner) { described_class }

  describe '.create_node' do
    it 'succeeds' do
      result = runner.create_node(node_type: :knowledge_cluster,
                                  domain: :semantic, content: 'test',
                                  engine: engine)
      expect(result[:success]).to be true
      expect(result[:node][:node_type]).to eq :knowledge_cluster
    end

    it 'returns failure for invalid type' do
      result = runner.create_node(node_type: :bogus, domain: :x,
                                  content: 'x', engine: engine)
      expect(result[:success]).to be false
    end
  end

  describe '.connect' do
    it 'creates connection' do
      n1 = engine.create_node(node_type: :knowledge_cluster,
                              domain: :semantic, content: 'a')
      n2 = engine.create_node(node_type: :skill_node, domain: :procedural,
                              content: 'b')
      result = runner.connect(source_id: n1.id, target_id: n2.id,
                              nutrient_type: :information, engine: engine)
      expect(result[:success]).to be true
    end
  end

  describe '.fruit' do
    it 'creates fruiting body' do
      n = engine.create_node(node_type: :creative_node, domain: :creative,
                             content: 'ripe', nutrient_level: 0.9)
      result = runner.fruit(node_id: n.id, fruiting_type: :insight,
                            content: 'eureka', engine: engine)
      expect(result[:success]).to be true
      expect(result[:fruiting_body][:fruiting_type]).to eq :insight
    end

    it 'returns failure when not ready' do
      n = engine.create_node(node_type: :creative_node, domain: :creative,
                             content: 'x', nutrient_level: 0.2)
      result = runner.fruit(node_id: n.id, fruiting_type: :insight,
                            content: 'x', engine: engine)
      expect(result[:success]).to be false
    end
  end

  describe '.network_status' do
    it 'returns report' do
      result = runner.network_status(engine: engine)
      expect(result[:success]).to be true
      expect(result[:report]).to be_a Hash
    end
  end
end
