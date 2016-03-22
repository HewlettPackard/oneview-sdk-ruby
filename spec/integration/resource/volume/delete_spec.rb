require 'spec_helper'

RSpec.describe OneviewSDK::Volume, integration: true, type: DELETE, sequence: 1 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the volume' do
      volume = OneviewSDK::Volume.new($client, name: VOLUME_NAME)
      volume.retrieve!
      volume.delete
    end
  end
end
