# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Integration::Tapestry::Helpers::Constants do
  describe 'THREAD_TYPES' do
    it 'contains expected types' do
      expect(described_class::THREAD_TYPES).to include(:experience, :belief, :memory, :emotion, :narrative)
    end

    it 'has five types' do
      expect(described_class::THREAD_TYPES.size).to eq(5)
    end

    it 'is frozen' do
      expect(described_class::THREAD_TYPES).to be_frozen
    end
  end

  describe 'WEAVE_PATTERNS' do
    it 'contains expected patterns' do
      expect(described_class::WEAVE_PATTERNS).to include(:plain, :twill, :satin, :brocade)
    end

    it 'has four patterns' do
      expect(described_class::WEAVE_PATTERNS.size).to eq(4)
    end

    it 'is frozen' do
      expect(described_class::WEAVE_PATTERNS).to be_frozen
    end
  end

  describe 'capacity constants' do
    it 'defines MAX_THREADS as 500' do
      expect(described_class::MAX_THREADS).to eq(500)
    end

    it 'defines MAX_TAPESTRIES as 50' do
      expect(described_class::MAX_TAPESTRIES).to eq(50)
    end

    it 'defines TENSION_RATE as 0.05' do
      expect(described_class::TENSION_RATE).to eq(0.05)
    end

    it 'defines FRAY_RATE as 0.03' do
      expect(described_class::FRAY_RATE).to eq(0.03)
    end
  end

  describe 'INTEGRITY_LABELS' do
    it 'labels high strength as masterwork' do
      expect(described_class.label_for(described_class::INTEGRITY_LABELS, 0.95)).to eq(:masterwork)
    end

    it 'labels near-zero strength as rags' do
      expect(described_class.label_for(described_class::INTEGRITY_LABELS, 0.05)).to eq(:rags)
    end

    it 'labels mid strength as woven' do
      expect(described_class.label_for(described_class::INTEGRITY_LABELS, 0.55)).to eq(:woven)
    end

    it 'labels fraying range correctly' do
      expect(described_class.label_for(described_class::INTEGRITY_LABELS, 0.35)).to eq(:fraying)
    end
  end

  describe 'COMPLEXITY_LABELS' do
    it 'labels high complexity as baroque' do
      expect(described_class.label_for(described_class::COMPLEXITY_LABELS, 0.95)).to eq(:baroque)
    end

    it 'labels low complexity as simple' do
      expect(described_class.label_for(described_class::COMPLEXITY_LABELS, 0.1)).to eq(:simple)
    end

    it 'labels mid complexity as patterned' do
      expect(described_class.label_for(described_class::COMPLEXITY_LABELS, 0.5)).to eq(:patterned)
    end
  end

  describe '.label_for' do
    it 'returns last label as fallback for out-of-range values' do
      result = described_class.label_for(described_class::INTEGRITY_LABELS, -1.0)
      expect(result).to eq(:rags)
    end
  end
end
