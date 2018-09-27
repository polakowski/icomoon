module Icomoon
  module Cli
    class Survey
      def initialize
        @questions = []
      end

      def ask(value, name, default = nil)
        questions << Icomoon::Cli::Question.new(value, name, default)
      end

      def read!
        Hash.new.tap do |answers|
          questions.each do |q|
            Icomoon::Cli.log "#{'question'.light_black} #{q.name} (#{q.default || 'none'}): "

            answer = (gets || '').chomp
            answer = q.default if /\A[\s]*\z/.match?(answer)

            answers[q.value] = answer
          end
        end
      end

      def self.run
        survey = new
        yield(survey)
        survey.read!
      end

      private

      attr_reader :questions
    end
  end
end
