require 'spec_helper'

RSpec.describe OneviewSDK::Switch, integration: true, type: DELETE, sequence: 15 do
  include_context 'integration context'

  describe '#delete' do
    it 'delete resource' do
      @item = OneviewSDK::Switch.find_by($client, {}).first
      expect { @item.delete }.to_not raise_error
    end
  end

end
