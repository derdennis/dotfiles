#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "nokogiri"
require "open-uri"

# Clear my screen
puts "\e[H\e[2J"

page = Nokogiri::HTML(open('/home/dennis/amz_wishlist_page1.html'))
test = Nokogiri::HTML(open('/home/dennis/amz_test_page.html'))
#test = Nokogiri::HTML(open('http://ruby.bastardsbook.com/files/hello-webpage.html'))


# Web Scraping according to http://ruby.bastardsbook.com/chapters/html-parsing/

# CSS Path copied from Firebug for The List
# "html body.noBeaconUI div div#wlMain div.wlNoUnderline div div.list-items div.noUnderline form table.compact-items"
#
# CSS Path copied from Firebug for one item from the list
# "html body.noBeaconUI div div#wlMain div.wlNoUnderline div div.list-items div.noUnderline form table.compact-items tbody.itemWrapper"


#page.css('div div#wlMain div.wlNoUnderline div div.list-items div.noUnderline form table.compact-items itemWrapper').each do |el|
       #puts el.text
#end
puts "Class of page"
puts page.class

items = page.css("html body.noBeaconUI div div#wlMain div.wlNoUnderline div div.list-items div.noUnderline form table.compact-items tbody.itemWrapper")

puts "Length of items"
puts items.length

puts "first item:"
puts items[0]
puts ""
puts ""
puts ""
puts ""

puts "Tiny selectors:"
puts items[0].css("span.tiny").text

puts "Price selectors:"
puts items[0].css("span.price").text

puts "Title selectors:"
puts items[0].css("span.small strong a").text
exit
tiny = page.css("html body.noBeaconUI div div#wlMain div.wlNoUnderline div div.list-items div.noUnderline form table.compact-items tbody.itemWrapper tr td span.tiny")



