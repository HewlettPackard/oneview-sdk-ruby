require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'
  include_context 'shared context'

  describe '#delete_from_file' do
    let(:yaml_file) { 'spec/support/fixtures/unit/cli/ethernet_network1.yml' }
    let(:json_file) { 'spec/support/fixtures/unit/cli/ethernet_network1.json' }

    context 'with invalid options' do
      it 'requires a file name' do
        expect { OneviewSDK::Cli.start(['delete_from_file']) }
          .to output(/was called with no arguments*\sUsage:/).to_stderr_from_any_process
      end
    end

    context 'with valid options' do
      before :each do
        @resource_data = { 'name' => 'My', 'uri' => '/rest/fake', 'description' => 'Blah' }
        response = [OneviewSDK::EthernetNetwork.new(@client, @resource_data)]
        allow(OneviewSDK::Resource).to receive(:find_by).and_return(response)
        allow_any_instance_of(OneviewSDK::Resource).to receive(:delete).and_return(true)
        allow_any_instance_of(OneviewSDK::Resource).to receive(:retrieve!).and_return(true)
        allow_any_instance_of(OneviewSDK::Resource).to receive(:refresh).and_return(true)
        allow_any_instance_of(HighLine).to receive(:agree).and_return(true)
      end

      it 'deletes a valid resource by name' do
        allow_any_instance_of(OneviewSDK::Resource).to receive(:refresh).and_return(false)
        expect_any_instance_of(HighLine).to receive(:agree)
        expect { OneviewSDK::Cli.start(['delete_from_file', yaml_file]) }
          .to output(/Deleted Successfully!/).to_stdout_from_any_process
      end

      it 'deletes a valid resource by uri' do
        allow_any_instance_of(OneviewSDK::Resource).to receive(:retrieve!).and_return(false)
        expect_any_instance_of(HighLine).to receive(:agree)
        expect { OneviewSDK::Cli.start(['delete_from_file', json_file]) }
          .to output(/Deleted Successfully!/).to_stdout_from_any_process
      end

      it 'respects the force option' do
        expect_any_instance_of(HighLine).to_not receive(:agree)
        expect { OneviewSDK::Cli.start(['delete_from_file', yaml_file, '-f']) }
          .to output(/Deleted Successfully!/).to_stdout_from_any_process
      end

      it 'fails if the resource can not be found' do
        allow_any_instance_of(OneviewSDK::Resource).to receive(:retrieve!).and_return(false)
        allow_any_instance_of(OneviewSDK::Resource).to receive(:refresh).and_return(false)
        expect(STDOUT).to receive(:puts).with(/Not Found/)
        expect { OneviewSDK::Cli.start(['delete_from_file', yaml_file, '-f']) }
          .to raise_error SystemExit
      end

      it 'fails if the file does not exist' do
        expect { OneviewSDK::Cli.start(['delete_from_file', yaml_file + '.yml', '-f']) }
          .to raise_error(/No such file or directory/)
      end

      it 'fails if the file does not specify a name or uri' do
        resource = OneviewSDK::Resource.new(@client)
        allow(OneviewSDK::Resource).to receive(:from_file).and_return(resource)
        expect(STDOUT).to receive(:puts).with(/must define name or uri/)
        expect { OneviewSDK::Cli.start(['delete_from_file', yaml_file, '-f']) }
          .to raise_error SystemExit
      end

      it 'exits if the user does not agree to the prompt' do
        allow_any_instance_of(HighLine).to receive(:agree).and_return(false)
        expect_any_instance_of(HighLine).to receive(:agree)
        expect(STDOUT).to receive(:puts).with(/OK, exiting./)
        OneviewSDK::Cli.start(['delete_from_file', yaml_file])
      end

      it 'fails if deletion fails' do
        allow_any_instance_of(OneviewSDK::Resource).to receive(:delete).and_raise 'Failure'
        expect(STDOUT).to receive(:puts).with(/Failed to delete/)
        expect { OneviewSDK::Cli.start(['delete_from_file', yaml_file, '-f']) }
          .to raise_error SystemExit
      end
    end

  end
end
