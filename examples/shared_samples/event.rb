# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '../_client' # Gives access to @client

# All supported APIs for Event:
# - API200 for C7000 and Synergy
# - API300 for C7000 and Synergy

# Resources classes that you can use for Event in this example:
# event_class = OneviewSDK::API200::Event
# event_class = OneviewSDK::API300::C7000::Event
# event_class = OneviewSDK::API300::Synergy::Event
event_class = OneviewSDK.resource_named('Event', @client.api_version)

options = {
  eventTypeID: 'source-test.event-id',
  description: 'This is a very simple test event',
  serviceEventSource: true,
  urgency: 'None',
  severity: 'OK',
  healthCategory: 'PROCESSOR',
  eventDetails: [
    {
      eventItemName: 'ipv4Address',
      eventItemValue: '172.16.10.81',
      isThisVarbindData: false,
      varBindOrderIndex: -1
    }
  ]
}

event = event_class.new(@client, options)
event.create
puts "\nEvent added successfully."

puts "\nGet all events:"
event_class.get_all(@client).each do |item|
  puts item.data
end
