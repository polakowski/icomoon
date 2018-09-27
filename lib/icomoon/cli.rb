require 'pry'
require 'json'
require 'colorize'

require 'icomoon/cli/exec_param'
require 'icomoon/cli/exec'
require 'icomoon/cli/parse_argv'
require 'icomoon/cli/survey'
require 'icomoon/cli/question'
require 'icomoon/cli/logger'
require 'icomoon/cli/operation'
require 'icomoon/cli/writer'
require 'icomoon/cli/config'
require 'icomoon/cli/icon'

module Icomoon
  module Cli
    MANIFEST_FILENAME = 'icomoon.json'

    Error   = Class.new(StandardError)
    Warning = Class.new(StandardError)

    class << self
      def start(argv)
        Icomoon::Cli::Exec.run(argv)
      end

      def logs(text)
        logger.log(text, true)
      end

      def log(text)
        logger.log(text, false)
      end

      def error(text)
        puts "#{'Error:'.red} #{text}"
      end

      def put_separator
        logs('---')
      end

      def file_exists?(path)
        File.exists?(path)
      end

      def logger
        @@logger
      end

      def logger=(logger)
        @@logger = logger
      end

      @@logger = Icomoon::Cli::Logger.new
    end
  end
end
