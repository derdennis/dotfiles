#!/usr/bin/env ruby

# Adding the path we live in to the LOAD_PATH
#
# via: http://stackoverflow.com/questions/4687680/what-does-if-file-0-mean-in-ruby
# Constants used in the next few lines:
# __FILE__ : this files name
# $0 : the main file that was run
# $: : LOAD_PATH for require
#
# Only run the following code when this file is the main file being run
# instead of having been required or loaded by another file
if __FILE__==$0
  # Find the parent directory of this file and add it to the front
  # of the list of locations to look in when using require
  $:.unshift File.join(File.expand_path(File.dirname(__FILE__)))
end

# Require some gems
require 'rubygems'
require 'feedjira'
require 'open-uri'
require 'yaml'
require 'pony'
#require '/Users/dennis/bin/it_scripts/pinboard_integration/german_date_names'
# Should be found in current dir after adding the current dir to LOAD_PATH...
require 'german_date_names'

# Determine directory in which we live
@script_dir = File.expand_path(File.dirname(__FILE__))

# Load config from yaml-file, find it in the @script_dir
CONFIG = YAML.load_file("#{@script_dir}/config.yml") unless defined? CONFIG

# Cache file for last bookmarks date ist here:
pinboard_time_file = @script_dir + "/" + CONFIG['pinboard_time_file']
# Store the @tag_array in this yaml file:
tag_file = @script_dir + "/" + CONFIG['tag_file']
# And put the @date_array in this yaml file:
date_file = @script_dir + "/" + CONFIG['date_file']
# And yet another one for the bookmarks:
bookmark_file = @script_dir + "/" + CONFIG['bookmark_file']
# Where to put the finished posts
@blogpost_path = CONFIG['blogpost_path']
# Number of bookmarks per post
bookmarks_per_post = CONFIG['bookmarks_per_post']

# My pinboard feed is here
feed = CONFIG['feed']

##########################################################################################
# Define some functions
##########################################################################################

def show_feed_info
    # Spit out some infos about the feed and the first bookmark
    puts "@rss:"
    puts "-----"
    print "@rss.title: ", @rss.title, "\n" # => "Pinboard (der_dennis)"
    print "@rss.url: ", @rss.url, "\n" # => "http://pinboard.in/u:der_dennis/"
    print "@rss.last_modified: ", @rss.last_modified, "\n" # => "Fri Mar 02 12:52:50 +0100 2012"
    puts " "
    puts "@rss.entries.first:"
    puts "-------------------"
    print "@rss.entries.first.url: ", @rss.entries.first.url, "\n" # => "http://www.swaroopch.com/notes/Vim"
    print "@rss.entries.first.title: ", @rss.entries.first.title, "\n" # => "A Byte of Vim"
    print "@rss.entries.first.published: ", @rss.entries.first.published, "\n" # => "Wed Feb 29 13:28:38 UTC 2012"
    print "@rss.entries.first.summary: ", @rss.entries.first.summary, "\n" # => "is a book which aims to help you to learn how to use the Vim editor (version 7), even if all you know is how to use the computer keyboard."
    print "@rss.entries.first.subject: ", @rss.entries.first.subject, "\n" # => "vim editor book howto"

    puts "=" * 50
end # end def show_feed_info

def bookmark_build
    # Build a nice, formatted bookmark
    # Remove possible newlines at end of bookmark summary
    @entry.summary.gsub! /$\n/, ''
    # Format the bookmark as a markdown link in a markdown list item
    entry_bookmark = "* [#{@entry.title}](#{@entry.url})", " - #{@entry.summary}"

    # Build variables for easy access to metadata
    entry_tags = @entry.subject
    entry_date = @entry.published

    # Put the current tags in the tag array
    @tag_array.concat(entry_tags.split(/ /))

    # Put the current date, converted to integer, converted to string in the date array
    @date_array.concat(entry_date.to_i.to_s.split(/ /))

    # Put the current bookmark in the bookmark array
    @bookmark_array.concat(entry_bookmark.join.to_s.split(/\n/))

    # Sort and uniq the tag array
    @tag_array.sort!
    @tag_array.uniq!

    # Sort and uniq the date array
    @date_array.sort!
    @date_array.uniq!

    # Converting the date array to time objects...
    @date_array.map!{ |x| Time.at(x.to_i) }

    # Save the oldest and newest dates in variables for the post content
    # Format: 13. März 2012
    @oldest_date = @date_array.min.strftime("%d. %B")
    @newest_date = @date_array.max.strftime("%d. %B")

    # Save the oldest and newst dates in variables for the filename
    # Format month: februar
    # Format day: 08
    # If the month is märz, the "ä" gets replaced with "ae"
    @oldest_date_month = @date_array.min.strftime("%B").downcase.gsub /ä/, 'ae'
    @oldest_date_day = @date_array.min.strftime("%d")

    @newest_date_month = @date_array.max.strftime("%B").downcase.gsub /ä/, 'ae'
    @newest_date_day = @date_array.max.strftime("%d")

    # Uniq the bookmark array
    @bookmark_array.uniq!

    # Tell me about the bookmark
    print "Added bookmark ", @entry.title, "\n"
    # Tell me at which number we are
    print "This was bookmark number: ", @bookmark_array.length, "\n"

    # Notify me that the bookmark was added
    message = "Hi #{CONFIG['recipient_name']}, \n\n I just added the following bookmark: \n\n"+ entry_bookmark.join.to_s + " \n\n to the latest Quicklinks-Post. \n\n This was bookmark number " + @bookmark_array.length.to_s + ". \n\n Best, \n\n #{CONFIG['from_name']}"
    subject = "New Bookmark added: " + @entry.title.to_s

    Pony.mail({
        :to => CONFIG['recipient_mail'],
        :from => CONFIG['from_mail'],
        :subject => subject,
        :body => message,
        :via => :smtp,
        :via_options => {
        :address              => CONFIG['smtp_server'],
        :port                 => CONFIG['smtp_port'],
        :enable_starttls_auto => true,
        :user_name            => CONFIG['smtp_user'],
        :password             => CONFIG['smtp_password'],
        :authentication       => :plain,
        :domain               => "localhost.localdomain"
    } # End pony via options
    }) # End Pony.mail

end # end def bookmark_build

def write_blogpost
    # Write the current bookmarks to a blogpost-file
    # Filename-format: 2012-02-24-quicklinks-vom-12-februar-bis-zum-22-februar.markdown
    blogpost = @blogpost_path, Time.now.strftime("%F"), "-", "quicklinks-vom-", @oldest_date_day, "-", @oldest_date_month, "-bis-zum-", @newest_date_day, "-", @newest_date_month, ".markdown"
    # Tell me, that we reached the limit
    print "Reached the bookmark limit per post: ", @bookmark_array.length, ".", " Now writing Blogpost...", "\n"
    # Tell me the filename of the currently written blogpost
    puts blogpost.join.to_s

    # Write the blogpost file
    File.open(blogpost.join.to_s, 'w') do |f|
        f.puts "---"
        f.puts "layout: post"
        # Write the newest and the oldest date. Format: "13. März 2012"
        f.print "title: \"QuickLinks vom ", @oldest_date, " bis zum ", @newest_date, "\"", "\n"
        # Write the current date and time. Format: "2012-03-13 13:21"
        f.print "date: ", Time.now.strftime("%F %R"), "\n"
        f.puts "comments: true"
        f.puts "published: false"
        f.puts "tags:"
        # Spit out the tag array, prefix every tag with '- '
        f.puts @tag_array.map{ |x| x.gsub /^/, '- '}
        f.puts " "
        f.puts "---"
        f.puts " "
        f.print "Meine [pinboard.in-Links](http://pinboard.in/u:der_dennis) vom ", @oldest_date, " bis zum ", @newest_date, ":", "\n"
        f.puts " "
        # Spit out the bookmark array in reverse (newest bookmark first)
        f.puts @bookmark_array.reverse
    end # End the writing of the blogpost

    # Clear the arrays
    @bookmark_array = []
    @tag_array = []
    @date_array = []

    # Notify me that the post is ready

    blogpost_name =  Time.now.strftime("%F"), "-", "quicklinks-vom-", @oldest_date_day, "-", @oldest_date_month, "-bis-zum-", @newest_date_day, "-", @newest_date_month

    message = "Hi #{CONFIG['recipient_name']}, \n\n the latest Quicklinks-Post: \n\n"+ blogpost_name.to_s + " \n\n is ready. \n\n Please check your _drafts-Folder.\n\n Best, \n\n #{CONFIG['from_name']}"
    subject = "New Quicklinks ready: " + blogpost_name.to_s

    # Pony configuration for googlemail, reads almost all values from
    # config.yml
    Pony.mail({
        :to => CONFIG['recipient_mail'],
        :from => CONFIG['from_mail'],
        :subject => subject,
        :body => message,
        :via => :smtp,
        :via_options => {
        :address              => CONFIG['smtp_server'],
        :port                 => CONFIG['smtp_port'],
        :enable_starttls_auto => true,
        :user_name            => CONFIG['smtp_user'],
        :password             => CONFIG['smtp_password'],
        :authentication       => :plain,
        :domain               => "localhost.localdomain"
    } # End pony via options
    }) # End Pony.mail

end # end def write_blogpost

def write_yaml_and_array (yaml, array)
    # Function to dump the content of the arrays into a yaml-file for storing
    # the content between the runs of this script.
    File.open( yaml, 'w' ) do|f|
        f.write YAML.dump(array)
    end
end # end def write_yaml_and_array

def load_array_from_yaml (yaml, array)
    # Load data from possibly existing yaml file (if it is not empty) into the
    # array. If no file exists, create one.
    if File.exists?(yaml) && !File.zero?(yaml)
        File.open( yaml, 'r' ) do|f|
            array.concat(YAML.load(f))
        end
    else
        File.new(yaml, 'w')
    end
end # end def load_array_from_yaml

##########################################################################################
# End of function definitions
##########################################################################################

# If the pinboard_time_file exists and if it is not zero,  get the feed_times
# hash, else create a new one dated back to epoch.
feed_times = if File.exists?(pinboard_time_file) && !File.zero?(pinboard_time_file)
                YAML.load( File.read(pinboard_time_file) )
            else
                Hash.new( Time.mktime('1970') )
            end

# Declare the subject for Feedjira without the "dc:" part because colons can't
# be easily parsed...
Feedjira::Feed.add_common_feed_entry_element('dc:subject', :as => :subject)
# Go and fetch the feed with Feedjira
@rss = Feedjira::Feed.fetch_and_parse(feed)

# Show me some info about the feed
show_feed_info

# Initialize tag array, load from yaml
@tag_array = []
load_array_from_yaml(tag_file, @tag_array)

# Initialize date array, load from yaml
@date_array = []
load_array_from_yaml(date_file, @date_array)

# Initialize bookmark array, load from yaml
@bookmark_array = []
load_array_from_yaml(bookmark_file, @bookmark_array)

# Set the counter i to the current length of the bookmark array
i = @bookmark_array.length

# Loop over the rss feed in reverse to start with the oldest bookmark
@rss.entries.reverse.each do|e|
    @entry = e
    # Only do something, when the publish date is newer than the conserved date
    # from the last run
    if @entry.published > feed_times[feed]
        p @entry
        # Compare the counter "i" against -1 from bookmarks_per_post because
        # arrays start to count at 0.
        # So wee need to write a post at a count of 9, if we want the post to
        # include 10 bookmarks.
        if i < bookmarks_per_post-1
            # Increase the counter
            i += 1
            # Build a bookmark
            bookmark_build

        else
            # If we are here, we reached the limit of bookmarks for one post.
            # So we reset the counter:
            i = 0
            # Build the last bookmark
            bookmark_build
            # Write out the blogpost
            write_blogpost

        end # end the check for the bookmarks counter

        # Update the pinboard_time with the current bookmark's time
        feed_times[feed] = @entry.published
        File.open( pinboard_time_file, 'w' ) do|f|
            f.write YAML.dump(feed_times)
        end # end the updating of the pinboard_time

        # Write the tag array to a yaml-file
        write_yaml_and_array(tag_file, @tag_array)

        # Converting the date array back to unix timestamps and writing to yaml
        @date_array.map!{ |x| x.to_i.to_s }
        # Write the date array to a yaml-file
        write_yaml_and_array(date_file, @date_array)

        # Write the bookmark array to a yaml-file
        write_yaml_and_array(bookmark_file, @bookmark_array)

    end # end the if for the pinboard times check
end # end the @rss.entries.reverse.each
