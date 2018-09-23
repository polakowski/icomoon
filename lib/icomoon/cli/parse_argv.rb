module Icomoon
  module Cli
    class ParseArgv
      def self.call(argv, params)
        result = {}

        params.each do |param|
          param.aliases.each do |aliaz|
            idx = argv.find_index { |arg| argv.include? aliaz }

            if idx
              value = param.needs_value ? argv.delete_at(idx + 1) : true
              argv.delete_at(idx)
              result[param.key] = value
            end
          end
        end

        if argv.count.nonzero?
          IcomoonCli.error "Unrecognized arguments: #{argv.join(', ')}"
        end

        result
      end
    end
  end
end
