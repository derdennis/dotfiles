#!/usr/bin/env /Users/dennis/.rvm/rubies/ruby-1.9.2-p290/bin/ruby
#encoding: UTF-8

# #!/usr/bin/ruby
# For use with Marked <http://markedapp.com> and Jekyll _posts
#   turns
# {% img alignright /images/heythere.jpg 100 100 "Hey there" "hi" %}
#   into
# <img src="../images/heythere.jpg" alt="Hey there" class="alignright" title="hi" />
#
# replaces alignleft and alignright classes with appropriate style attribute
# ---
# Replaces {% gist XXXXX filename.rb %} with appropriate script tag
#
# Processes final output with /usr/bin/kramdown (install kramdown as system gem: `sudo gem install kramdown`)

content = STDIN.read

def e_sh(str)
  str.to_s.gsub(/(?=[^a-zA-Z0-9_.\/\-\x7F-\xFF\n])/, '\\').gsub(/\n/, "'\n'").sub(/^$/, "''")
end

# Process fancy tags
content.gsub!(/\{% fancy (.*?) %\}/) {|fancy|
  if fancy =~ /\{% fancy (left|right|center)?\s{1}(\S+)\s{1}?(\d*)? %\}/i
    classes = $1.strip if $1
    src = $2
    width = $3
    title = $4
    puts RUBY_VERSION
    puts "MATCHING! #{src}"
    classes.gsub!(/"/, '') if classes
  end

  style = %Q{ style="float:left;margin-right: 1.5em"} if classes =~ /left/
  style = %Q{ style="float:right;margin-left: 1.5em"} if classes =~ /right/
  style = %Q{ style="display:block;margin: 0 auto 1.5em"} if classes =~/center/

  %Q{<img src="../images/#{src}" width="#{width}" class="#{classes}"#{style}>}
}
# Process image Liquid tags
content.gsub!(/\{% img (.*?) %\}/) {|img|
  if img =~ /\{% img (\S.*\s+)?(https?:\/\/\S+|\/\S+|\S+\/\s+)(\s+\d+\s+\d+)?(\s+.+)? %\}/i
    classes = $1.strip if $1
    src = $2
    size = $3
    title = $4



    if /(?:"|')([^"']+)?(?:"|')\s+(?:"|')([^"']+)?(?:"|')/ =~ title
      title  = $1
      alt    = $2
    else
      alt    = title.gsub!(/"/, '&#34;') if title
    end
    classes.gsub!(/"/, '') if classes
  end

  style = %Q{ style="float:right;margin:0 0 10px 10px"} if classes =~ /alignright/
  style = %Q{ style="float:left;margin:0 10px 10px 0"} if classes =~ /alignleft/

  %Q{<img src="..#{src}" alt="#{alt}" class="#{classes}" title="#{title}"#{style}>}
}

# Process gist tags
content.gsub!(/\{% gist(.*?) %\}/) {|gist|
    if parts = gist.match(/\{% gist ([\d]*) (.*?)?%\}/)
      gist_id = parts[1].strip
      file = parts[2].nil? ? '' : "?file-#{parts[2].strip}"
      %Q{<script src="https://gist.github.com/#{gist_id}.js#{file}"></script>}
    else
      ""
    end
}

puts %x{echo #{e_sh content}|/usr/bin/kramdown}
