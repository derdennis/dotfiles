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

wishlist = page.css("html body.noBeaconUI div div#wlMain div.wlNoUnderline div div.list-items div.noUnderline form table.compact-items tbody.itemWrapper")

puts "Length of items"
puts wishlist.length

#puts "first item:"
#puts wishlist[0]

#puts "Title selectors:"
#puts wishlist[59].css("span.small strong a").text

#puts "Tiny selectors:"
#puts wishlist[59].css("span.tiny").text.gsub(/Alle Kaufmöglichkeiten$/,'').strip

#puts "Price selectors:"
#puts wishlist[59].css("span.price").text
puts "List"
puts ""

wl_index=0
wishlist.each do |item|
title = item.css("span.small strong a").text.gsub(/in diesem Shop einkaufen/,'')


autor = item.css("span.tiny").text.gsub(/Alle Kaufmöglichkeiten$/,'').strip
if autor =~ /von|DVD/
    autor = autor.gsub(/Angeboten von.*?DVD ~/,'DVD ~')
else
    autor = "BLUB"
end



price = item.css("span.price").text

puts wl_index.to_s + " " + title + " " + autor + " " + price 
wl_index+=1

end



exit
