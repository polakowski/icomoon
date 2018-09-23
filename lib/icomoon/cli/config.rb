module Icomoon
  module Cli
    class Config
      CONFIG_FILE_NAME = '.icomoon-config.json'

      class << self
        def read
          if !File.exists? config_file_full_path
            fail Icomoon::Cli::Operation::Error, 'Config file not found.'
          end

          content = JSON.parse(File.read(config_file_full_path))

          Struct.new(
            :icons_set_name,
            :icons_file_path,
            :fonts_file_dir,
            :css_class
          ).new(
            content['icons_set_name'],
            content['icons_file_path'],
            content['fonts_file_dir'],
            content['css_class']
          )
        end

        def write(config)
          Icomoon::Cli::Writer.write(CONFIG_FILE_NAME) do |file|
            file.puts(JSON.pretty_generate(config))
          end
        end

        def config_file_exists?
          File.exists? CONFIG_FILE_NAME
        end

        def config_file_full_path
          File.expand_path(CONFIG_FILE_NAME)
        end
      end
    end
  end
end
