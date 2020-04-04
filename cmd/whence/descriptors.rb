# frozen_string_literal: true

module Homebrew
  module Descriptors
    Formula = Struct.new(:executable, :target) do
      def note; end
    end

    NotALink = Struct.new(:executable) do
      def note
        'not a link'
      end
      def target; end
    end

    Unknown = Struct.new(:executable, :target) do
      def note
        'unknown'
      end
    end
  end
end
