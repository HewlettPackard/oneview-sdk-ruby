require 'spec_helper'

RSpec.describe OneviewSDK::Enclosure, integration: true, type: DELETE, sequence: 9 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::Enclosure.find_by($client, 'name' => ENCL_NAME).first
      item.delete
    end
  end
end
