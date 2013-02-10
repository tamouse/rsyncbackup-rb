=begin rdoc

= UTILITIES.RB

*Author*::      Tamara Temple <tamara@tamaratemple.com>
*Since*::       2013-02-10
*Copyright*::   (c) 2013 Tamara Temple Web Development
*License*::     MIT
  
=end

require 'methadone'

class Rsyncbackup
  
  def build_command
    
    cmd = []
    cmd << options[:rsync_cmd]
    cmd << '--verbose --progress --itemize-changes' if logger.info?
    cmd << '--archive'             if options[:archive]
    cmd << '--one-file-system'     if options[:one_file_system]
    cmd << '--hard-links'          if options[:hard_links]
    cmd << '--human-readable'      if options[:human_readable]
    cmd << '--inplace'             if options[:inplace]
    cmd << '--numeric-ids'         if options[:numeric_ids]
    cmd << '--delete'              if options[:delete]
    cmd << "--exclude-file #{options[:exclusions]}" if File.exist?(options[:exclusions])
    cmd << "--link-dest #{options[:link_dest]}" if options[:link_dest] || last_full_backup
    cmd << options[:source]
    cmd << "#{options[:target]}/.incomplete"
    
    cmd.join(' ').tap{|t| debug "Command: #{t}" }
    
  end
    
  def last_full_backup
    
    lastfull = "#{options[:target]}/.lastfull"
    if File.exist?(lastfull)
      options[:link_dest] = IO.readlines(lastfull).first.chomp
    end
    return false if options[:link_dest].nil?
    !options[:link_dest].empty?

  end
  
  def backup_dir_name
    Date.new.strftime("%FT%H-%M-%S")
  end

  def rsync_executable
    rsync = `which rsync`.chomp
    raise "No rsync executable. Are you sure it's installed?" if rsync.empty?
    rsync
  end


end
