module Icomoon
  module Cli
    class Logger
      PREFIX = "[#{'icomoon'.light_blue}]".freeze

      def log(text, break_line)
        if break_line
          puts "#{PREFIX} #{text}"
        else
          print "#{PREFIX} #{text}"
        end
      end
    end
  end
end
