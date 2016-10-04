require 'spec_helper'

klass = OneviewSDK::VolumeTemplate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::VolumeTemplate.new($client, name: VOL_TEMP_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end
  end

end
