require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::Switch do
  include_context 'shared context'

  it 'inherits from API500' do
    expect(described_class).to be < OneviewSDK::API500::C7000::Switch
  end

  describe '#set_scope_uris' do
    it 'is unavailable' do
      item = described_class.new(@client_600)
      expect { item.set_scope_uris }.to raise_error(OneviewSDK::MethodUnavailable, /The method #set_scope_uris is unavailable/)
    end
  end
end
