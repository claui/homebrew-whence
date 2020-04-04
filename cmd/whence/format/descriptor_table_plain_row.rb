# encoding: UTF-8
# frozen_string_literal: true

module Homebrew
  module Format
    DescriptorTablePlainRow = Struct.new(:descriptor) do
      def to_a
        [
          executable.basename,
          target_type_letter,
          (target&.name if descriptor.is_a?(Descriptors::Formula)),
          (target&.version if descriptor.is_a?(Descriptors::Formula)),
          nil, # reserved
          nil, # reserved
          String(executable),
        ]
      end

      private

      def executable
        descriptor.executable
      end

      def target
        descriptor.target
      end

      def target_type_letter
        case descriptor
        when Descriptors::Formula  then 'A'
        when Descriptors::NotALink then 'N'
        when Descriptors::Unknown  then '?'
        else raise TypeError.new("Unexpected descriptor: #{descriptor}")
        end
      end
    end
  end
end
