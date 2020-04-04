# encoding: UTF-8
# frozen_string_literal: true

#:  * `whence` [`--no-headers`] <filename>
#:
#:  Look up the formula to which an executable belongs.
#:
#:      -H, --no-headers      print output in machine-readable form
#:                            (tab-separated, no headers).
#:
#:  Example #1:
#:
#:      $ brew whence 7z mvn zdb
#:
#:      Executable                         Comes from
#:      ==========                         ==========
#:      /usr/local/bin/7z                  → p7zip 16.02
#:      /usr/local/bin/mvn                 → maven 3.6.3
#:      /usr/local/bin/zdb   (not a link)
#:
#:  Example #2:
#:
#:      $ brew whence -H 7z mvn zdb
#:
#:      7z    A  p7zip  16.02                  /usr/local/bin/7z
#:      mvn   A  maven  3.6.3                  /usr/local/bin/mvn
#:      zdb   N                                /usr/local/bin/zdb

require "cli/parser"
require "pathname"

require_relative "./whence/exceptions"
require_relative "./whence/format"
require_relative "./whence/source_locator"

module Homebrew
  module_function

  LINK_DIRECTORIES= %w[bin sbin]

  def whence_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `whence` [<options>] <filename>

        Look up the formula to which an executable belongs.
      EOS
      switch "-H", "--no-headers"
      switch :debug
    end
  end

  def whence
    whence_args.parse

    names = args.named
    odebug "Given executable names", *names
    raise FilenameUnspecifiedError if names.empty?

    odebug "Collecting files"
    subdirs = LINK_DIRECTORIES.map { |name| HOMEBREW_PREFIX/name }

    symlinks_by_name = names.reduce({}) do |h, name|
      symlinks = []

      if File.dirname(name) == '.'
        subdirs.each do |subdir|
          pathname = subdir/name
          symlinks << pathname if pathname.exist?
        end
      else
        pathname = Pathname.new(name)
        symlinks << pathname.expand_path if pathname.exist?
      end

      if symlinks.empty?
        raise NoSuchFileError.new(name, subdirs)
      end
      h[name] = symlinks
      h
    end

    odebug "Files found", symlinks_by_name.inspect

    sources = symlinks_by_name.reduce([]) do |a, (name, symlinks)|
      symlinks.each do |symlink|
        odebug "Locating formula for #{name}"
        locator = SourceLocator.new(name, symlink)
        a << locator.descriptor
      end
      a
    end

    odebug "Sources found", *sources
    table = if args.no_headers?
      Format::DescriptorTablePlain.new(sources)
    else
      Format::DescriptorTable.new(sources)
    end
    puts table.to_s
  end

  whence
  odebug "Success"
end
