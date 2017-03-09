require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'

  describe '#console' do
    let(:command) { OneviewSDK::Cli.start(['console']) }

    context 'with a valid @client_200 object' do
      it 'starts a Pry session' do
        expect(Pry).to receive(:start).and_return true
        expect(STDOUT).to receive(:puts).with(/Console Connected to/)
        expect(STDOUT).to receive(:puts).with(/HINT: The @client_200 object is available to you/)
        allow_any_instance_of(Object).to receive(:warn).with(/was not found/).and_return true
        command
      end
    end

    context 'with no @client_200 object' do
      it 'starts a Pry session' do
        expect(OneviewSDK::Client).to receive(:new).and_raise 'Error'
        expect(Pry).to receive(:start).and_return true
        expect(STDOUT).to receive(:puts).with(/WARNING: Couldn't connect to/)
        allow_any_instance_of(Object).to receive(:warn).with(/was not found/).and_return true
        command
      end
    end
  end
end
