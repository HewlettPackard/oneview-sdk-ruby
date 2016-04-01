require 'spec_helper'

RSpec.describe OneviewSDK::VolumeTemplate, integration: true, type: DELETE, sequence: 2 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::VolumeTemplate.new(@client, name: 'ONEVIEW_SDK_TEST VT2')
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end
  end

end
