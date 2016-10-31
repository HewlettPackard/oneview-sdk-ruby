require 'spec_helper'

klass = OneviewSDK::VolumeTemplate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#delete' do
    it 'deletes the resource' do
      item = klass.new($client_300, name: VOL_TEMP_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end
  end

end
