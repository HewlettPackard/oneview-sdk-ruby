require 'spec_helper'

RSpec.describe OneviewSDK::LogicalEnclosure do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 2.0' do
      it 'sets the type correctly' do
        template = OneviewSDK::LogicalEnclosure.new(@client)
        expect(template[:type]).to eq('LogicalEnclosure')
      end
    end
  end

  describe '#validate' do
    context 'fabricType' do
      it 'valid values' do
        logical_enclosure = OneviewSDK::LogicalEnclosure.new(@client)
        valid_values = %w(DirectAttach FabricAttach)
        valid_values.each do |value|
          logical_enclosure[:fabricType] = value
          expect(logical_enclosure[:fabricType]).to eq(value)
        end
      end

      it 'invalid values' do
        logical_enclosure = OneviewSDK::LogicalEnclosure.new(@client)
        expect { logical_enclosure[:fabricType] = 'None' }.to raise_error.with_message(/Invalid fabric type/)
      end
    end
  end
end
