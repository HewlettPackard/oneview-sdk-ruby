require 'spec_helper'

klass = OneviewSDK::Switch
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#remove' do
    it 'remove resource' do
      @item = OneviewSDK::Switch.find_by($client, {}).first
      expect { @item.remove }.to_not raise_error
    end
  end
end
