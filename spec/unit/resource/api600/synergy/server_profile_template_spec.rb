require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::ServerProfileTemplate do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::ServerProfileTemplate' do
    expect(described_class).to be < OneviewSDK::API500::C7000::ServerProfileTemplate
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      item = described_class.new(@client_500, name: 'server_profile_template')
      expect(item[:type]).to eq('ServerProfileTemplateV3')
    end
  end

  describe '#set_os_deployment_settings' do
    let(:item) { described_class.new(@client_500, name: 'server_profile_template') }
    let(:os_deployment_plan_class) { OneviewSDK::API500::Synergy::OSDeploymentPlan }
    let(:os_deployment_plan) { os_deployment_plan_class.new(@client_500, uri: '/os-deployment-plan/1') }

    it 'should populate osDeploymentSettings attribute correctly' do
      custom_attrs = [{ name: 'field.one', value: 'value1' }, { name: 'field.two', value: 'value2' }]
      allow_any_instance_of(os_deployment_plan_class).to receive(:retrieve!).and_return(true)
      expect(item['osDeploymentSettings']).not_to be

      item.set_os_deployment_settings(os_deployment_plan, custom_attrs)

      expected_settings = { 'osDeploymentPlanUri' => '/os-deployment-plan/1', 'osCustomAttributes' => custom_attrs }
      expect(item['osDeploymentSettings']).to eq(expected_settings)
    end

    context 'when osDeploymentSettings already populated' do
      it 'should change the values' do
        custom_attrs = [{ name: 'field.one', value: 'value1' }, { name: 'field.two', value: 'value2' }]
        settings = { 'osDeploymentPlanUri' => '/fake/uri', 'osCustomAttributes' => custom_attrs }
        item['osDeploymentSettings'] = settings
        allow_any_instance_of(os_deployment_plan_class).to receive(:retrieve!).and_return(true)

        item.set_os_deployment_settings(os_deployment_plan, [{ name: 'new_name', value: 'new_value' }])

        expected_settings = { 'osDeploymentPlanUri' => '/os-deployment-plan/1', 'osCustomAttributes' => [{ name: 'new_name', value: 'new_value' }] }
        expect(item['osDeploymentSettings']).to eq(expected_settings)
      end
    end

    context 'when os_deployment_plan has not URI' do
      it 'should throw IncompleteResource error' do
        wrong_os_deployment_plan = os_deployment_plan_class.new(@client_500)
        allow_any_instance_of(os_deployment_plan_class).to receive(:retrieve!).and_return(false)
        expect { item.set_os_deployment_settings(wrong_os_deployment_plan) }.to raise_error(/OS Deployment Plan not found/)
      end
    end
  end
end
