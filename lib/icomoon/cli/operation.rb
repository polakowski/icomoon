module Icomoon
  module Cli
    class Operation
      Error   = Class.new(StandardError)
      Warning = Class.new(StandardError)

      @@warnings = []
      @@errors   = []
      @@skip_all = false

      def initialize(name = nil)
        return unless block_given?
        return if self.class.skip?

        Icomoon::Cli.log "#{name}... " if name

        begin
          yield
        rescue Icomoon::Cli::Operation::Error => error
          @@errors << error
          puts '✘'.red if name
          Icomoon::Cli::Operation.skip_all!
        rescue Icomoon::Cli::Operation::Warning => warning
          @@warnings << warning
          puts '✘'.red if name
        else
          puts '✔'.green if name
        end
      end

      def self.dump_warnings
        while (warning = @@warnings.shift)
          IcomoonCli.logs "#{'Warning:'.yellow} #{warning.message}"
        end
      end

      def self.dump_errors
        while (error = @@errors.shift)
          IcomoonCli.logs "#{'Error:'.red} #{error.message}"
        end

        exit 1
      end

      def self.warn!(message)
        @@warnings << Icomoon::Cli::Operation::Warning.new(message)
      end

      def self.skip_all!
        @@skip_all = true
      end

      def self.skip?
        @@skip_all
      end
    end
  end
end
