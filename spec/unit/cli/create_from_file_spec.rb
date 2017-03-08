require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'
  include_context 'shared context'

  describe '#create_from_file' do
    let(:yaml_file) { 'spec/support/fixtures/unit/cli/ethernet_network1.yml' }
    let(:json_file) { 'spec/support/fixtures/unit/cli/ethernet_network1.json' }

    context 'with invalid options' do
      it 'requires a file name' do
        expect { OneviewSDK::Cli.start(['create_from_file']) }
          .to output(/was called with no arguments\sUsage:/).to_stderr_from_any_process
      end
    end

    context 'with valid options' do
      before :each do
        @resource_data = { 'name' => 'My', 'uri' => '/rest/fake', 'description' => 'Blah' }
        response = [OneviewSDK::EthernetNetwork.new(@client_200, @resource_data)]
        allow(OneviewSDK::Resource).to receive(:find_by).and_return(response)
        allow_any_instance_of(OneviewSDK::Resource).to receive(:create).and_return(true)
        allow_any_instance_of(OneviewSDK::Resource).to receive(:update).and_return(true)
      end

      it 'creates a valid resource by name' do
        allow(OneviewSDK::Resource).to receive(:find_by).and_return([])
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file]) }
          .to output(/Created Successfully!/).to_stdout_from_any_process
      end

      it 'updates a valid resource by name' do
        resource_data = { 'name' => 'My_Ethernet_Network', 'description' => 'Blah' }
        response = [OneviewSDK::EthernetNetwork.new(@client_200, resource_data)]
        allow(OneviewSDK::Resource).to receive(:find_by).and_return(response)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file]) }
          .to output(/Updated Successfully!/).to_stdout_from_any_process
      end

      it 'makes no changes if the resource is up to date' do
        resource_data = { 'name' => 'My_Ethernet_Network', 'description' => 'Short Description' }
        response = [OneviewSDK::EthernetNetwork.new(@client_200, resource_data)]
        allow(OneviewSDK::Resource).to receive(:find_by).and_return(response)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file]) }
          .to output(/Skipped.*up to date/).to_stdout_from_any_process
      end

      it 'respects the if_missing option' do
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file, '-i']) }
          .to output(/Skipped/).to_stdout_from_any_process
      end

      it 'fails if the file does not exist' do
        expect(STDOUT).to receive(:puts).with(/No such file/)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file + '.yml']) }
          .to raise_error SystemExit
      end

      it 'fails if the resource is a generic "Resource" type' do
        resource = OneviewSDK::Resource.new(@client_200)
        allow(OneviewSDK::Resource).to receive(:from_file).and_return(resource)
        expect(STDOUT).to receive(:puts).with(/Failed to determine resource type/)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file]) }
          .to raise_error SystemExit
      end

      it 'fails if the file does not specify a unique identifier' do
        resource = OneviewSDK::EthernetNetwork.new(@client_200)
        allow(OneviewSDK::Resource).to receive(:from_file).and_return(resource)
        expect(STDOUT).to receive(:puts).with(/Must set/)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file]) }
          .to raise_error SystemExit
      end

      it 'shows the resource creation error message on failure' do
        allow_any_instance_of(OneviewSDK::Resource).to receive(:create).and_raise('Explanation')
        allow(OneviewSDK::Resource).to receive(:find_by).and_return([])
        expect(STDOUT).to receive(:puts).with(/Failed to create.*Explanation/)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file]) }
          .to raise_error SystemExit
      end

      it 'shows the resource update error message on failure' do
        allow_any_instance_of(OneviewSDK::Resource).to receive(:update).and_raise('Explanation')
        expect(STDOUT).to receive(:puts).with(/Failed to update.*Explanation/)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file]) }
          .to raise_error SystemExit
      end
    end

  end
end
