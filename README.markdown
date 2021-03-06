This is a Menu Bar wrapper for hostfiles (the cli Perl script for managing multiple hostfile configurations on *NIX systems).

To get started you need to install hostfiles and get it up and running.  You can find more information at https://github.com/Aneurysm9/hostfile_manager.  After this drag the application to your Applications folder and then double-click it ifrom there to run it.

![Screenshot](/ezarko/HostfileManager-OSX-GUI/raw/master/hmss.png)

Using the hostfile manager is simple.  Click on the grasshopper icon in the Menu Bar, then click on a named hostfile to enable/disable it.  A checkmark indicates that the hostfile fragment is enabled and unmodified.  A minus sign indicates that the hostfile fragment is enabled, but has been modified.

Changes:
    0.3 - 1/14/2011
    * Added refresh capability.
    
    0.2 - 11/24/2010
    * Moved auth from local to instance variable (making it ask for authentication once instead of for every operation).
    * Added README and TODO files to disk image.
    
    0.1 - 11/24/2010
    * Initial version.
