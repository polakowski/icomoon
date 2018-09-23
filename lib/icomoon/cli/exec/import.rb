require 'fileutils'

module Icomoon
  module Cli
    module Exec
      class Import < Icomoon::Cli::Exec::Base
        CONFIG_FILE_NAME = '.icomoonrc'
        EXTENSIONS = %w[eot ttf woff svg].freeze

        help <<~STRING
          usage: icomoon import [--major]

          This subprogram imports fonts files and JSON manifest from given
          directory. It also updates icon font version.

          options:

            -dir, -d          Specifies source directory for importing files.
                              This option is required.
        STRING

        param :source_dir, '--dir', '-d'

        def run
          if source_dir.nil?
            fail Icomoon::Cli::Operation::Error, 'Source directory argument (--dir, -d) is required.'
          end

          Icomoon::Cli::Operation.new do
            read_config
          end

          Icomoon::Cli::Operation.new 'Checking files' do
            EXTENSIONS.each do |ext|
              check_source_file("fonts/#{config.icons_set_name}.#{ext}")
            end
          end

          Icomoon::Cli::Operation.new 'Copying font files' do
            EXTENSIONS.each do |ext|
              filename = "#{config.icons_set_name}.#{ext}"
              copy_file(filename, source_subdir: 'fonts')
            end
          end

          Icomoon::Cli::Operation.new 'Copying JSON manifest' do
            copy_file('selection.json', target_filename: Icomoon::Cli::MANIFEST_FILENAME)
          end

          Icomoon::Cli::Operation.new do
            validate_and_print_code
          end

          Icomoon::Cli::Operation.dump_errors
          Icomoon::Cli::Operation.dump_warnings
        end

        private

        attr_reader :config

        def read_config
          @config = Icomoon::Cli::Config.read
        end

        def check_source_file(path)
          absolute_path = File.join(source_dir, config.icons_set_name, path)
          return true if File.exists?(absolute_path)
          fail Icomoon::Cli::Operation::Error, "File not found: #{absolute_path}"
        end

        def copy_file(filename, source_subdir: '', target_filename: filename)
          FileUtils.cp(
            File.join(source_dir, config.icons_set_name, source_subdir, filename),
            File.expand_path(File.join(config.fonts_file_dir, target_filename))
          )
        rescue StandardError => e
          fail Icomoon::Cli::Operation::Error, e.message
        end

        def validate_and_print_code
          css_icons_path  = File.expand_path(config.icons_file_path)
          css_icon_regex  = /\&--([0-9a-z_\-]+)\:before \{\s+content: \"\\(e[0-9a-f]+)\"/
          css_icons       = array_to_icons(File.read(css_icons_path).scan(css_icon_regex))

          svg_icons_path = File.expand_path(File.join(config.fonts_file_dir, "#{config.icons_set_name}.svg"))
          svg_icon_regex = /unicode=\"&#x([0-9a-z]+);\" glyph-name=\"([0-9a-z_\-]+)\"/
          svg_icons      = array_to_icons(File.read(svg_icons_path).scan(svg_icon_regex).map(&:reverse))

          find_unused_icons(css_icons, svg_icons)
          print_code_update(css_icons, svg_icons)
        end

        def find_unused_icons(css_icons, svg_icons)
          unused_icons = css_icons.select do |css_icon|
            svg_icons.map(&:code).index(css_icon.code).nil?
          end

          n = unused_icons.count

          return true if n.zero?

          names   = unused_icons.map(&:name).join(', ')
          message =  "#{n} unused #{n == 1 ? 'icon' : 'icons'} detected: #{names}."
          Icomoon::Cli::Operation.warn! message
        end

        def print_code_update(css_icons, svg_icons)
          missing_icons = svg_icons.select do |svg_icon|
            css_icons.map(&:code).index(svg_icon.code).nil?
          end

          if missing_icons.count.zero?
            Icomoon::Cli::Operation.warn! 'No new icons detected.'
            return
          end

          code = missing_icons.map do |icon|
            <<~STRING
              &--#{icon.name}:before {
                content: "\\#{icon.code}";
              }
            STRING
          end.join("\n").cyan

          puts "\nAdd this to #{config.icons_file_path}:\n\n#{code}"
        end

        def array_to_icons(array)
          array.map do |name, code|
            Icomoon::Cli::Icon.new(name, code)
          end
        end
      end
    end
  end
end
