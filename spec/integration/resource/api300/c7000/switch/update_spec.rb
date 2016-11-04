require 'spec_helper'

klass = OneviewSDK::API300::C7000::Switch
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#patch' do
    it 'replaces the switch scopeUris' do
      item = klass.find_by($client_300, {}).first
      item.retrieve!
      expect { item.set_scope_uris(item['scopeUris']) }.not_to raise_error
    end
  end
end
