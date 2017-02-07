require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::BuildPlan
RSpec.describe klass do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_i3s_300)
      expect(item['type']).to eq('OeBuildPlan')
    end
  end

  describe '#set_build_step' do
    it 'raises exception when build step without planScriptUri attribute' do
      options = [
        {
          serialNumber: '1',
          parameters: 'anystring',
          planScriptName: 'planScript1'
        }
      ]

      item = klass.new(@client_i3s_300)
      expect { item.set_build_step(options) }.to raise_error(OneviewSDK::IncompleteResource, /Please set the planScriptUri/)
    end

    it 'raises exception with nonexistent plan script ' do
      options = [
        {
          serialNumber: '1',
          parameters: 'anystring',
          planScriptName: 'planScript1',
          planScriptUri: 'rest/plan-scripts/fake/'
        }
      ]

      item = klass.new(@client_i3s_300)
      expect(OneviewSDK::ImageStreamer::API300::PlanScripts).to receive(:find_by).and_return('')
      expect { item.set_build_step(options) }.to raise_error(OneviewSDK::IncompleteResource, /could not be found!/)
    end

    it 'creates a build plan with build step' do
      options = [
        {
          serialNumber: '1',
          parameters: 'anystring',
          planScriptName: 'planScript1',
          planScriptUri: 'rest/plan-scripts/fake'
        }
      ]
      item = klass.new(@client_i3s_300)
      expect(OneviewSDK::ImageStreamer::API300::PlanScripts).to receive(:find_by)
        .and_return('uri' => 'rest/plan-scripts/fake', 'customAttributes' => [])
      item.set_build_step(options)
      expect(item['buildStep']).to_not be_empty
      expect(item['buildStep'].first[:serialNumber]).to eq('1')
      expect(item['buildStep'].first[:parameters]).to eq('anystring')
      expect(item['buildStep'].first[:planScriptName]).to eq('planScript1')
      expect(item['buildStep'].first[:planScriptUri]).to eq('rest/plan-scripts/fake')
    end
  end
end
