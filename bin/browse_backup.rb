#!/usr/bin/ruby

base_dir = "/Users/dennis/backup/rsnapshot/"
link_dir = "/Users/dennis/backup/browse_backup/"
rs_conf = "/opt/local/etc/rsnapshot.conf"
conf = File.open(rs_conf)
folders = []
backups = conf.select { |line| /^backup/ =~ line}
backups.each { |entry|
   name = entry.split[2].chop!
   folders << name
}

folders.each {|folder|
   Dir.open(base_dir).each {|entry|
       unless entry.include? 'lost+found' or entry == '.' or entry == '..'
           mtime = File.open(base_dir+entry).mtime
           link_name = mtime.mon.to_s+"-"+mtime.day.to_s+"-"+mtime.year.to_s
           begin
               if File.symlink?(link_dir+folder+"/"+link_name)
                   p "Removing old links for #{folder}"
                   File.delete(link_dir+folder+"/"+link_name)
               end
               p "Creating new links for #{folder}"
               File.symlink(base_dir+entry+"/"+folder+"/"+folder, link_dir+folder+"/"+link_name)
           rescue SyntaxError, NameError, StandardError
               p "links creation failed! Error: #{$!}"
           end
       end
   }
}
