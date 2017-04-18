# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '_client' # Gives access to @client

# You can create a connection to the SCMB very easily; your client object has everything
# the ::new_connection method needs to connect:
connection = OneviewSDK::SCMB.new_connection(@client)

# The ::new_connection method above does some setup tasks for you if needed, including
# creating a keypair for the default RabbitMQ user on OneView (rabitmq_readonly)

# Now you can create a queue that will be used to subscribe to messages. By default it
# will use the least specific routing key possible, so it will respond to ALL events:
q = OneviewSDK::SCMB.new_queue(connection)
puts "Created queue: #{q.name}"

# More likely, you'll want to subscribe to a smaller subset of events. For example, to
# subscribe to only messages posted when an ethernet network is created:
eth_create_q = OneviewSDK::SCMB.new_queue(connection, 'scmb.ethernet-networks.Created.#')
puts "Created queue: #{eth_create_q.name}\n\n"

# Here are some other routing key options for the ethernet network resource:
# 'scmb.ethernet-networks.#' -> Any ethernet network event
# 'scmb.ethernet-networks.Updated.<resource_uri>' -> Only when a specific network is updated

puts 'Subscribing to OneView messages. To exit, press Ctrl + c'

# Then when you're ready to start listening, subscribe to a queue. Here we'll just print
# out the message, but you'll insert your own logic in the block below. Also, see
# http://rubybunny.info/articles/queues.html for more details & options.
q.subscribe(block: true) do |_delivery_info, _properties, payload|
  data = JSON.parse(payload) rescue payload
  puts 'Received message with payload:'
  pp data # Pretty print
  puts "\n#{'=' * 50}\n"
end
