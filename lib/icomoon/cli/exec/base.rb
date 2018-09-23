module Icomoon
  module Cli
    module Exec
      class Base
        @@params = []

        def self.params
          @@params
        end

        def initialize(args)
          @args = args
        end

        class << self
          def run(argv)
            if argv.count == 1 && argv[0] == 'help'
              return display_help
            end

            new(Icomoon::Cli::ParseArgv.call(argv, params)).run
          end

          def display_help
            puts @command_help_text
          end

          def help(text)
            @command_help_text = text
          end

          def param(*args)
            add_param(true, *args)
          end

          def flag(*args)
            add_param(false, *args)
          end

          def add_param(needs_value, *args)
            key = args.shift
            params << Icomoon::Cli::ExecParam.new(key, args, needs_value) if args.count.nonzero?

            method_name = needs_value ? key : "#{key}?"
            define_param_reader(key, method_name)
          end

          def define_param_reader(key, method_name = key)
            class_eval("def #{method_name}; args[#{key.to_sym.inspect}] rescue nil; end")
          end
        end

        private

        attr_reader :args
      end
    end
  end
end
