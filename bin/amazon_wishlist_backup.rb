#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "nokogiri"
require "open-uri"

# Clear my screen
puts "\e[H\e[2J"

# Live amazon wishlist pages:
#http://www.amazon.de/registry/wishlist/1NDL4V6G5ZXMH/?page=1
#http://www.amazon.de/registry/wishlist/1NDL4V6G5ZXMH/?page=2
#http://www.amazon.de/registry/wishlist/1NDL4V6G5ZXMH/?page=3
#http://www.amazon.de/registry/wishlist/1NDL4V6G5ZXMH/?page=4
# ...15
# Local amazon wishlist pages
LOCAL_DIR = '/home/dennis/amz_wishlist_test'
page = Nokogiri::HTML(open("/home/dennis/amz_wishlist_test/amz_w_1.html"))
# Web Scraping according to http://ruby.bastardsbook.com/chapters/html-parsing/
# and http://ruby.bastardsbook.com/chapters/web-crawling/

current_pagenumber = page.css("span[@class='page-number']")
puts "Current pagenumber: #{current_pagenumber.text}"

number_of_pages = page.css("span[@class='num-pages']").text
puts "Number of pages: #{number_of_pages}"
number_of_pages="3" #FIXME
itemcount = page.css("span[@id='topItemCount']")
puts "Items on wishlist (all pages): #{itemcount.text}"

# Iterating through local files
wl_index=0
for pg_number in 1..number_of_pages.to_i do
    puts "Getting #{LOCAL_DIR}amz_w_#{pg_number}.html"

page = Nokogiri::HTML(open("/home/dennis/amz_wishlist_test/amz_w_#{pg_number}.html"))

    wishlist = page.css("div[@class='list-items']")



    wishlist.each do |item|
        current_item = item.css("tbody[@class='itemWrapper']")
        current_item.each do |stuff|
            title = stuff.css("span[@class='small productTitle']").text.gsub(/in diesem Shop einkaufen/,'').strip

            # Get the URL of each title
            stuff.css("span[@class='small productTitle'] strong a").each{|link| $url=link['href']}
            # Get the author, or whatever it is...
            author = stuff.css("span[@class='authorPart']").text.strip

            # Get the price
            price = stuff.css("span[@class='wlPriceBold']").text

            # Output:
            puts "#{wl_index.to_s}. [#{title}](#{$url}) #{author} zu einem Preis von #{price}"

            # Increase the counter
            wl_index+=1
        end # done: current_item.each
    end # done: wishlist.each
end # done: for pg_number

exit





#puts "first item:"
#puts wishlist[0]

#puts "Title selectors:"
#puts wishlist[59].css("span.small strong a").text

#puts "URL selectors:"
#urlthings = wishlist[59].css("span.small strong a")
#urlthings.each{|link| puts link['href']}

#puts "Tiny selectors:"
#puts wishlist[59].css("span.tiny").text.gsub(/Alle Kaufmöglichkeiten$/,'').strip

#puts "Price selectors:"
#puts wishlist[59].css("span.price").text

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


# Output:
puts "#{wl_index.to_s}. [#{title}](#{$url}) #{autor} zu einem Preis von #{price}"

# Increase the counter
wl_index+=1

end

exit
