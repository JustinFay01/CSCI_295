use strict;
use warnings;

# Will Only Search one directory deep
# Will Only pull current branch
# Will attempt to pull as long as there is one remote branch

if(@ARGV != 1){ # Total Length of array 
    print("Please enter a valid directory.\n" . 
    "Make sure to use \\\\ to seperate directories.");
    exit 0;
}

my $baseDir = $ARGV[0];
opendir my $x, $baseDir or die "Cannot open directory: $!";
#my $baseDir = "C:\\Users\\justi\\CSCI_School\\265";

my @files = readdir $x;
closedir $x;
chdir $baseDir;
my %git;

foreach (@files){
    if(-d $_) { # if it is a directory and not a file
        print("Checking: " . $_ . "\n");
        if(checkGit($baseDir, $_)){
           # $git{$_} = gitPull($baseDir, $_);
        }
    }
}

printGit(\%git);

# END OF PROGM

# Final print format for all repositores that were pulled
# uses hash passed as first param 
sub printGit {
    my $gitRef = $_[0]; #Dereference passed hash
    my %gitResults = %$gitRef;
    print("\n");
    foreach my $key (keys %gitResults){
        print("Found git folder in directory: " . $key . "\n\n"); 
        if(exists($gitResults{$key})){
            print("Results of pull:\n" . $gitResults{$key}->[0] . "\n");
        }
        
    }
}

# Works as a helper function to make pull from a 
# Given directory as the first param
# and returns an array of gits output
sub gitPull { # (No params)
    # check if there is a remote branch
    my @remoteBranches = `git branch -r`;
    if(@remoteBranches >= 1 ? 1 : 0){
        my @gitPullRequest = `git pull`;
        chdir $_[0]; # Back to dir that was input
        return \@gitPullRequest;
    }
    else{
        return -1;
    } 
}


sub loadResultHash { # (ref to Array of pull results, $folder as key)
    if($_[0] == -1){ # Not an array and therefore no git pull made
        return 1;
    }

    my $arrRef = $_[0]
    # Is a git pill load global hash with results
    $git{$_[1]} = $arrRef->[0];
}

# Works as a helper function to check a given directory for
# a .git folder, returns boolean if there is a .git folder inside
# Also check if there is a remote branch being tracked 
sub checkGit {  # (Current Dir, Next Folder)
    my $newDir = $_[0] . "\\" . $_[1];
    opendir my $curr, $newDir or die "Cannot open to check for git! Error in: $!";
    my @files = readdir $curr;;
    print("Now in sub dir: " . $newDir . "\n");
    foreach (@files){
        print("Now checking file/dir: " . $_ . "\n");
        if($_ eq ".git"){ # git folder found, now check for remote branch
            chdir $newDir; # Change dir to execute git pull
            # git pull? 
            loadResultHash(gitPull(), $_[1]);
            print("\n\n");
        }
        elsif(-d $_ && $_ ne ".vscode" && $_ ne "\." && $_ ne ".." && $_ ne "windows32"){
            print("Found another dir! going recursive! " . $_ . "\n");
            checkGit($newDir, $_);
        }
    }
    chdir $baseDir;
    print("\n\n");
    return 0;
}