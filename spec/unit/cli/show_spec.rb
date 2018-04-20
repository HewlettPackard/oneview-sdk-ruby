require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'
  include_context 'shared context'

  describe '#show' do

    context 'with invalid options' do
      it 'requires a type' do
        expect { OneviewSDK::Cli.start(['show']) }
          .to output(/called with no arguments/).to_stderr_from_any_process
      end

      it 'requires a valid type' do
        expect(STDOUT).to receive(:puts).with(/Invalid resource type/)
        expect { OneviewSDK::Cli.start(%w[show InvalidType name]) }.to raise_error SystemExit
      end

      it 'requires a resource name' do
        expect { OneviewSDK::Cli.start(%w[show ServerProfiles]) }
          .to output(/was called with arguments.*\sUsage:/).to_stderr_from_any_process
      end
    end

    before :each do
      @resource_data = { 'name' => 'Profile1', 'uri' => '/rest/fake', 'description' => 'Blah', 'x' => { 'y' => 'z', 'a' => 'b' } }
      response = [OneviewSDK::Resource.new(@client_200, @resource_data)]
      allow(OneviewSDK::Resource).to receive(:find_by).and_return(response)
    end

    context '(unfiltered)' do
      it 'prints the resource details' do
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, name: 'Profile1')
        expect { OneviewSDK::Cli.start(%w[show ServerProfile Profile1]) }
          .to output(%r{^name: Profile1\suri: \/rest\/fake\sdescription: Blah$}).to_stdout_from_any_process
      end

      it 'prints the resource details in json format' do
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, name: 'Profile1')
        expect { OneviewSDK::Cli.start(%w[show ServerProfile Profile1 -f json]) }
          .to output(JSON.pretty_generate(@resource_data) + "\n").to_stdout_from_any_process
      end

      it 'prints the resource details in yaml format' do
        expect(OneviewSDK::Resource).to receive(:find_by).with(OneviewSDK::Client, name: 'Profile1')
        expect { OneviewSDK::Cli.start(%w[show ServerProfile Profile1 -f yaml]) }
          .to output(@resource_data.to_yaml).to_stdout_from_any_process
      end
    end

    context 'with attribute param' do
      it 'only outputs the specified attribute details' do
        expect { OneviewSDK::Cli.start(%w[show ServerProfile Profile1 -a uri,name]) }
          .to output(%r{^uri: \/rest\/fake\sname: Profile1$}).to_stdout_from_any_process
      end

      it 'supports nested attributes' do
        out = JSON.pretty_generate(name: 'Profile1', x: { y: 'z' }) + "\n"
        expect { OneviewSDK::Cli.start(%w[show ServerProfile Profile1 -a name,x.y -f json]) }
          .to output(out).to_stdout_from_any_process
      end

      it 'supports missing nested attributes' do
        out = JSON.pretty_generate(a: { b: { '1' => nil } }) + "\n"
        expect { OneviewSDK::Cli.start(%w[show ServerProfile Profile1 -a a.b.1 -f json]) }
          .to output(out).to_stdout_from_any_process
      end
    end

  end
end
