require 'spec_helper'

RSpec.describe OneviewSDK::FirmwareBundle do
  include_context 'shared context'

  describe '#add' do
    it 'fails if the file does not exist' do
      expect { described_class.add(@client, 'file.fake') }.to raise_error(OneviewSDK::NotFound, //)
    end

    it 'returns a FirmwareDriver resource' do
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(FakeResponse.new({}))
      allow(@client).to receive(:response_handler).and_return(uri: '/rest/firmware-drivers/f1')
      allow(File).to receive('file?').and_return(true)
      allow(UploadIO).to receive(:new).and_return('FAKE FILE CONTENT')
      expect(OneviewSDK::FirmwareBundle).to receive(:add).and_return(OneviewSDK::FirmwareDriver)
      OneviewSDK::FirmwareBundle.add(@client, 'file.tar')
    end
  end
end
