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

require_relative '../../_client' # Gives access to @client

type = 'SAS Logical Interconnect Group'

options = {
  name: 'ONEVIEW_SDK_TEST_SAS_LIG'
}

lig = OneviewSDK::API300::Synergy::SASLogicalInterconnectGroup.new(@client, options)

# Add the interconnects to the bays 1 and 4
lig.add_interconnect(1, @sas_interconnect_type)
lig.add_interconnect(4, @sas_interconnect_type)

lig.create!
puts "\n#{type} #{lig[:name]} created!"

options2 = {
  name: 'UPDATED_ONEVIEW_SDK_TEST_SAS_LIG '
}

lig.update(options2)
puts "#{type} updated data:\n\n #{lig.data} \n  "

# Clean up after ourselves
puts "\n Deleting #{type} '#{lig[:name]}' now..."
lig.delete
