require 'icomoon/version'

require 'icomoon/cli/exec/base'
require 'icomoon/cli/exec/init'
require 'icomoon/cli/exec/import'
require 'icomoon/cli/exec/help'

module Icomoon
  module Cli
    module Exec
      class << self
        def run(argv)
          command = argv.shift

          case command
          when 'init'
            Icomoon::Cli::Exec::Init.run(argv)
          when 'import'
            Icomoon::Cli::Exec::Import.run(argv)
          when 'help', nil
            Icomoon::Cli::Exec::Help.run(argv)
          when 'version', '--version', '-v'
            Icomoon::Cli.logs Icomoon::VERSION
          else
            Icomoon::Cli.logs "invalid command: #{command}"
          end
        end
      end
    end
  end
end
