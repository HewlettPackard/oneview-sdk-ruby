require 'spec_helper'

klass = OneviewSDK::API300::Synergy::VolumeTemplate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#delete' do
    it 'deletes the resource' do
      item = klass.new($client_300_synergy, name: VOL_TEMP_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
      item = klass.find_by($client_300_synergy, name: VOL_TEMP_NAME)
      expect(item).to be_empty
    end
  end

end
