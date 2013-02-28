Feature: File names with spaces
  In order to ensure file names with spaces are correctly handled
  
  Scenario: Use spaces in file names
    Given a directory named "this source"
    Given a file named "this source/one" with:
      """
      xxxx
      """
    Given a file named "this source/two" with:
      """
      xxxx
      """
    Given a directory named "this target"
    When I successfully run `rsyncbackup --log-level debug 'this source' 'this target'`
    Then a file named "this target/.lastfull" should exist
    And a directory named "this target/.incomplete" should not exist
    


    
    

