require 'thor'

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
        require 'pry'
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
      desc: 'API version to use',
      aliases: '-a'

    class_option :log_level,
      desc: 'Log level to use',
      aliases: '-l',
      enum: %w(debug info warn error),
      default: 'warn'

    map ['-v', '--version'] => :version


    desc 'version', 'Print gem and OneView appliance versions'
    def version
      puts "Gem Version: #{OneviewSDK::VERSION}"
      client_setup('log_level' => :error)
      puts "OneView appliance API version at '#{@client.url}' = #{@client.max_api_version}"
    rescue StandardError => e
      puts "Failed to get appliance API version. Message: #{e.message}"
    end

    desc 'login', 'Attempt authentication and return token'
    def login
      client_setup
      puts "Login Successful! Token = #{@client.token}"
    end

    private

    def client_setup(client_params = {})
      client_params['ssl_enabled'] ||= false if @options['ssl_verify'] == false
      client_params['url'] ||= @options['url'] if @options['url']
      client_params['log_level'] ||= @options['log_level'].to_sym if @options['log_level']
      @client = OneviewSDK::Client.new(client_params)
    end
  end
end
