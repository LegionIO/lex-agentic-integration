# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Mycelium::Helpers::MyceliumEngine do
  let(:engine) { described_class.new }

  describe '#create_node' do
    it 'creates a node' do
      node = engine.create_node(node_type: :knowledge_cluster,
                                domain: :semantic, content: 'test')
      expect(node.node_type).to eq :knowledge_cluster
    end

    it 'tracks in all_nodes' do
      engine.create_node(node_type: :insight_node, domain: :creative,
                         content: 'x')
      expect(engine.all_nodes.size).to eq 1
    end
  end

  describe '#connect' do
    let(:n1) do
      engine.create_node(node_type: :knowledge_cluster, domain: :semantic,
                         content: 'a')
    end
    let(:n2) do
      engine.create_node(node_type: :skill_node, domain: :procedural,
                         content: 'b')
    end

    it 'creates a hypha' do
      h = engine.connect(source_id: n1.id, target_id: n2.id,
                         nutrient_type: :information)
      expect(h.source_id).to eq n1.id
    end

    it 'increments connection counts' do
      engine.connect(source_id: n1.id, target_id: n2.id,
                     nutrient_type: :information)
      expect(n1.connections_count).to eq 1
      expect(n2.connections_count).to eq 1
    end

    it 'raises for unknown node' do
      expect do
        engine.connect(source_id: 'bad', target_id: n2.id,
                       nutrient_type: :information)
      end.to raise_error(ArgumentError, /node not found/)
    end
  end

  describe '#transfer_nutrients' do
    it 'moves nutrients from source to target' do
      n1 = engine.create_node(node_type: :knowledge_cluster,
                              domain: :semantic, content: 'src',
                              nutrient_level: 0.8)
      n2 = engine.create_node(node_type: :skill_node, domain: :procedural,
                              content: 'tgt', nutrient_level: 0.2)
      h = engine.connect(source_id: n1.id, target_id: n2.id,
                         nutrient_type: :information)
      result = engine.transfer_nutrients(hypha_id: h.id)
      expect(result[:transferred]).to be > 0
      expect(n1.nutrient_level).to be < 0.8
      expect(n2.nutrient_level).to be > 0.2
    end
  end

  describe '#fruit!' do
    it 'creates fruiting body when node is ready' do
      n = engine.create_node(node_type: :creative_node, domain: :creative,
                             content: 'ripe', nutrient_level: 0.9)
      body = engine.fruit!(node_id: n.id, fruiting_type: :insight,
                           content: 'eureka')
      expect(body.fruiting_type).to eq :insight
    end

    it 'raises when node is not ready' do
      n = engine.create_node(node_type: :creative_node, domain: :creative,
                             content: 'unripe', nutrient_level: 0.3)
      expect do
        engine.fruit!(node_id: n.id, fruiting_type: :insight,
                      content: 'too early')
      end.to raise_error(ArgumentError, /not ready/)
    end

    it 'depletes the source node' do
      n = engine.create_node(node_type: :creative_node, domain: :creative,
                             content: 'ripe', nutrient_level: 0.9)
      engine.fruit!(node_id: n.id, fruiting_type: :breakthrough,
                    content: 'big')
      expect(n.nutrient_level).to be < 0.9
    end
  end

  describe '#decay_network!' do
    it 'reduces strengths' do
      n1 = engine.create_node(node_type: :knowledge_cluster,
                              domain: :semantic, content: 'a')
      n2 = engine.create_node(node_type: :skill_node, domain: :procedural,
                              content: 'b')
      h = engine.connect(source_id: n1.id, target_id: n2.id,
                         nutrient_type: :information)
      original = h.strength
      engine.decay_network!
      expect(h.strength).to be < original
    end
  end

  describe '#connections_for' do
    it 'returns hyphae connected to a node' do
      n1 = engine.create_node(node_type: :knowledge_cluster,
                              domain: :semantic, content: 'a')
      n2 = engine.create_node(node_type: :skill_node, domain: :procedural,
                              content: 'b')
      engine.connect(source_id: n1.id, target_id: n2.id,
                     nutrient_type: :experience)
      expect(engine.connections_for(n1.id).size).to eq 1
    end
  end

  describe '#network_report' do
    it 'returns comprehensive report' do
      engine.create_node(node_type: :knowledge_cluster, domain: :semantic,
                         content: 'x')
      report = engine.network_report
      %i[total_nodes total_hyphae total_fruiting active_hyphae
         avg_nutrient avg_strength fruiting_ready starving_nodes
         network_health].each do |key|
        expect(report).to have_key(key)
      end
    end

    it 'works empty' do
      expect(engine.network_report[:total_nodes]).to eq 0
    end
  end
end
