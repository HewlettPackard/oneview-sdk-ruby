require 'spec_helper'

RSpec.describe OneviewSDK::FirmwareBundle do
  include_context 'shared context'

  describe '#add' do
    it 'fails if the file does not exist' do
      expect { described_class.add(@client, 'file.fake') }.to raise_error(OneviewSDK::NotFound, //)
    end

    it 'returns a FirmwareDriver resource' do
      expect(@client).to receive(:rest_post).with(
        OneviewSDK::FirmwareBundle::BASE_URI,
        hash_including(
          'body' => %r{Content-Type: application/octet-stream; Content-Transfer-Encoding: binary\r\n\r\nFAKE FILE CONTENT\r\n--},
          'uploadfilename' => 'file.tar',
          'Content-Type' => "multipart/form-data; boundary=#{OneviewSDK::FirmwareBundle::BOUNDARY}"
        )
      ).and_return(FakeResponse.new({}))
      expect(File).to receive('file?').and_return(true)
      allow(IO).to receive(:binread).and_return('FAKE FILE CONTENT')
      OneviewSDK::FirmwareBundle.add(@client, 'file.tar')
    end
  end
end
