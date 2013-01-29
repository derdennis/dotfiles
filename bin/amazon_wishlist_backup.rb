#!/usr/bin/env ruby
# encoding: utf-8

# Web Scraping according to http://ruby.bastardsbook.com/chapters/html-parsing/
# and http://ruby.bastardsbook.com/chapters/web-crawling/

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
# Use german date names. The file should be found in current dir after adding the
# current dir to LOAD_PATH...
require 'german_date_names'

# First Page of Wishlist
WISHLIST_ENTRY = 'http://www.amazon.de/registry/wishlist/1NDL4V6G5ZXMH/'
# Local amazon wishlist pages dir
LOCAL_DIR = '/Users/dennis/Dropbox/amz_wishlist'
# Name of the local wishlist in the local dir
LOCAL_WISHLIST = "dennis_wishlist.markdown"
# A nice header for the wishlist
LOCAL_WISHLIST_HEADER =<<END_WISHLIST_HEADER
Dennis Amazon Wunschliste - Markdownified
=========================================

Hier ist auch noch [das Original bei Amazon](#{WISHLIST_ENTRY})...

Es folgt der Stand vom: #{Time.now.strftime('%d. %B %Y - %R')}

------------------------------------------------------------------ 

END_WISHLIST_HEADER

# Open the first page of the wishlist at amazon.de
page = Nokogiri::HTML(open(WISHLIST_ENTRY))

# Get some usefull information from the first page
current_pagenumber = page.css("span[@class='page-number']")
puts "Current pagenumber: #{current_pagenumber.text}"

number_of_pages = page.css("span[@class='num-pages']").text
puts "Number of pages: #{number_of_pages}"

itemcount = page.css("span[@id='topItemCount']")
puts "Items on wishlist (all pages): #{itemcount.text}"

#Getting the whole wishlist from amazon.de
for pg_number in 1..number_of_pages.to_i do
    remote_url = "#{WISHLIST_ENTRY}?page=#{pg_number}"
    local_filename = "#{LOCAL_DIR}/amz_w_#{pg_number}.html"
    puts "Fetching #{remote_url}..."

    begin
        wishlist_content = open(remote_url).read
    rescue Exception=>e
        puts "Error: #{e}"
        sleep 5
    else
        File.open(local_filename, 'w'){|file| file.write(wishlist_content)}
        puts "\t...Success, saved to #{local_filename}"
    ensure
        sleep 1.0 + rand
    end #  done: begin/rescue
end # done: for pg_number

# Overwrite the local wishlist and put the header inside
File.open("#{LOCAL_DIR}/#{LOCAL_WISHLIST}", 'w') do |f|
    f.puts LOCAL_WISHLIST_HEADER
end

# Using a simple index to enumerate the list of wishlist items
wl_index=1
# Iterating through local files, using nokogiri to extract the needed
# informations: title, url, author, and price. 
for pg_number in 1..number_of_pages.to_i do
    puts "Processing #{LOCAL_DIR}amz_w_#{pg_number}.html"

    page = Nokogiri::HTML(open("#{LOCAL_DIR}/amz_w_#{pg_number}.html"))
    # Extract the wishlist table from the page
    wishlist = page.css("div[@class='list-items']")

    # Iterate through the items of the wishlist table
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

            # Append the found information to the local wishlist file
            File.open("#{LOCAL_DIR}/#{LOCAL_WISHLIST}", 'a') do |f|
                f.puts "#{wl_index.to_s}. [#{title}](#{$url}) #{author} zu einem Preis von #{price}"
            end
            # Increase the counter
            wl_index+=1
        end # done: current_item.each
    end # done: wishlist.each
end # done: for pg_number

exit
