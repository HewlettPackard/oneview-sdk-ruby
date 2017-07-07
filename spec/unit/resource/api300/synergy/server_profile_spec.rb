require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::ServerProfile do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::ServerProfile
  end

  before :each do
    @item = described_class.new(@client_300, name: 'unit_server_profile', uri: 'rest/server-profiles/fake')
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      profile = OneviewSDK::API300::Synergy::ServerProfile.new(@client_300)
      expect(profile[:type]).to eq('ServerProfileV6')
    end
  end

  describe '#get_sas_logical_jbod_attachment' do
    it 'finds the specified attachment' do
      attachment_list = FakeResponse.new(
        'members' => [
          { 'name' => 'Attachment1', 'uri' => 'rest/fake/1' },
          { 'name' => 'Attachment2', 'uri' => 'rest/fake/2' },
          { 'name' => 'Attachment3', 'uri' => 'rest/fake/3' }
        ]
      )
      expect(@client_300).to receive(:rest_get).with('/rest/sas-logical-jbod-attachments').and_return(attachment_list)
      item = OneviewSDK::API300::Synergy::ServerProfile.get_sas_logical_jbod_attachment(@client_300, 'Attachment2')
      expect(item['uri']).to eq('rest/fake/2')
    end
  end

  describe '#get_sas_logical_jbod' do
    it 'finds the specified resource' do
      list = FakeResponse.new(
        'members' => [
          { 'name' => 'SAS_LOGICAL_JBOD1', 'uri' => 'rest/fake/1' },
          { 'name' => 'SAS_LOGICAL_JBOD2', 'uri' => 'rest/fake/2' },
          { 'name' => 'SAS_LOGICAL_JBOD3', 'uri' => 'rest/fake/3' }
        ]
      )
      expect(@client_300).to receive(:rest_get).with('/rest/sas-logical-jbods').and_return(list)
      item = OneviewSDK::API300::Synergy::ServerProfile.get_sas_logical_jbod(@client_300, 'SAS_LOGICAL_JBOD2')
      expect(item['uri']).to eq('rest/fake/2')
    end
  end

  describe '#get_sas_logical_jbod_drives' do
    it 'should list all the SASLogicalJBOD drives' do
      list = FakeResponse.new('members' => [{ 'name' => 'SAS_LOGICAL_JBOD1', 'uri' => '/rest/fake/1' }])
      allow(@client_300).to receive(:rest_get).with('/rest/sas-logical-jbods').and_return(list)
      @item = OneviewSDK::API300::Synergy::ServerProfile.get_sas_logical_jbod(@client_300, 'SAS_LOGICAL_JBOD1')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/1/drives').and_return(FakeResponse.new('it' => 'works'))
      expect(OneviewSDK::API300::Synergy::ServerProfile.get_sas_logical_jbod_drives(@client_300, 'SAS_LOGICAL_JBOD1')['it']).to eq('works')
    end
  end

  describe '#set_os_deployment_settings' do
    let(:os_deployment_plan) { OneviewSDK::API300::Synergy::OSDeploymentPlan.new(@client_300, uri: '/os-deployment-plan/1') }

    it 'should pupulate osDeploymentSettings attribute correctly' do
      custom_attrs = [{ name: 'field.one', value: 'value1' }, { name: 'field.two', value: 'value2' }]
      expect(@item['osDeploymentSettings']).not_to be

      @item.set_os_deployment_settings(os_deployment_plan, custom_attrs)

      expected_settings = { 'osDeploymentPlanUri' => '/os-deployment-plan/1', 'osCustomAttributes' => custom_attrs }
      expect(@item['osDeploymentSettings']).to eq(expected_settings)
    end

    context 'when osDeploymentSettings already populated' do
      it 'should change the values' do
        custom_attrs = [{ name: 'field.one', value: 'value1' }, { name: 'field.two', value: 'value2' }]
        settings = { 'osDeploymentPlanUri' => '/fake/uri', 'osCustomAttributes' => custom_attrs }
        @item['osDeploymentSettings'] = settings

        @item.set_os_deployment_settings(os_deployment_plan, [{ name: 'new_name', value: 'new_value' }])

        expected_settings = { 'osDeploymentPlanUri' => '/os-deployment-plan/1', 'osCustomAttributes' => [{ name: 'new_name', value: 'new_value' }] }
        expect(@item['osDeploymentSettings']).to eq(expected_settings)
      end
    end

    context 'when os_deployment_plan has not URI' do
      it 'should throw IncompleteResource error' do
        wrong_os_deployment_plan = OneviewSDK::API300::Synergy::OSDeploymentPlan.new(@client_300)
        expect { @item.set_os_deployment_settings(wrong_os_deployment_plan) }
          .to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute*/)
      end
    end
  end
end
