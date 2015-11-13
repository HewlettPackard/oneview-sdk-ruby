require 'thor'
require 'json'
require 'yaml'
require 'highline/import'

module OneviewSDK
  # cli for oneview-sdk-ruby
  class Cli < Thor
    # Runner class to enable testing with Aruba
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


    desc 'version', 'Print gem and OneView appliance versions'
    def version
      puts "Gem Version: #{OneviewSDK::VERSION}"
      client_setup({ 'log_level' => :error }, true)
      puts "OneView appliance API version at '#{@client.url}' = #{@client.max_api_version}"
    rescue StandardError, SystemExit
      puts 'OneView appliance API version unknown'
    end

    desc 'env', 'Show environment variables for oneview-sdk-ruby'
    def env
      print 'ONEVIEWSDK_URL         = '
      puts ENV['ONEVIEWSDK_URL'] ? "'#{ENV['ONEVIEWSDK_URL']}'" : 'nil'
      print 'ONEVIEWSDK_USER        = '
      puts ENV['ONEVIEWSDK_USER'] ? "'#{ENV['ONEVIEWSDK_USER']}'" : 'nil'
      print 'ONEVIEWSDK_PASSWORD    = '
      puts ENV['ONEVIEWSDK_PASSWORD'] ? "'#{ENV['ONEVIEWSDK_PASSWORD']}'" : 'nil'
      print 'ONEVIEWSDK_TOKEN       = '
      puts ENV['ONEVIEWSDK_TOKEN'] ? "'#{ENV['ONEVIEWSDK_TOKEN']}'" : 'nil'
      print 'ONEVIEWSDK_SSL_ENABLED = '
      puts ENV['ONEVIEWSDK_SSL_ENABLED'] ? "#{ENV['ONEVIEWSDK_SSL_ENABLED']}" : 'nil'
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
      resource_class.find_by(@client, {}).each { |r| data.push(r[:name]) }
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
    desc 'search TYPE NAME', 'Search for resource by key/value pair(s)'
    def search(type)
      resource_class = parse_type(type)
      client_setup
      filter = parse_hash(options['filter'])
      matches = resource_class.find_by(@client, filter)
      if matches.empty? # Search with integers & booleans converted
        filter = parse_hash(options['filter'], true)
        matches = resource_class.find_by(@client, filter) unless filter == options['filter']
      end
      data = []
      matches.each { |m| data.push(m.data) }
      if options['attribute']
        new_data = []
        data.each do |d|
          temp = {}
          options['attribute'].split(',').each do |attr|
            temp[attr] = d[attr]
          end
          new_data.push temp
        end
        data = new_data
      end
      output data
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

    method_option :force,
      desc: 'Overwrite without confirmation',
      type: :boolean,
      aliases: '-f'
    method_option :if_missing,
      desc: 'Only create if missing (Don\'t update)',
      type: :boolean,
      aliases: '-i'
    desc 'create_from_file FILE_PATH', 'Create/Overwrite resource defined in file'
    def create_from_file(file_path)
      fail_nice "Can't use the 'force' and 'if_missing' flags at the same time." if options['force'] && options['if_missing']
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
        fail_nice "#{resource.class.name.split('::').last} '#{resource[:name]}' already exists." unless options['force']
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

    private

    def fail_nice(msg = nil)
      puts "ERROR: #{msg}" if msg
      exit 1
    end

    def client_setup(client_params = {}, quiet = false)
      client_params['ssl_enabled'] = true if @options['ssl_verify'] == true
      client_params['ssl_enabled'] = false if @options['ssl_verify'] == false
      client_params['url'] ||= @options['url'] if @options['url']
      client_params['log_level'] ||= @options['log_level'].to_sym if @options['log_level']
      @client = OneviewSDK::Client.new(client_params)
    rescue StandardError => e
      fail_nice if quiet
      fail_nice "Failed to login to OneView appliance at '#{client_params['url']}'. Message: #{e}"
    end

    def parse_type(type)
      classes = {}
      orig_classes = []
      ObjectSpace.each_object(Class).select { |klass| klass < OneviewSDK::Resource }.each do |c|
        name = c.name.split('::').last
        orig_classes.push(name)
        classes[name.downcase.delete('_').delete('-')] = c
        classes["#{name.downcase.delete('_').delete('-')}s"] = c
      end
      new_type = type.downcase.delete('_').delete('-')
      return classes[new_type] if classes.keys.include?(new_type)
      fail_nice "Invalid resource type: '#{type}'.\n  Valid options are #{orig_classes}"
    end

    def parse_hash(hash, convert_types = false)
      new_hash = {}
      hash.each do |k, v|
        if convert_types
          v = v.to_i if v.match(/^\d+$/)
          v = true if v == 'true'
          v = false if v == 'false'
          v = nil if v == 'nil'
        end
        if k.match(/\./)
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

    def output(data = {}, indent = 0)
      case @options['format']
      when 'json'
        puts JSON.pretty_generate(data)
      when 'yaml'
        puts data.to_yaml
      else
        if data.class == Hash || data.class <= OneviewSDK::Resource
          data.each do |k, v|
            if v.class == Hash || v.class == Array
              puts "#{' ' * indent}#{k}:"
              output(v, indent + 2)
            else
              puts "#{' ' * indent}#{k}: #{v}"
            end
          end
        elsif data.class == Array
          data.each do |d|
            if d.class == Hash || d.class == Array
              # rubocop:disable Metrics/BlockNesting
              if indent == 0
                puts ''
                output(d, indent)
              else
                output(d, indent + 2)
              end
              # rubocop:enable Metrics/BlockNesting
            else
              puts "#{' ' * indent}#{d}"
            end
          end
          puts "\nTotal: #{data.size}" if indent == 0
        else
          puts "#{' ' * indent}#{data}"
        end
      end
    end
  end
end
