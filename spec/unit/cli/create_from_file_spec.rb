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
          .to output(/was called with no arguments*\sUsage:/).to_stderr_from_any_process
      end

      it 'does not allow both the if_missing and force options' do
        expect(STDOUT).to receive(:puts).with(/flags at the same time/)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file, '-f', '-i']) }
          .to raise_error SystemExit
      end
    end

    context 'with valid options' do
      before :each do
        @resource_data = { 'name' => 'My', 'uri' => '/rest/fake', 'description' => 'Blah' }
        response = [OneviewSDK::EthernetNetwork.new(@client, @resource_data)]
        allow(OneviewSDK::BaseResource).to receive(:find_by).and_return(response)
        allow_any_instance_of(OneviewSDK::BaseResource).to receive(:create).and_return(true)
        allow_any_instance_of(OneviewSDK::BaseResource).to receive(:update).and_return(true)
      end

      it 'creates a valid resource by name' do
        allow(OneviewSDK::BaseResource).to receive(:find_by).and_return([])
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file]) }
          .to output(/Created Successfully!/).to_stdout_from_any_process
      end

      it 'respects the force option for overrides' do
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file, '-f']) }
          .to output(/Updated Successfully!/).to_stdout_from_any_process
      end

      it 'respects the if_missing option' do
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file, '-i']) }
          .to output(/Skipped/).to_stdout_from_any_process
      end

      it 'fails if the resource already exists' do
        expect(STDOUT).to receive(:puts).with(/already exists/)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file]) }
          .to raise_error SystemExit
      end

      it 'fails if the file does not exist' do
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file + '.yml', '-f']) }
          .to raise_error(/No such file or directory/)
      end

      it 'fails if the file does not specify a name' do
        resource = OneviewSDK::BaseResource.new(@client)
        allow(OneviewSDK::BaseResource).to receive(:from_file).and_return(resource)
        expect(STDOUT).to receive(:puts).with(/must specify a resource name/)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file, '-f']) }
          .to raise_error SystemExit
      end

      it 'shows the resource creation error message on failure' do
        allow_any_instance_of(OneviewSDK::BaseResource).to receive(:create).and_raise('Explanation')
        allow(OneviewSDK::BaseResource).to receive(:find_by).and_return([])
        expect(STDOUT).to receive(:puts).with(/Failed to create.*Explanation/)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file]) }
          .to raise_error SystemExit
      end

      it 'shows the resource update error message on failure' do
        allow_any_instance_of(OneviewSDK::BaseResource).to receive(:update).and_raise('Explanation')
        expect(STDOUT).to receive(:puts).with(/Failed to update.*Explanation/)
        expect { OneviewSDK::Cli.start(['create_from_file', yaml_file, '-f']) }
          .to raise_error SystemExit
      end
    end

  end
end
