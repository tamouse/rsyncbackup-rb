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

      it "should be nil if no last full backup" do
        syncer.last_full_backup.should be_nil
      end

      it "should be the directory name if there was a last full backup marker" do
        last_full_directory = Time.new(2013,01,01,03,10,00).strftime("%FT%H-%M-%S")
        last_full_file = "#{syncer.options[:target]}/.lastfull"

        File.open(last_full_file,'w') do |fh|
          fh.puts last_full_directory
        end

        syncer.last_full_backup.should == last_full_directory

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

    context "#strip_trailing_separator_if_any" do

      context "with trailing separators" do
        let(:syncer) { Rsyncbackup.new(source: 'source/', target: 'target/') }
        
        it "should respond to #strip_trailing_separator_if_any" do
          syncer.should respond_to(:strip_trailing_separator_if_any)
        end
      
        it "should remove trailing slash from source" do
          syncer.strip_trailing_separator_if_any('source/').should == 'source'
        end
      
        it "should remove trailing slash from target" do
          syncer.strip_trailing_separator_if_any('target/').should == 'target'
        end

      end
      
      context "withOUT trailing separators" do
        let(:syncer) { Rsyncbackup.new(source: 'source', target: 'target') }
        
        it "should respond to #strip_trailing_separator_if_any" do
          syncer.should respond_to(:strip_trailing_separator_if_any)
        end
      
        it "should remove trailing slash from source" do
          syncer.strip_trailing_separator_if_any('source').should == 'source'
        end
      
        it "should remove trailing slash from target" do
          syncer.strip_trailing_separator_if_any('target').should == 'target'
        end
        
      end

    end

  end
  
end
 
