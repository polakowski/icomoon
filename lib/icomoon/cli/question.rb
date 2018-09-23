module Icomoon
  module Cli
    class Question
      def initialize(value, name, default)
        @value   = value
        @name    = name
        @default = default
      end

      attr_reader :value, :name, :default
    end
  end
end
