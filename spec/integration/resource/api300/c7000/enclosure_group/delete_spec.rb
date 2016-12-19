require 'spec_helper'

klass = OneviewSDK::API300::C7000::EnclosureGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#delete' do
    it 'deletes the simple enclosure group' do
      item = klass.new($client_300, 'name' => ENC_GROUP_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end

    it 'deletes the enclosure group with LIG' do
      item = klass.new($client_300, 'name' => ENC_GROUP2_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end

    it 'deletes the enclosure group with empty LIG' do
      item = klass.new($client_300, 'name' => ENC_GROUP3_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end
  end
end
