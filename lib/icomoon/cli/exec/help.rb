module Icomoon
  module Cli
    module Exec
      class Help < Icomoon::Cli::Exec::Base
        help <<~STRING
          :-)
        STRING

        def run
          puts <<~STRING
            Usage: icomoon command [...options]

            Run `icomoon command help` to get help about specific command.

            Commands:
              - help      Displays this help text.
              - init      Initializes and configures Icomoon.
          STRING
        end
      end
    end
  end
end
