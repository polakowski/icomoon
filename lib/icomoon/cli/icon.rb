module Icomoon
  module Cli
    class Icon
      def initialize(name, code)
        @name = name
        @code = code
      end

      attr_reader :name, :code
    end
  end
end
