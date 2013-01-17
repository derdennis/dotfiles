#!/usr/bin/env ruby
# encoding: utf-8

# Clear my screen
puts "\e[H\e[2J"

Dir.glob("/home/dennis/*/.git", File::FNM_DOTMATCH).each do |git_dir|
    git_work_tree = git_dir.gsub(/\.git/, '')
    git_repo_name = git_work_tree.gsub(/\/home\/dennis\//, '').gsub(/\//, '')

    build_git_status=`git --git-dir=#{git_dir} --work-tree=#{git_work_tree} remote show corestick 2> /dev/null | tail -n1`.gsub(/\n/,"").strip
    if build_git_status =~ /up to date/
        puts "#{git_repo_name} is up to date."
        puts "Status: #{build_git_status}"
        puts ""
    else
        puts "#{git_repo_name} needs your attention."
        puts "Status: #{build_git_status}"
        puts ""
    end
end


exit
