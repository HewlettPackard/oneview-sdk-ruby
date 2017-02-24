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

# Some of the tasks that can be performed using this library take quite a bit of time; after all,
# we are dealing with physical infrastructure. This example file shows how to take advantage
# of native Ruby features that enable you to run tasks concurrently. Note that this is a more
# advanced topic, so if you're new to Ruby, you may want to familiarize yourself with Ruby threads
# before jumping in. Also, please read the notes below about considerations that should be taken
# when using threads.


# Example: Power on all server hardware available in OneView.
# Powering on server hardware isn't necessarily a super long task, but
# doing this for 100s or 1000s of profiles will take a while if we do
# them one-at-a-time. For about 30 servers, doing them one-at-a-time
# in my environment took 360 seconds, but only 16 seconds concurrently.
# Here's how to use threads to power them all on concurrently:
servers = @client.get_all(:ServerHardware)
servers_to_power_on = servers.select { |s| s['powerState'] != 'On' }
puts "Total hardware count: #{servers.size}"
puts "Hardware count to be powered on: #{servers_to_power_on.size}\n\n"

threads = [] # Used to keep track of all the threads
servers_to_power_on.each do |s|
  threads << Thread.new do
    puts "Powering on '#{s['name']}'..."
    s.power_on
    puts "  Done powering on '#{s['name']}'"
  end
end

threads.each(&:join)
puts 'Finished powering on all server hardware!'


# NOTE: There are some considerations to be taken when using threads:
#  - Consider the number of threads you will be running at any one time. In the example
#    above, if there are 100,000 servers, it will try to power them on all at once, which
#    may bring OneView to it's knees or cause issues on your local machine (e.g., IO or network
#    overload). If the number of threads is indeterminate (like above where we did a get_all),
#    batch the tasks into more manageable groups.
#  - Consider how you will handle exceptions within threads. In the example above, any exception
#    will only be raised at the point the thread is joined. If you'd like to fail immediately on
#    any thread exception, you can set the abort_on_exception property on the thread to true.
#  - Consider resource dependencies and the linkages between them. For example, if you are
#    creating a volume template and volume that relies on that template, you need to make sure
#    that any tasks to create or update the template are finished before trying to create the volume.


# After reading those considerations, I might do something like this to power on my servers instead:
# This time I'll batch them into groups of 15. For that same 30 servers it takes 28 seconds.
servers_to_power_on.each_slice(15) do |s_batch|
  threads = []
  s_batch.each do |s|
    threads << Thread.new do
      puts "Powering on '#{s['name']}'..."
      s.power_on
      puts "  Done powering on '#{s['name']}'"
    end
  end

  threads.each(&:join)
  puts "Done with batch of 15\n\n"
end
puts 'Finished powering on all server hardware!'

# There is still plenty to learn about threads that we didn't cover here, but hopefully this gives you
# a good place to start from.
