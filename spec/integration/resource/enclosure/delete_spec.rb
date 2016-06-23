require 'spec_helper'

klass = OneviewSDK::Enclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::Enclosure.find_by($client, 'name' => ENCL_NAME).first
      item.delete
    end
  end
end
