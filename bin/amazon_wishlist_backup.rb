#!/usr/bin/env ruby
# encoding: utf-8

# Only run the following code when this file is the main file being run
# instead of having been required or loaded by another file
if __FILE__==$0
  # Find the parent directory of this file and add it to the front
  # of the list of locations to look in when using require
  $:.unshift File.join(File.expand_path(File.dirname(__FILE__)))
end

# Require some gems
require "rubygems"
require "nokogiri"
require "open-uri"
# Should be found in current dir after adding the current dir to LOAD_PATH...
require 'german_date_names'

# Web Scraping according to http://ruby.bastardsbook.com/chapters/html-parsing/
# and http://ruby.bastardsbook.com/chapters/web-crawling/
#
# Live amazon wishlist pages:
#http://www.amazon.de/registry/wishlist/1NDL4V6G5ZXMH/?page=1
#http://www.amazon.de/registry/wishlist/1NDL4V6G5ZXMH/?page=2
# ...15
# First Page of Wishlist
WISHLIST_ENTRY = 'http://www.amazon.de/registry/wishlist/1NDL4V6G5ZXMH/'
# Local amazon wishlist pages dir
LOCAL_DIR = '/Users/dennis/Dropbox/amz_wishlist'
LOCAL_WISHLIST = "/Users/dennis/Dropbox/amz_wishlist/dennis_wishlist.markdown"
LOCAL_WISHLIST_HEADER =<<END_WISHLIST_HEADER
Dennis Amazon Wunschliste - Markdownified
=========================================

Hier ist auch noch [das Original bei Amazon](#{WISHLIST_ENTRY})...

Es folgt der Stand vom: #{Time.now.strftime('%d. %B %Y - %R')}

END_WISHLIST_HEADER


page = Nokogiri::HTML(open(WISHLIST_ENTRY))
#page = Nokogiri::HTML(open("~/Dropbox/amz_wishlist/amz_w_1.html"))

current_pagenumber = page.css("span[@class='page-number']")
puts "Current pagenumber: #{current_pagenumber.text}"

number_of_pages = page.css("span[@class='num-pages']").text
puts "Number of pages: #{number_of_pages}"

number_of_pages="3" #FIXME

itemcount = page.css("span[@id='topItemCount']")
puts "Items on wishlist (all pages): #{itemcount.text}"


 #Getting the whole wishlist from amazon.de
#for pg_number in 1..number_of_pages.to_i do
    #remote_url = "#{WISHLIST_ENTRY}?page=#{pg_number}"
    #local_filename = "#{LOCAL_DIR}/amz_w_#{pg_number}.html"
    #puts "Fetching #{remote_url}..."

    #begin
        #wishlist_content = open(remote_url).read
    #rescue Exception=>e
        #puts "Error: #{e}"
        #sleep 5
    #else
        #File.open(local_filename, 'w'){|file| file.write(wishlist_content)}
        #puts "\t...Success, saved to #{local_filename}"
    #ensure
        #sleep 1.0 + rand
    #end   done: begin/rescue



#end

# Overwrite the local wishlist and put the header inside
File.open(LOCAL_WISHLIST, 'w') do |f|
    f.puts LOCAL_WISHLIST_HEADER
end

# Iterating through local files
wl_index=1
for pg_number in 1..number_of_pages.to_i do
    puts "Processing #{LOCAL_DIR}amz_w_#{pg_number}.html"

page = Nokogiri::HTML(open("#{LOCAL_DIR}/amz_w_#{pg_number}.html"))

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
            #puts "#{wl_index.to_s}. [#{title}](#{$url}) #{author} zu einem Preis von #{price}"

            File.open(LOCAL_WISHLIST, 'a') do |f|
                f.puts "#{wl_index.to_s}. [#{title}](#{$url}) #{author} zu einem Preis von #{price}"
            end
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
