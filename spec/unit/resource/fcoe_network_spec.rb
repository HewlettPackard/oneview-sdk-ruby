require 'spec_helper'

RSpec.describe OneviewSDK::FCoENetwork do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = described_class.new(@client)
      expect(item[:type]).to eq('fcoe-network')
      expect(item[:connectionTemplateUri]).to eq(nil)
    end
  end
end
