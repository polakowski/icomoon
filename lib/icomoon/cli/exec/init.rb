module Icomoon
  module Cli
    module Exec
      class Init < Icomoon::Cli::Exec::Base
        help <<~STRING
          Usage: icomoon init [--force, -f]

          This subprogram will help you to create starting
          files such as icon stylesheet file and config initializer.
          Just run `icomoon init` and follow instructions.

          options:

            --force, -f       Overrides config and stylesheet files.
        STRING

        flag :force, '--force', '-f'

        def run
          config = Icomoon::Cli::Survey.run do |s|
            s.ask :icons_set_name, 'Icon set name', 'icomoon-icons'
            s.ask :icons_file_path, 'Path of icons stylesheet file', 'app/assets/stylesheets/_icons.scss'
            s.ask :fonts_file_dir, 'Directory of fonts files', 'app/assets/fonts/'
            s.ask :css_class, 'CSS icon class', 'icon'
          end

          dir           = config[:fonts_file_dir]
          manifest_path = File.expand_path(File.join(dir, Icomoon::Cli::MANIFEST_FILENAME))

          Icomoon::Cli.put_separator

          Icomoon::Cli::Operation.new do
            ensure_pristine(config, manifest_path)
          end

          Icomoon::Cli::Operation.new 'Creating config file' do
            write_config(config)
          end

          Icomoon::Cli::Operation.new 'Initializing icons stylesheet' do
            write_styles(config)
          end

          Icomoon::Cli::Operation.new 'Creating JSON manifest' do
            write_manifest(config, manifest_path)
          end

          Icomoon::Cli::Operation.dump_warnings
          Icomoon::Cli::Operation.dump_errors
        end

        private

        def ensure_pristine(config, manifest_path)
          return true if force?

          force_tip = 'use --force (-f) option if you want to override.'

          if Icomoon::Cli::Config.config_file_exists?
            fail Icomoon::Cli::Error, 'Config file already exists, '\
              + force_tip
          end

          if Icomoon::Cli.file_exists?(config[:icons_file_path])
            fail Icomoon::Cli::Error, 'Styles file already exists, '\
              + force_tip
          end

          if Icomoon::Cli.file_exists?(manifest_path)
            fail Icomoon::Cli::Error, 'icomoon.json file already exists, '\
              + force_tip
          end
        end

        def write_config(config)
          Icomoon::Cli::Config.write(config)
        end

        def write_styles(config)
          icons_file_path = config[:icons_file_path]
          icons_set_name  = config[:icons_set_name]
          css_class       = config[:css_class]

          Icomoon::Cli::Writer.write(icons_file_path) do |file|
            file.puts(<<~STRING
              @font-face {
                font-family: '#{icons_set_name}';
                src: asset-url('#{icons_set_name}.eot');
                src: asset-url('#{icons_set_name}.eot') format('embedded-opentype'),
                  asset-url('#{icons_set_name}.ttf') format('truetype'),
                  asset-url('#{icons_set_name}.woff') format('woff');
              }

              .#{css_class} {
                font-family: '#{icons_set_name}';

                // &--icon-name:before {
                //   content: \"\\e900\";
                // }
              }
            STRING
            )
          end
        end

        def write_manifest(config, manifest_path)
          font_name       = config[:icons_set_name]
          css_class       = config[:css_class]
          icons_file_path = config[:icons_file_path]
          prefix          = "#{css_class}-"

          Icomoon::Cli::Writer.write_json(
            manifest_path,
            IcoMoonType: 'selection',
            icons: [],
            height: 1024,
            metadata: {
              name: font_name
            },
            preferences: {
              showGlyphs: true,
              showQuickUse: true,
              showQuickUse2: true,
              showSVGs: true,
              fontPref: {
                prefix: prefix,
                metadata: {
                  fontFamily: font_name,
                  majorVersion: 0,
                  minorVersion: 1
                },
                metrics: {
                  emSize: 1024,
                  baseline: 6.25,
                  whitespace: 50
                },
                embed: false,
                showSelector: false,
                showMetrics: false,
                showMetadata: false,
                showVersion: false
              },
              imagePref: {
                prefix: prefix,
                png: true,
                useClassSelector: true,
                color: 0,
                bgColor: 16777215,
                classSelector: ".#{css_class}"
              },
              historySize: 50,
              showCodes: true,
              gridSize: 16
            }
          )
        end
      end
    end
  end
end
