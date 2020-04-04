# frozen_string_literal: true

require_relative "./descriptors"
require_relative "./targets"

module Homebrew
  class SourceLocator
    def descriptor
      @descriptor ||= find_descriptor
    end

    def initialize(target_name, target_path)
      @target_name = target_name
      @target_path = target_path
    end

    private

    attr_reader :target_name, :target_path

    def find_descriptor
      odebug "Finding descriptor for #{target_path}"

      unless target_path.symlink?
        odebug "#{target_path} not a symlink"
        return Descriptors::NotALink.new(target_path)
      end

      link = target_path.readlink
      if link.absolute?
        return Descriptors::Unknown.new(target_path, link)
      end
      source = link.expand_path(target_path.parent)
      path_starts_cellar = source.to_s.start_with?(HOMEBREW_CELLAR.to_s)

      if path_starts_cellar
        formula_target = Targets::FormulaTarget.new(
          *source
            .relative_path_from(HOMEBREW_CELLAR)
            .to_s
            .split('/')[0..1]
        )
        return Descriptors::Formula.new(target_path, formula_target)
      end
      Descriptors::Unknown.new(target_path, source.relative_path_from(source.parent))
    end
  end
end
