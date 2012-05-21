#!/usr/bin/perl
use strict;
use warnings;
use 5.010000;
use LWP::Simple qw{get};
use Readonly;
use Carp;
use Data::Dumper;
use IPC::Open3 'open3';
use YAML;

Readonly my $GIT_SERVER     => 'git.greptilian.com';
Readonly my $GIT_USER       => 'pdurbin';
Readonly my $PROJECT_INDEX  => "http://$GIT_SERVER/?a=project_index";
Readonly my $PROJECT_DIR    => '/var/lib/git';
Readonly my $LOCAL_GIT_DIR  => "$ENV{HOME}/gr";
Readonly my $GIT_CLONE_PATH => "$GIT_SERVER:$PROJECT_DIR";
Readonly my $DOTDOT         => q{..};
Readonly my $FILES_NON_DOT  => q{*};
Readonly my $DESCRIPTIONS =>
"http://$GIT_SERVER/?p=wiki.git;a=blob_plain;f=greptilian.com/git/repos.mdwn;hb=HEAD";

chdir($LOCAL_GIT_DIR) or croak "Couldn't cd to $LOCAL_GIT_DIR";

my $project_list = get($PROJECT_INDEX);

if ( !$project_list ) {
    croak "Couldn't download project index from $PROJECT_INDEX";
}

my $descriptions = get($DESCRIPTIONS);

if ( !$descriptions ) {
    croak "Couldn't download git repo descriptions from $DESCRIPTIONS";
}

#print $descriptions;
my $desc_dd = Load($descriptions);
#print Dumper $desc_dd;
for my $repo ( keys %$desc_dd ) {
    #print $repo;
}

my @projects = split( /\n/, $project_list );
for my $project_bare (@projects) {
    my ($project_local) = $project_bare =~ /^(.*?)[.]git/;
    if ( chdir($project_local) ) {
        printf( 'cd %-30s', "$project_local... " );
        #say glob($FILES_NON_DOT);
        my ( $writer, $reader, $err );
        open3( $writer, $reader, $err, 'git pull' );
        while ( my $line = <$reader> ) {
            print {*STDOUT} $line
              unless $line =~ /POSSIBLE BREAK-IN ATTEMPT/;
        }
        chdir($DOTDOT);
    }
    else {
        print
"Could not cd to $project_local. Clone with:\ngit clone $GIT_USER\@$GIT_CLONE_PATH/$project_local.git\n";
    }
}
