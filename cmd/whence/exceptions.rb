# frozen_string_literal: true

require "exceptions"

module Homebrew
  class FilenameUnspecifiedError < UsageError
    def initialize
      super "This command requires one or more file names."
    end
  end

  class NoSuchFileError < RuntimeError
    attr_reader :name, :search_dirs

    def initialize(name, search_dirs)
      @name = name
      @search_dirs = search_dirs
    end

    def to_s
      "#{name}: no such file in any of #{search_dirs.join(", ")}"
    end
  end
end
