#!/usr/bin/env ruby
# encoding: utf-8

# Gems and Bundler
require 'rubygems'
require 'bundler/setup'
# Regular gems
require 'nokogiri'
require 'simple-rss'
require 'open-uri'
require 'yaml'
require "stringex"
require 'pony'

# Determine directory in which we live
@script_dir = File.expand_path(File.dirname(__FILE__))
# Cache file for the last checked time is here
flickr_times_file = @script_dir + "/" + "lastcheck.yml"
# RSS 2.0 feed of my flickr-photos with tag "photoblog":
#photoblogfeed = "http://api.flickr.com/services/feeds/photos_public.gne?id=51035772011@N01&lang=de-de&tags=photoblog&format=rss_200"
photoblogfeed = "https://api.flickr.com/services/feeds/photos_public.gne?id=51035772011@N01&lang=de-de&format=rss_200"
# Local test feed
#photoblogfeed = "flickr-example-feed.xml"
# Path to images folder in Dropbox
images_folder = "/Users/dennis/Dropbox/blog/images/"
# Path to drafts folder in Dropbox
drafts_folder = "/Users/dennis/Dropbox/blog/_drafts/"

# If the flickr_times file exists, load the content from the yaml into a hash
# else create a new one and date it on 1970.
flickr_times = if File.exists?(flickr_times_file)
                   YAML.load( File.read(flickr_times_file) )
               else
                   Hash.new( Time.mktime('1970') )
               end

# Fetch and parse the feed with SimpleRSS
rss = SimpleRSS.parse open(photoblogfeed)

# Tell me you're actually doing something...
puts "Checking #{photoblogfeed} for photoblog photos..."
puts "=" * 50

# Walk the feed in reverse so we see the oldest entry first
rss.entries.reverse.each_with_index do|photo,idx|
    # Do nothing if the photo has no tags
    unless photo.media_category.nil? == true
        #If the publication date of the current photo is newer than the date in our
        #hash, extract some metadate from the feed entry
        if (photo.pubDate > flickr_times[photoblogfeed]) && (photo.media_category.downcase.include? "photoblog")
            # The photos title
            title = photo.title.force_encoding 'utf-8'
            # The link to the photos flickr page
            flickr_page_link = photo.link
            # Format the publication date suitable for Octopress.
            pub_date = photo.pubDate.strftime('%Y-%m-%d %H:%M')
            # The URL where we can find a 1024x768 version of the photo to download
            download_url = photo.media_content_url
            # A nice filename for storing the photo locally
            file_name = "#{photo.pubDate.strftime('%Y-%m-%d-%H%M')}-#{title.to_url}.jpg"
            # A nice name in an Octopress suitable format for the draft file
            draft_name = "#{photo.pubDate.strftime('%Y-%m-%d')}-#{title.to_url}.markdown"
            # Put the flickr tags of the photo into an array
            tags = photo.media_category.split(' ')
            # Delete tags from Flickr's iOS-App. Stuff like: "uploaded:by=flickrmobile",
            # "flickriosapp:filter=nofilter""
            tags.delete_if { |tag| tag.start_with?("uploaded:by=", "flickriosapp:filter=") }
            # Add two nice standard tags to the Octpress tag list
            tags.push("flickr", "photo")
            # Add the "- " before each tag.
            tags.map! { |tag| "- #{tag}" }

            # Download the photo file to the appropriate Dropbox folder.
            open(download_url) {|f|
                File.open(images_folder + file_name, "wb") do |file|
                    file.puts f.read
                end
            }
            # The draft head filled with the variables from flickr.
            draft_head = %{---
layout: post
title: "#{title}"
date: #{pub_date}
comments: true
published: false
tags:}
# The flickr tags preceeded by a "- " from the array above.
draft_tags = tags

# The text with the new file_name of the downloaded photo and the link
# back to flickr.
draft_text = %{
---

{% fancy center #{file_name} %}

Dieses Foto [bei Flickr](#{flickr_page_link}).
}


# Create a new draft file in the _drafts folder and fill it with the
# three elements for a nicely prefilled piece of text
File.open(drafts_folder + draft_name, 'w') do |f|
    f.puts draft_head
    f.puts draft_tags
    f.puts draft_text
end

# Update the hash with the time from the post just twittered
flickr_times[photoblogfeed] = photo.pubDate
# Write the hash back to the cache file
File.open( flickr_times_file, 'w' ) do|f|
    f.write YAML.dump(flickr_times)
end

# Sleep for 60 seconds
sleep 10
# If the photo is not newer than our last run, tell me about this
        else
            puts "This photo from #{photo.pubDate} is not newer than #{flickr_times[photoblogfeed]} and/or is not tagged with photoblog."
        end # End if photo.updated
    end
end # End rss.entries.reverse
