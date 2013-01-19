#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'colorize'

# Clear my screen
#puts "\e[H\e[2J"

# Check for presence of Corestick
Dir.glob("#{ENV['HOME']}/*/.git", File::FNM_DOTMATCH).each do |git_dir|
    git_work_tree = git_dir.gsub(/\.git/, '')
    git_repo_name = git_work_tree.gsub(/#{ENV['HOME']}/, '').gsub(/\//, '')

    remote_repo=`git --git-dir=/home/dennis/.dotfiles/.git --work-tree=/home/dennis/.dotfiles remote -v | tail -n1`.gsub(/\(.*$/,"").gsub(/^.*?\s/,"").strip
    if File.exists?(remote_repo)
        #puts "Yeah, #{git_repo_name} got a remote."
        #puts ""
    else
        puts "#{git_repo_name} does not find it's remote.".red
        $exit_after_check=1
    end
end

if $exit_after_check == 1
    abort("No remote, no competition...")
end

# Check (Master) branch against corestick
Dir.glob("#{ENV['HOME']}/*/.git", File::FNM_DOTMATCH).each do |git_dir|
    git_work_tree = git_dir.gsub(/\.git/, '')
    git_repo_name = git_work_tree.gsub(/#{ENV['HOME']}/, '').gsub(/\//, '')

    # Check for uncommited changes
    build_git_status=`git --git-dir=#{git_dir} --work-tree=#{git_work_tree} status 2> /dev/null | tail -n1`.gsub(/\n/,"")
    if build_git_status == 'nothing to commit (working directory clean)'
        puts "#{git_repo_name} is clean.".green
        #puts "Status: #{build_git_status}"
    else
        puts "#{git_repo_name} has uncommited changes.".red
        #puts "Status: #{build_git_status}"
    end

    # Check for unpushed changes
    remote_status=`git --git-dir=#{git_dir} --work-tree=#{git_work_tree} remote show corestick 2> /dev/null | tail -n1`.gsub(/\n/,"").strip
    if remote_status =~ /up to date/
        puts "#{git_repo_name} is up to date.".green
        #puts "Status: #{remote_status}"
    else
        puts "#{git_repo_name} needs your attention.".red
        puts "Status: #{remote_status}".yellow
    end
end


exit
