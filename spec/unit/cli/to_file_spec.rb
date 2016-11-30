require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'
  include_context 'shared context'

  describe '#to_file' do
    let(:path) { 'spec/support/fixtures/unit/cli/should_not_exist.yml' }
    let(:path) { 'spec/support/fixtures/unit/cli/ethernet_network2.yml' }

    context 'with invalid options' do
      it 'requires a type' do
        expect { OneviewSDK::Cli.start(['to_file', '-p', path]) }
          .to output(/was called with no arguments/).to_stderr_from_any_process
      end

      it 'requires a valid type' do
        expect(STDOUT).to receive(:puts).with(/Invalid resource type/)
        expect { OneviewSDK::Cli.start(['to_file', 'FakeType', 'Test', '-p', path]) }
          .to raise_error SystemExit
      end

      it 'requires a name' do
        expect { OneviewSDK::Cli.start(['to_file', 'EthernetNetwork', '-p', path]) }
          .to output(/was called with arguments/).to_stderr_from_any_process
      end

      it 'requires a path' do
        expect { OneviewSDK::Cli.start(['to_file']) }
          .to output(/No value provided for required options '--path'/).to_stderr_from_any_process
      end

      it 'fails if the resource does not exist' do
        allow(OneviewSDK::Resource).to receive(:find_by).and_return([])
        expect(STDOUT).to receive(:puts).with(/EthernetNetwork 'Fake' not found/)
        expect { OneviewSDK::Cli.start(['to_file', 'Ethernetnetwork', 'Fake', '-p', path]) }
          .to raise_error SystemExit
      end
    end

    context 'with valid options' do
      before :each do
        @resource_data = { 'name' => 'Test', 'uri' => '/rest/fake' }
        @response = [OneviewSDK::EthernetNetwork.new(@client, @resource_data)]
        allow(OneviewSDK::Resource).to receive(:find_by).and_return(@response)
      end

      it 'creates the specified file' do
        expect_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:to_file)
          .with(File.expand_path(path), 'json').and_return(true)
        expect { OneviewSDK::Cli.start(['to_file', 'EthernetNetwork', 'Test', '-p', path]) }
          .to output(/Output to/).to_stdout_from_any_process
      end

      it 'accepts a format parameter' do
        expect_any_instance_of(OneviewSDK::Resource).to receive(:to_file)
          .with(File.expand_path(path), 'yaml').and_return(true)
        expect { OneviewSDK::Cli.start(['to_file', 'EthernetNetwork', 'Test', '-p', path, '-f', 'yaml']) }
          .to output(/Output to/).to_stdout_from_any_process
      end

      it 'accepts an api-version parameter: 200' do
        expect_any_instance_of(OneviewSDK::API200::EthernetNetwork).to receive(:to_file).and_return(true)
        expect { OneviewSDK::Cli.start(['to_file', 'EthernetNetwork', 'Test', '-p', path, '--api-version', 200]) }
          .to output(/Output to/).to_stdout_from_any_process
      end

      it 'accepts an api-version parameter: 300' do
        @response = [OneviewSDK::API300::EthernetNetwork.new(@client, @resource_data)]
        expect(OneviewSDK::Resource).to receive(:find_by).and_return(@response)
        expect_any_instance_of(OneviewSDK::API300::EthernetNetwork).to receive(:to_file).and_return(true)
        expect { OneviewSDK::Cli.start(['to_file', 'EthernetNetwork', 'Test', '-p', path, '--api-version', 300]) }
          .to output(/Output to/).to_stdout_from_any_process
      end

      it 'shows the file save error message on failure' do
        expect_any_instance_of(OneviewSDK::Resource).to receive(:to_file).and_raise(Errno::ENOENT, 'Explanation')
        expect(STDOUT).to receive(:puts).with(/Failed to create file.*Explanation/)
        expect { OneviewSDK::Cli.start(['to_file', 'EthernetNetwork', 'Test', '-p', path]) }
          .to raise_error SystemExit
      end
    end

  end
end
