=begin rdoc

= UTILITIES.RB

*Author*::      Tamara Temple <tamara@tamaratemple.com>
*Since*::       2013-02-10
*Copyright*::   (c) 2013 Tamara Temple Web Development
*License*::     MIT
  
=end

require 'methadone'

class Rsyncbackup

  def _run_the_command(cmd)
    Open3.popen3(cmd) do |stdin, stdout, stderr, t|
      pid = t.pid
      stdin.close
      err_thr = Thread.new { copy_lines(stderr, $stderr) }
      puts "Reading STDOUT"
      copy_lines(stdout, $stdout)
      err_thr.join
      t.value
    end
  end

  def copy_lines(str_in, str_out)
    str_in.each_line {|line| str_out.puts line}
  end



  # returns true if the rsync command was successful
  def success?
    (@status.nil?) ? nil : @status.success?
  end


  # returns the command string to execute with all parameters set
  def build_command
    
    cmd = []
    cmd << options[:rsync_cmd]
    cmd << '--dry-run'             if options[:dry_run]
    cmd << '--verbose --progress --itemize-changes' if (options[:verbose] || options[:debug])
    cmd << '--archive'             if options[:archive]
    cmd << '--one-file-system'     if options[:one_file_system]
    cmd << '--hard-links'          if options[:hard_links]
    cmd << '--human-readable'      if options[:human_readable]
    cmd << '--inplace'             if options[:inplace]
    cmd << '--numeric-ids'         if options[:numeric_ids]
    cmd << '--delete'              if options[:delete]
    cmd << "--exclude-file #{options[:exclusions]}" if File.exist?(options[:exclusions])
    cmd << "--link-dest '#{options[:link_dest]}'" if options[:link_dest]
    cmd << ?" + @source + ?"
    cmd << ?" + temp_target_path + ?"
    
    cmd.join(' ')
    
  end
    
  # returns the directory name of the last full backup
  # returns nil otherwise
  def last_full_backup
    
    unless @last_full_backup
      lastfull = File.join(@target,DEFAULT_LAST_FULL_DIR_NAME)
      @last_full_backup = unless File.exist?(lastfull)
                            nil
                          else
                            last_full_directory = IO.readlines(lastfull).first.chomp
                         unless File.exist?(File.join(@target,last_full_directory))
                              nil
                            else
                              last_full_directory
                            end
                          end
    end
    @last_full_backup

  end
  
  # returns the directory name for the current backup
  # directory name consists of a time format: YYYY-MM-DDTHH-MM-SS
  def backup_dir_name
    @backup_dir_name ||= Time.now.strftime("%FT%H-%M-%S")
  end

  # returns the full target path, including backup directory name
  def full_target_path
    @full_target_path ||= File.join(@target, backup_dir_name)
  end

  # returns the temporary target path
  def temp_target_path
    @temp_target_path ||= File.join(@target, DEFAULT_INCOMPLETE_DIR_NAME)
  end
  


  # returns the path to the rsync executable
  # If none found, raises an Exception
  def rsync_executable
    rsync = `which rsync`.chomp
    raise "No rsync executable. Are you sure it\'s installed?" if rsync.empty?
    rsync
  end

  # Strip the trailing directory separator from the rsync
  # source or target.
  #
  # *s*:: string to strip
  def strip_trailing_separator_if_any(s,keep_if_symlink=false)
    s = s.to_s
    s_s = s.sub(%r{#{File::SEPARATOR}+$},'')
    unless keep_if_symlink
      s_s
    else
      File.symlink?(s_s) ? s : s_s
    end
  end

end
