require 'spec_helper'

klass = OneviewSDK::Enclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#remove' do
    it 'removes the resource' do
      item = OneviewSDK::Enclosure.find_by($client, 'name' => ENCL_NAME).first
      expect { item.remove }.not_to raise_error
    end
  end
end
