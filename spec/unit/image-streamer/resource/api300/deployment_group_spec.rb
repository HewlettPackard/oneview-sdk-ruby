require 'spec_helper'

RSpec.describe OneviewSDK::ImageStreamer::API300::DeploymentGroup do
  include_context 'shared context'

  subject(:deployment_group) { described_class.new(@client_i3s_300) }

  describe '#create' do
    it 'should throw unavailable exception' do
      expect { deployment_group.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#update' do
    it 'should throw unavailable exception' do
      expect { deployment_group.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#delete' do
    it 'should throw unavailable exception' do
      expect { deployment_group.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '::BASE_URI' do
    it { expect(described_class::BASE_URI).to eq('/rest/deployment-groups') }

    it 'can not be modified' do
      expect { described_class::BASE_URI << 'some string' }.to raise_error(/can't modify frozen String/)
    end
  end
end
