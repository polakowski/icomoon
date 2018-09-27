module Icomoon
  module Cli
    class Operation
      @@warnings = []
      @@errors   = []
      @@skip_all = false

      def initialize(name = nil)
        return unless block_given?
        return if self.class.skip?

        Icomoon::Cli.log "#{name}... " if name

        begin
          yield
          puts '✔'.green if name
        rescue Icomoon::Cli::Error => error
          @@errors << error
          puts '✘'.red if name
          Icomoon::Cli::Operation.skip_all!
        rescue Icomoon::Cli::Warning => warning
          @@warnings << warning
          puts '✘'.red if name
        end
      end

      def self.dump_warnings
        while (warning = @@warnings.shift)
          Icomoon::Cli.logs "#{'Warning:'.yellow} #{warning.message}"
        end
      end

      def self.dump_errors(exit_code = nil)
        while (error = @@errors.shift)
          Icomoon::Cli.logs "#{'Error:'.red} #{error.message}"
        end

        exit(exit_code) if exit_code
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
