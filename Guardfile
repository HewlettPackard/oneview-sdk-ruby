# (c) Copyright 2021 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

guard :rubocop, cmd: 'bundle exec rubocop', cli: ['-D'] do
  watch('.rubocop.yml')
  watch(/(.+\.rb)$/)
  watch(/^(Gemfile|Rakefile)$/)
end

guard :rspec, cmd: 'bundle exec rspec --color -t ~integration', first_match: true do
  watch(%r{^spec\/(\w+)\.rb$}) { 'spec/unit' }
  watch(%r{^(spec\/unit\/.+_spec\.rb)$})
  watch('lib/oneview-sdk/cli.rb') { 'spec/unit/cli' }
  watch(%r{^lib\/oneview-sdk\/(.+)\.rb$}) { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch(%r{^(spec\/support\/\w+\.rb)$}) { 'spec/unit' }
  watch(%r{^spec\/support\/fixtures\/unit\/(\w+)\/.+$}) { |m| "spec/unit/#{m[1]}" }
  watch(%r{^lib\/(.+)\.rb$}) { 'spec/unit' } # Everything else
end
