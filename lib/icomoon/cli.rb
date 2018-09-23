require 'pry'
require 'json'
require 'colorize'

require_relative 'cli/exec_param'
require_relative 'cli/exec'
require_relative 'cli/parse_argv'
require_relative 'cli/survey'
require_relative 'cli/question'
require_relative 'cli/logger'
require_relative 'cli/operation'
require_relative 'cli/writer'
require_relative 'cli/config'
require_relative 'cli/icon'

module Icomoon
  module Cli
    MANIFEST_FILENAME = 'icomoon.json'

    class << self
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
