#!/usr/bin/env ruby

# via:
# https://gist.github.com/Lysander/2689105

require 'redcarpet'


class MoinMoin < Redcarpet::Render::Base

    def header(text, level)
        prefix = "=" * level
        "\n\n#{prefix} #{text} #{prefix}\n"
    end

    def paragraph(text)
        "\n#{text}\n"
    end

    def block_code(code, language)
        "\n{{{#!#{language}\n#{code}}}}\n"
    end

    def block_quote(quote)
        quote.each_line.map {|l| "    #{l}"}.join
    end

    def list(contents, list_type)
        contents
    end

    def list_item(text, list_type)
        "\n * #{text}"
    end

    def link(link, title, content)
        "[[#{link}|#{content}]]"
    end

    def double_emphasis(text)
        "'''#{text}'''"
    end

    def emphasis(text)
        "''#{text}''"
    end

end


File.open(ARGV[0], "r") do |f|
    markdown = Redcarpet::Markdown.new(MoinMoin, :fenced_code_blocks => true,
                                       :hard_wrap => true)
    puts markdown.render(f.read)
end

