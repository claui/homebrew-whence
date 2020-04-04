# frozen_string_literal: true

require_relative "./descriptor_table_row.rb"

module Homebrew
  module Format
    class DescriptorTable
      COLUMN_TITLES = [
        'Executable',
        '',
        'Comes from',
      ]

      attr_reader :descriptors

      def to_s
        out = StringIO.new
        out.printf(row_format_string, *COLUMN_TITLES)
        out.printf(row_format_string,
          *(COLUMN_TITLES.map {|title| '=' * title.to_s.length}))
        rows.each do |row|
          out.printf(row_format_string, row.executable, row.note,
            row.target)
        end
        out.string
      end

      def initialize(descriptors)
        @descriptors = descriptors.dup.freeze
      end

      private

      def column_widths
        @column_widths ||= begin
          field_widths
            .zip(COLUMN_TITLES.map(&:length))
            .map { |pair| pair.compact.max }
        end
      end

      def field_widths
        %i[executable note target].map do |sym|
          rows.map { |row| String(row.send(sym)).length }.max
        end
      end

      def row_format_string
        @row_format_string ||= [
          "%-#{column_widths[0]}s",
          "%#{column_widths[1]}s",
          "%-#{column_widths[2]}s",
        ].join('  ') << "\n"
      end

      def rows
        @rows ||= descriptors.map(&DescriptorTableRow.method(:new))
      end
    end
  end
end
