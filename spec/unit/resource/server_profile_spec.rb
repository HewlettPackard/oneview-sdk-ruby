require 'spec_helper'

RSpec.describe OneviewSDK::ServerProfile do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 1.2' do
      it 'sets the type correctly' do
        profile = OneviewSDK::ServerProfile.new(@client_120)
        expect(profile[:type]).to eq('ServerProfileV4')
      end
    end

    context 'OneView 2.0' do
      it 'sets the type correctly' do
        profile = OneviewSDK::ServerProfile.new(@client)
        expect(profile[:type]).to eq('ServerProfileV5')
      end
    end
  end

  describe 'validations' do
    it 'allows template attributes for OneView >= 2.0' do
      options = { serverProfileTemplateUri: '/rest/fake', templateCompliance: true }
      expect { OneviewSDK::ServerProfile.new(@client, options) }.to_not raise_error
    end

    it 'only allows template uri for OneView >= 2.0' do
      options = { serverProfileTemplateUri: '/rest/fake' }
      expect { OneviewSDK::ServerProfile.new(@client_120, options) }.to raise_error(/Templates only exist on api version >= 200/)
    end

    it 'only allows template compliance attribute for OneView >= 2.0' do
      options = { templateCompliance: true }
      expect { OneviewSDK::ServerProfile.new(@client_120, options) }.to raise_error(/Templates only exist on api version >= 200/)
    end
  end
end
