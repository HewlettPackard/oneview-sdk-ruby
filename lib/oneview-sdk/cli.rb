# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'thor'
require 'json'
require 'yaml'
require 'highline/import'

module OneviewSDK
  # cli for oneview-sdk
  class Cli < Thor
    # Runner class to enable testing
    class Runner
      def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
        @argv = argv
        @stdin = stdin
        @stdout = stdout
        @stderr = stderr
        @kernel = kernel
      end

      def execute!
        exit_code = begin
          $stderr = @stderr
          $stdin = @stdin
          $stdout = @stdout

          OneviewSDK::Cli.start(@argv)
          0
        rescue StandardError => e
          b = e.backtrace
          @stderr.puts("#{b.shift}: #{e.message} (#{e.class})")
          @stderr.puts(b.map { |s| "\tfrom #{s}" }.join("\n"))
          1
        rescue SystemExit => e
          e.status
        end

        # Proxy our exit code back to the injected kernel.
        @kernel.exit(exit_code)
      end
    end

    class_option :ssl_verify,
      type: :boolean,
      desc: 'Enable/Disable SSL verification for requests. Can also use ENV[\'ONEVIEWSDK_SSL_ENABLED\']',
      default: nil

    class_option :url,
      desc: 'URL of OneView appliance. Can also use ENV[\'ONEVIEWSDK_URL\']',
      aliases: '-u'

    class_option :api_version,
      type: :numeric,
      banner: 'VERSION',
      desc: 'API version to use'

    class_option :log_level,
      desc: 'Log level to use',
      aliases: '-l',
      enum: %w(debug info warn error),
      default: 'warn'

    map ['-v', '--version'] => :version


    desc 'console', 'Open a Ruby console with a connection to OneView'
    def console
      client_setup({}, true, true)
      puts "Console Connected to #{@client.url}"
      puts "HINT: The @client object is available to you\n\n"
    rescue
      puts "WARNING: Couldn't connect to #{@options['url'] || ENV['ONEVIEWSDK_URL']}\n\n"
    ensure
      require 'pry'
      Pry.config.prompt = proc { '> ' }
      Pry.plugins['stack_explorer'] && Pry.plugins['stack_explorer'].disable!
      Pry.plugins['byebug'] && Pry.plugins['byebug'].disable!
      Pry.start(OneviewSDK::Console.new(@client))
    end

    desc 'version', 'Print gem and OneView appliance versions'
    def version
      puts "Gem Version: #{OneviewSDK::VERSION}"
      client_setup({ 'log_level' => :error }, true)
      puts "OneView appliance API version at '#{@client.url}' = #{@client.max_api_version}"
    rescue StandardError, SystemExit
      puts 'OneView appliance API version unknown'
    end

    method_option :format,
      desc: 'Output format',
      aliases: '-f',
      enum: %w(json yaml human),
      default: 'human'
    desc 'env', 'Show environment variables for oneview-sdk-ruby'
    def env
      data = {}
      OneviewSDK::ENV_VARS.each { |k| data[k] = ENV[k] }
      if @options['format'] == 'human'
        data.each do |key, value|
          value = "'#{value}'" if value && !%w(true false).include?(value)
          printf "%-#{data.keys.max_by(&:length).length}s = %s\n", key, value || 'nil'
        end
      else
        output(parse_hash(data, true))
      end
    end

    desc 'login', 'Attempt authentication and return token'
    def login
      client_setup
      puts "Login Successful! Token = #{@client.token}"
    end

    method_option :format,
      desc: 'Output format',
      aliases: '-f',
      enum: %w(json yaml human),
      default: 'human'
    desc 'list TYPE', 'List names of resources'
    def list(type)
      resource_class = parse_type(type)
      client_setup
      data = []
      resource_class.get_all(@client).each { |r| data.push(r[:name]) }
      output data
    end

    method_option :format,
      desc: 'Output format',
      aliases: '-f',
      enum: %w(json yaml human),
      default: 'human'
    method_option :attribute,
      type: :string,
      desc: 'Comma-seperated list of attributes to show',
      aliases: '-a'
    desc 'show TYPE NAME', 'Show resource details'
    def show(type, name)
      resource_class = parse_type(type)
      client_setup
      matches = resource_class.find_by(@client, name: name)
      fail_nice 'Not Found' if matches.empty?
      data = matches.first.data
      if options['attribute']
        new_data = {}
        options['attribute'].split(',').each do |attr|
          new_data[attr] = data[attr]
        end
        data = new_data
      end
      output data
    end

    method_option :format,
      desc: 'Output format',
      aliases: '-f',
      enum: %w(json yaml human),
      default: 'human'
    method_option :attribute,
      type: :string,
      desc: 'Comma-seperated list of attributes to show',
      aliases: '-a'
    method_option :filter,
      type: :hash,
      desc: 'Hash of key/value pairs to filter on',
      required: true
    desc 'search TYPE', 'Search for resource by key/value pair(s)'
    def search(type)
      resource_class = parse_type(type)
      client_setup
      filter = parse_hash(options['filter'])
      matches = resource_class.find_by(@client, filter)
      if matches.empty? # Search with integers & booleans converted
        filter = parse_hash(options['filter'], true)
        matches = resource_class.find_by(@client, filter) unless filter == options['filter']
      end
      if options['attribute']
        data = []
        matches.each do |d|
          temp = {}
          options['attribute'].split(',').each do |attr|
            temp[attr] = d[attr]
          end
          data.push(d['name'] => temp)
        end
        output data, -2 # Shift left by 2 so things look right
      else # List names only by default
        names = []
        matches.each { |m| names.push(m['name']) }
        output names
      end
    end

    method_option :format,
      desc: 'Output format',
      aliases: '-f',
      enum: %w(json yaml raw),
      default: 'json'
    method_option :data,
      desc: 'Data to pass in the request body (in JSON format)',
      aliases: '-d'
    rest_examples =  "\n  oneview-sdk-ruby rest GET rest/fc-networks"
    rest_examples << "\n  oneview-sdk-ruby rest PUT rest/fc-networks/<id> -d '{\"linkStabilityTime\": 20, ...}'"
    rest_examples << "\n  oneview-sdk-ruby rest PUT rest/enclosures/<id>/configuration"
    desc 'rest METHOD URI', "Make REST call to the OneView API. Examples:#{rest_examples}"
    def rest(method, uri)
      client_setup('log_level' => :error)
      uri_copy = uri.dup
      uri_copy.prepend('/') unless uri_copy.start_with?('/')
      if @options['data']
        begin
          data = { body: JSON.parse(@options['data']) }
        rescue JSON::ParserError => e
          fail_nice("Failed to parse data as JSON\n#{e.message}")
        end
      end
      data ||= {}
      response = @client.rest_api(method, uri_copy, data)
      if response.code.to_i.between?(200, 299)
        case @options['format']
        when 'yaml'
          puts JSON.parse(response.body).to_yaml
        when 'json'
          puts JSON.pretty_generate(JSON.parse(response.body))
        else # raw
          puts response.body
        end
      else
        body = JSON.pretty_generate(JSON.parse(response.body)) rescue response.body
        fail_nice("Request failed: #{response.inspect}\nHeaders: #{response.to_hash}\nBody: #{body}")
      end
    rescue OneviewSDK::InvalidRequest => e
      fail_nice(e.message)
    end

    method_option :hash,
      type: :hash,
      desc: 'Hash of key/value pairs to update',
      aliases: '-h'
    method_option :json,
      desc: 'JSON data to pass in the request body',
      aliases: '-j'
    update_examples =  "\n  oneview-sdk-ruby update FCNetwork FC1 -h linkStabilityTime:20"
    update_examples << "\n  oneview-sdk-ruby update Volume VOL1 -j '{\"shareable\": true}'"
    desc 'update TYPE NAME --[hash|json] <data>', "Update resource by name. Examples:#{update_examples}"
    def update(type, name)
      resource_class = parse_type(type)
      client_setup
      fail_nice 'Must set the hash or json option' unless @options['hash'] || @options['json']
      fail_nice 'Must set the hash OR json option. Not both' if @options['hash'] && @options['json']
      begin
        data = @options['hash'] || JSON.parse(@options['json'])
      rescue JSON::ParserError => e
        fail_nice("Failed to parse json\n#{e.message}")
      end
      matches = resource_class.find_by(@client, name: name)
      fail_nice 'Not Found' if matches.empty?
      resource = matches.first
      begin
        resource[:uri] = '/rest/storage-volumes/57A22A70-73EC-43C1-91B9-9FABD1E'
        resource.update(data)
        output 'Updated Successfully!'
      rescue StandardError => e
        fail_nice "Failed to update #{resource.class.name.split('::').last} '#{name}': #{e}"
      end
    end

    method_option :force,
      desc: 'Delete without confirmation',
      type: :boolean,
      aliases: '-f'
    desc 'delete TYPE NAME', 'Delete resource by name'
    def delete(type, name)
      resource_class = parse_type(type)
      client_setup
      matches = resource_class.find_by(@client, name: name)
      fail_nice 'Not Found' if matches.empty?
      resource = matches.first
      return unless options['force'] || agree("Delete '#{name}'? [Y/N] ")
      begin
        resource.delete
        output 'Deleted Successfully!'
      rescue StandardError => e
        fail_nice "Failed to delete #{resource.class.name.split('::').last} '#{name}': #{e}"
      end
    end

    method_option :force,
      desc: 'Delete without confirmation',
      type: :boolean,
      aliases: '-f'
    desc 'delete_from_file FILE_PATH', 'Delete resource defined in file'
    def delete_from_file(file_path)
      client_setup
      resource = OneviewSDK::Resource.from_file(@client, file_path)
      fail_nice 'File must define name or uri' unless resource[:name] || resource[:uri]
      found = resource.retrieve! rescue false
      found ||= resource.refresh rescue false
      fail_nice "#{resource.class.name.split('::').last} '#{resource[:name] || resource[:uri]}' Not Found" unless found
      unless options['force'] || agree("Delete '#{resource[:name]}'? [Y/N] ")
        puts 'OK, exiting.'
        return
      end
      begin
        resource.delete
        output 'Deleted Successfully!'
      rescue StandardError => e
        fail_nice "Failed to delete #{resource.class.name.split('::').last} '#{resource[:name]}': #{e}"
      end
    end

    method_option :if_missing,
      desc: 'Only create if missing (Don\'t update)',
      type: :boolean,
      aliases: '-i'
    desc 'create_from_file FILE_PATH', 'Create/Update resource defined in file'
    def create_from_file(file_path)
      client_setup
      resource = OneviewSDK::Resource.from_file(@client, file_path)
      resource[:uri] = nil
      fail_nice 'File must specify a resource name' unless resource[:name]
      existing_resource = resource.class.find_by(@client, name: resource[:name]).first
      if existing_resource
        if options['if_missing']
          puts "Skipped: '#{resource[:name]}': #{resource.class.name.split('::').last} already exists."
          return
        end
        begin
          resource.data.delete('uri')
          existing_resource.update(resource.data)
          output "Updated Successfully!\n#{resource[:uri]}"
        rescue StandardError => e
          fail_nice "Failed to update #{resource.class.name.split('::').last} '#{resource[:name]}': #{e}"
        end
      else
        begin
          resource.create
          output "Created Successfully!\n#{resource[:uri]}"
        rescue StandardError => e
          fail_nice "Failed to create #{resource.class.name.split('::').last} '#{resource[:name]}': #{e}"
        end
      end
    end

    desc 'cert check|import|list URL', 'Check, import, or list OneView certs'
    def cert(type, url = ENV['ONEVIEWSDK_URL'])
      case type.downcase
      when 'check'
        fail_nice 'Must specify a url' unless url
        puts "Checking certificate for '#{url}' ..."
        if OneviewSDK::SSLHelper.check_cert(url)
          puts 'Certificate is valid!'
        else
          fail_nice 'Certificate Validation Failed!'
        end
      when 'import'
        fail_nice 'Must specify a url' unless url
        puts "Importing certificate for '#{url}' into '#{OneviewSDK::SSLHelper::CERT_STORE}'..."
        OneviewSDK::SSLHelper.install_cert(url)
      when 'list'
        if File.file?(OneviewSDK::SSLHelper::CERT_STORE)
          puts File.read(OneviewSDK::SSLHelper::CERT_STORE)
        else
          puts 'No certs imported!'
        end
      else fail_nice "Invalid action '#{type}'. Valid actions are [check, import, list]"
      end
    rescue StandardError => e
      fail_nice e.message
    end

    private

    def fail_nice(msg = nil)
      puts "ERROR: #{msg}" if msg
      exit 1
    end

    def client_setup(client_params = {}, quiet = false, throw_errors = false)
      client_params['ssl_enabled'] = true if @options['ssl_verify'] == true
      client_params['ssl_enabled'] = false if @options['ssl_verify'] == false
      client_params['url'] ||= @options['url'] if @options['url']
      client_params['log_level'] ||= @options['log_level'].to_sym if @options['log_level']
      @client = OneviewSDK::Client.new(client_params)
    rescue StandardError => e
      raise e if throw_errors
      fail_nice if quiet
      fail_nice "Failed to login to OneView appliance at '#{client_params['url']}'. Message: #{e}"
    end

    # Get resource class from given string
    def parse_type(type)
      valid_classes = []
      OneviewSDK.constants.each do |c|
        klass = OneviewSDK.const_get(c)
        next unless klass.is_a?(Class) && klass < OneviewSDK::Resource
        valid_classes.push(klass.name.split('::').last)
      end
      vc = valid_classes.sort_by!(&:downcase).join("\n  ")
      OneviewSDK.resource_named(type) || fail_nice("Invalid resource type: '#{type}'.  Valid options are:\n  #{vc}")
    end

    # Parse options hash from input. Handles chaining and keywords such as true/false & nil
    # Returns new hash with proper nesting and formatting
    def parse_hash(hash, convert_types = false)
      new_hash = {}
      hash.each do |k, v|
        if convert_types
          v = v.to_i if v && v.match(/^\d+$/)
          v = true if v == 'true'
          v = false if v == 'false'
          v = nil if v == 'nil'
        end
        if k =~ /\./
          sub_hash = new_hash
          split = k.split('.')
          split.each do |sub_key|
            if sub_key == split.last
              sub_hash[sub_key] = v
            else
              sub_hash[sub_key] ||= {}
              sub_hash = sub_hash[sub_key]
            end
          end
          new_hash[split.first] ||= {}
        else
          new_hash[k] = v
        end
      end
      new_hash
    end

    # Print output in a given format.
    def output(data = {}, indent = 0)
      case @options['format']
      when 'json'
        puts JSON.pretty_generate(data)
      when 'yaml'
        puts data.to_yaml
      else
        # rubocop:disable Metrics/BlockNesting
        if data.class == Hash || data.class <= OneviewSDK::Resource
          data.each do |k, v|
            if v.class == Hash || v.class == Array
              puts "#{' ' * indent}#{k.nil? ? 'nil' : k}:"
              output(v, indent + 2)
            else
              puts "#{' ' * indent}#{k.nil? ? 'nil' : k}: #{v.nil? ? 'nil' : v}"
            end
          end
        elsif data.class == Array
          data.each do |d|
            if d.class == Hash || d.class == Array
              output(d, indent + 2)
            else
              puts "#{' ' * indent}#{d.nil? ? 'nil' : d}"
            end
          end
          puts "\nTotal: #{data.size}" if indent < 1
        else
          puts "#{' ' * indent}#{data.nil? ? 'nil' : data}"
        end
        # rubocop:enable Metrics/BlockNesting
      end
    end
  end

  # Console class
  class Console
    def initialize(client)
      @client = client
    end
  end
end
