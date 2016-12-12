# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

klass = OneviewSDK::API300::Synergy::SASLogicalInterconnectGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  before :all do
    sas_lig_default_options = {
      'name' => SAS_LOG_INT_GROUP1_NAME
    }
    @item = klass.new($client_300_synergy, sas_lig_default_options)
  end

  let(:sas_interconnect_type) { 'Synergy 12Gb SAS Connection Module' }

  describe '#create' do
    before(:all) do
      @item.delete if @item.retrieve!
    end

    it 'raises an error when adding an unrecognized interconnect type' do
      expect { @item.add_interconnect(1, 'invalid_type') }.to raise_error(/SAS Interconnect type 'invalid_type' not found!/)
    end

    it 'SAS LIG' do
      @item.add_interconnect(1, sas_interconnect_type)
      @item.add_interconnect(4, sas_interconnect_type)
      expect { @item.create }.not_to raise_error
      expect(@item['uri']).to be
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      sas_lig_default_options = {
        'name' => SAS_LOG_INT_GROUP1_NAME
      }
      @item = klass.new($client_300_synergy, sas_lig_default_options)
      @item.retrieve!
      expect(@item['uri']).to be
    end
  end
end
