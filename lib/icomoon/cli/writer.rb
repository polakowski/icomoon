module Icomoon
  module Cli
    class Writer
      class << self
        def write(path)
          return unless block_given?

          path = File.expand_path(path)

          File.new(path, 'w+').tap do |file|
            yield file
            file.close
          end

          path
        end

        def write_json(path, json = {})
          write(path) do |file|
            file.puts(JSON.pretty_generate(json))
          end
        end
      end
    end
  end
end
