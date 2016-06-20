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

require_relative '_client' # Gives access to @client

all_fabrics = OneviewSDK::Fabric.find_by(@client, {})

puts "\n\n### Here are all fabrics available:"
all_fabrics.each do |fabric|
  puts fabric['name']
end

fabric2 = OneviewSDK::Fabric.new(@client, 'name' => 'DefaultFabric')
puts "\n\n### Retrieving the Fabric named: #{fabric2['name']}"
fabric2.retrieve!
puts JSON.pretty_generate(fabric2.data)
