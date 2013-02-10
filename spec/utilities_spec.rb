=begin rdoc

= UTILITIES_SPEC.RB

*Author*::      Tamara Temple <tamara@tamaratemple.com>
*Since*::       2013-02-10
*Copyright*::   (c) 2013 Tamara Temple Web Development
*License*::     MIT
  
=end

describe Rsyncbackup do
  context "utilities" do
    
    context "#build_command" do
      let(:syncer) { Rsyncbackup.new(source: 'source', target: 'target') }
      
      it { syncer.should respond_to(:build_command) }

      it "should build a valid command" do
        cmd = syncer.build_command
        cmd.should =~ /--archive/
        cmd.should =~ /--one-file-system/
        cmd.should =~ /--hard-links/
        cmd.should =~ /--human-readable/
        cmd.should =~ /--inplace/
        cmd.should =~ /--numeric-ids/
        cmd.should =~ /--delete/
        cmd.should =~ /source/
        cmd.should =~ /target\/\.incomplete/
      end
    end
    
    context "#last_full_backup" do
      let (:syncer) { Rsyncbackup.new(source: 'source', target: '/tmp') }

      it { syncer.should respond_to(:last_full_backup) }

      it "should be false if no last full backup" do
        syncer.last_full_backup.should be_false
      end

      it "should be true if there was a last full backup marker" do
        last_full_time = Time.new(2013,01,01,03,10,00).strftime("%FT%H-%M-%S")
        last_full_file = "#{syncer.options[:target]}/.lastfull"

        File.open(last_full_file,'w') do |fh|
          fh.puts last_full_time
        end

        syncer.last_full_backup.should be_true

        syncer.options[:link_dest].should == last_full_time
        File.unlink last_full_file
      end
        
    end




    context "#backup_dir_name" do
      let(:syncer) { Rsyncbackup.new(source: 'source', target: 'target') }

      it { syncer.should respond_to(:backup_dir_name) }

      it "should give a valid backup directory name: YYYY-MM-DDTHH-MM-SS" do
        name = syncer.backup_dir_name
        name.should =~ /(\d){4}-(\d){2}-(\d){2}T(\d){2}-(\d){2}-(\d){2}/
      end

    end


  end
  
end
 
