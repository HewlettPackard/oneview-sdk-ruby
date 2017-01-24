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

klass = OneviewSDK::ImageStreamer::API300::OsVolumes
RSpec.describe klass, integration_i3s: true, type: DELETE do
  include_context 'integration i3s api300 context'

  describe '#delete' do
    it 'raises MethodUnavailable' do
      item = klass.new($client_i3s_300)
      expect { item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end
end
