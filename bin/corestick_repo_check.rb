#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'colorize'

# Clear my screen
#puts "\e[H\e[2J"

# Define an array for the repos
repos = Array.new
# Define an array of repo names to ignore
ignore_repo_names = ["crm_pcs", "lalala" ]

# Add the repos in my home dir (Should be instant-thinking and dotfiles)
Dir.glob("#{ENV['HOME']}/*/.git", File::FNM_DOTMATCH).each do |repo_dir|
    unless ignore_repo_names.any?{ |s| repo_dir.include?(s)}
        repos << repo_dir
    end
end

# Add the repos from ~/code/*
Dir.glob("#{ENV['HOME']}/code/*/.git", File::FNM_DOTMATCH).each do |repo_dir|
    unless ignore_repo_names.any?{ |s| repo_dir.include?(s)}
        repos << repo_dir
    end
end

# Use a function to get the work tree and the repo name of the repos
def get_git_tree_and_name(repo_dir)
    @git_dir = repo_dir
    @git_work_tree = @git_dir.gsub(/\.git/, '')
    @git_repo_name = @git_work_tree.gsub(/#{ENV['HOME']}/, '').gsub(/\//, '').gsub(/^code/, '')
end

# Check for presence of Corestick
repos.each do |repo_dir|
    # Call the function for name and tree of repo
    get_git_tree_and_name(repo_dir)
    remote_repo=`git --git-dir=#{@git_dir} --work-tree=#{@git_work_tree} remote -v | grep corestick | tail -n1`.gsub(/\(.*$/,"").gsub(/^.*?\s/,"").strip
    if File.exists?(remote_repo)
        #puts "Yeah, #{@git_repo_name} got a remote."
        #puts ""
    else
        puts "#{@git_repo_name} does not find it's remote.".red
        $exit_after_check=1
    end
end

if $exit_after_check == 1
    abort("No remote, no competition...")
end

# Check (Master) branch against corestick
repos.each do |repo_dir|
    # Call the function for name and tree of repo
    get_git_tree_and_name(repo_dir)
    # Check for uncommited changes
    build_git_status=`git --git-dir=#{@git_dir} --work-tree=#{@git_work_tree} status 2> /dev/null | tail -n1`.gsub(/\n/,"")
    if build_git_status.include? 'working directory clean'
        puts "#{@git_repo_name} is clean.".green
        #puts "Status: #{build_git_status}"
    else
        puts "#{@git_repo_name} has uncommited changes.".red
        #puts "Status: #{build_git_status}"
    end

    # Check for unpushed changes (This does not work reliably if there are multiple branches)
    remote_status=`git --git-dir=#{@git_dir} --work-tree=#{@git_work_tree} remote show corestick 2> /dev/null | tail -n1`.gsub(/\n/,"").strip
    if remote_status =~ /up to date/
        puts "#{@git_repo_name} is up to date.".green
        #puts "Status: #{remote_status}"
    else
        puts "#{@git_repo_name} needs your attention.".red
        puts "Status: #{remote_status}".yellow
    end
end


exit
