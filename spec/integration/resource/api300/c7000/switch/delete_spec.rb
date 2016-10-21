require 'spec_helper'

klass = OneviewSDK::API300::C7000::Switch
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#remove' do
    it 'remove resource' do
      @item = klass.find_by($client_300, {}).first
      expect { @item.remove }.to_not raise_error
    end
  end
end
