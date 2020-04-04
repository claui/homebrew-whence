# encoding: UTF-8
# frozen_string_literal: true

module Homebrew
  module Format
    DescriptorTableRow = Struct.new(:descriptor) do
      TARGET_FORMAT_STRING = '→ %s %s'

      def executable
        String(descriptor.executable)
      end

      def note
        descriptor.note ? "(#{descriptor.note})" : ''
      end

      def target
        if descriptor.target&.respond_to?(:to_str)
          descriptor.target.to_str
        elsif descriptor.target&.respond_to?(:name) &&
          descriptor.target.respond_to?(:version)
          sprintf(
            TARGET_FORMAT_STRING,
            descriptor.target.name,
            descriptor.target.version
          ).rstrip
        else
          ''
        end
      end
    end
  end
end
