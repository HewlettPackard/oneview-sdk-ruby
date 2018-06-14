# (C) Copyright 2018 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'spec_helper'

RSpec.describe OneviewSDK::Alerts do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      alerts = described_class.new(@client_200)
      expect(alerts['type']).to eq('AlertResourceCollectionV3')
    end
  end

   describe '#update' do
    it 'should update the attributes' do
      alerts = described_class.new(@client_200)
      uri = nil 
      header = {'requestername': 'DEFAULT'} 
      fake_response = FakeResponse.new
      expected_options = {
        'requestername' => 'DEFAULT',
        'body' => {
          'assignedToUser' => 'Paul',
        }
      }
      expected_api_version = @client_200.api_version
      expect(@client_200).to receive(:rest_put).with(uri, expected_options, expected_api_version).and_return(fake_response)
      alerts.update({ assignedToUser: 'Paul' }, header)
      expect(alerts['assignedToUser']).to eq('Paul')
    end
  end
end
