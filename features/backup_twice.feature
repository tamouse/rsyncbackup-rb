Feature: Perform Backups
  In order to ensure files are correctly backed up
  I will need to run the backup script
  
  @announce
  Scenario: Run a backup from source to target
    Given a directory named "source"
    Given a file named "source/one" with:
      """
      xxxx
      """
    Given a file named "source/two" with:
      """
      xxxx
      """
    Given a directory named "target"
    When I successfully run `rsyncbackup --debug source target`
    Then a file named "target/.lastfull" should exist
    And a directory named "target/.incomplete" should not exist
    When I successfully run `rsyncbackup --debug source target`
    Then a file named "target/.lastfull" should exist
    And a directory named "target/.incomplete" should not exist
    And the output should not contain "--link-dest arg does not exist:"
    


    
    

