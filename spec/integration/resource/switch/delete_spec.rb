require 'spec_helper'

klass = OneviewSDK::Switch
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'delete resource' do
      @item = OneviewSDK::Switch.find_by($client, {}).first
      expect { @item.delete }.to_not raise_error
    end
  end

end
