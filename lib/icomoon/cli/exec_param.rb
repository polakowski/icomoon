module Icomoon
  module Cli
    class ExecParam
      attr_reader :key, :aliases, :needs_value

      def initialize(key, aliases, needs_value)
        @key         = key
        @aliases     = aliases || []
        @needs_value = needs_value
      end
    end
  end
end
