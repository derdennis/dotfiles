#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "nokogiri"
require "open-uri"

# Clear my screen
puts "\e[H\e[2J"

# Live amazon wishlist page 1
#page = Nokogiri::HTML(open('http://www.amazon.de/registry/wishlist/1NDL4V6G5ZXMH/?layout=compact'))
# Local amazon wishlist page 1
page = Nokogiri::HTML(open('/home/dennis/amz_wishlist_page1.html'))
# Local test page to test out various things
test = Nokogiri::HTML(open('/home/dennis/amz_test_page.html'))

# Web Scraping according to http://ruby.bastardsbook.com/chapters/html-parsing/
# and http://ruby.bastardsbook.com/chapters/web-crawling/

pagenumber = page.css("span[@class='page-number']")
puts "Pagenumber: #{pagenumber.text}"

itemcount = page.css("span[@id='topItemCount']")
puts "Items on wishlist (all pages): #{itemcount.text}"

exit

# Getting the wishlist css container from the page
wishlist = page.css("html body.noBeaconUI div div#wlMain div.wlNoUnderline div div.list-items div.noUnderline form table.compact-items tbody.itemWrapper")


# Playing around with the wishlist object
puts "Length of items"
puts wishlist.length

#puts "first item:"
#puts wishlist[0]

puts "Title selectors:"
puts wishlist[59].css("span.small strong a").text

puts "URL selectors:"
urlthings = wishlist[59].css("span.small strong a")
urlthings.each{|link| puts link['href']}

puts "Tiny selectors:"
puts wishlist[59].css("span.tiny").text.gsub(/Alle Kaufmöglichkeiten$/,'').strip

puts "Price selectors:"
puts wishlist[59].css("span.price").text

# Generating the markdown list
puts "My Amazon Wishlist - Markdownified"
puts ""

wl_index=0

wishlist.each do |item|
# Get the title and clean it of some external shop references
title = item.css("span.small strong a").text.gsub(/in diesem Shop einkaufen/,'')

# Get the URL of each title
item.css("span.small strong a").each{|link| $url= link['href']}

# Get the autor (or whatever it is) and adjust it for books and DVDs. Leave
# empty if neither "von" nor "DVD" is found.
autor = item.css("span.tiny").text.gsub(/Alle Kaufmöglichkeiten$/,'').strip
if autor =~ /von|DVD/
    autor = autor.gsub(/Angeboten von.*?DVD ~/,'DVD ~')
else
    autor = ""
end

# Get the price
price = item.css("span.price").text

# Output:
puts "#{wl_index.to_s}. [#{title}](#{$url}) #{autor} zu einem Preis von #{price}"

# Increase the counter
wl_index+=1

end

exit
