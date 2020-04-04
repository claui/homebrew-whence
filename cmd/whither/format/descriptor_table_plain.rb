# frozen_string_literal: true

require 'csv'

require_relative "./descriptor_table_plain_row.rb"

module Homebrew
  module Format
    class DescriptorTablePlain
      attr_reader :descriptors

      def to_s
        CSV.generate(col_sep: "\t") do |csv|
          rows.each { |row| csv << row.to_a }
        end
      end

      def initialize(descriptors)
        @descriptors = descriptors.dup.freeze
      end

      private

      def rows
        @rows ||= descriptors.map(&DescriptorTablePlainRow.method(:new))
      end
    end
  end
end
