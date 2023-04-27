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

my $dir = $ARGV[0];
opendir my $x, $dir or die "Cannot open directory: $!";
#my $dir = "C:\\Users\\justi\\CSCI_School\\265";

my @files = readdir $x;
closedir $x;
chdir $dir;
my %git;

foreach (@files){
    if(-d $_) { # if it is a directory and not a file
        if(checkGit($_)){
            $git{$_} = gitPull($_);
        }
    }
}

printGit(\%git);

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
sub gitPull { # (String path)
    my $newDir = $dir . "\\" . $_[0];
    chdir $newDir or die "Cannot open to pull! Error in dir: $!";;
    my @gitPullRequest = `git pull`;
    chdir $dir;
    return \@gitPullRequest;
}

# Works as a helper function to check a given directory for
# a .git folder, returns boolean if there is a .git folder inside
# Also check if there is a remote branch being tracked 
sub checkGit {  # (String path)
    my $newDir = $dir . "\\" . $_[0];
    opendir my $curr, $newDir or die "Cannot open to check for git! Error in: $!";
    my @files = readdir $curr;

    foreach (@files){
        if($_ eq ".git"){ # git folder found, now check for remote branch
            chdir $newDir;
            my @remoteBranches = `git branch -r`;
            chdir $dir;
            return @remoteBranches == 1 ? 1 : 0;
        }
    }
    return 0;
}