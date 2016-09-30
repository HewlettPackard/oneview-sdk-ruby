require 'spec_helper'

RSpec.describe OneviewSDK::Cli do
  include_context 'cli context'
  include_context 'shared context'

  describe '#update' do

    let(:data) do
      { 'name' => 'SP_1', 'description' => 'NewBlah' }
    end

    let(:resource_data) do
      { 'name' => 'SP1', 'uri' => '/rest/fake', 'description' => 'Blah' }
    end

    let(:sp1) do
      OneviewSDK::ServerProfile.new(@client, resource_data)
    end

    let(:sp_list) do
      [sp1]
    end

    context 'with invalid options' do
      it 'requires a type' do
        expect { described_class.start(%w(update)) }
          .to output(/called with no arguments/).to_stderr_from_any_process
      end

      it 'requires a valid type' do
        expect(STDOUT).to receive(:puts).with(/Invalid resource type/)
        expect { described_class.start(%w(update InvalidType Name)) }.to raise_error SystemExit
      end

      it 'requires a name' do
        expect { described_class.start(%w(update ServerProfile)) }
          .to output(/called with arguments/).to_stderr_from_any_process
      end

      it 'requires the hash or json option' do
        expect($stdout).to receive(:puts).with(/Must set the hash or json option/)
        expect { described_class.start(%w(update ServerProfile SP1)) }
          .to raise_error SystemExit
      end

      it 'requires the json to be valid' do
        expect($stdout).to receive(:puts).with(/Failed to parse json/)
        expect { described_class.start(%w(update ServerProfile SP1 -j invalid_json)) }
          .to raise_error SystemExit
      end
    end

    it 'fails if no match is found' do
      expect(OneviewSDK::ServerProfile).to receive(:find_by).with(instance_of(OneviewSDK::Client), name: 'SP_2')
        .and_return []
      expect($stdout).to receive(:puts).with(/Not Found/)
      expect { described_class.start(%w(update ServerProfile SP_2 -h name:SP2)) }
        .to raise_error SystemExit
    end

    it 'parses hash data' do
      expect(OneviewSDK::ServerProfile).to receive(:find_by).with(instance_of(OneviewSDK::Client), name: sp1['name'])
        .and_return sp_list
      expect(sp1).to receive(:update).with(data).and_return true
      expect { described_class.start(%w(update ServerProfile SP1 -h name:SP_1 description:NewBlah)) }
        .to output(/Successfully/).to_stdout_from_any_process
    end

    it 'parses json data' do
      expect(OneviewSDK::ServerProfile).to receive(:find_by).with(instance_of(OneviewSDK::Client), name: sp1['name'])
        .and_return sp_list
      expect(sp1).to receive(:update).with(data).and_return true
      expect { described_class.start(['update', 'ServerProfile', 'SP1', '-j', data.to_json]) }
        .to output(/Successfully/).to_stdout_from_any_process
    end

    it 'prints out error messages' do
      expect(OneviewSDK::ServerProfile).to receive(:find_by).with(instance_of(OneviewSDK::Client), name: sp1['name'])
        .and_return sp_list
      expect(sp1).to receive(:update).with(data).and_raise(OneviewSDK::BadRequest, 'Reason')
      expect($stdout).to receive(:puts).with(/Reason/)
      expect { described_class.start(['update', 'ServerProfile', 'SP1', '-j', data.to_json]) }
        .to raise_error SystemExit
    end
  end
end
