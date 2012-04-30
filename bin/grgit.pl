#!/usr/bin/perl
use strict;
use warnings;
use 5.010001;
use LWP::Simple qw{get};
use Readonly;
use Carp;
use Data::Dumper;
use IPC::Open3 'open3';

Readonly my $GIT_SERVER     => 'git.greptilian.com';
Readonly my $PROJECT_INDEX  => "http://$GIT_SERVER/?a=project_index";
Readonly my $PROJECT_DIR    => '/var/lib/git';
Readonly my $LOCAL_GIT_DIR  => "$ENV{HOME}/gr";
Readonly my $GIT_CLONE_PATH => "$GIT_SERVER:$PROJECT_DIR";
Readonly my $DOTDOT         => q{..};
Readonly my $FILES_NON_DOT  => q{*};

chdir($LOCAL_GIT_DIR) or croak "Couldn't cd to $LOCAL_GIT_DIR";

my $project_list = get($PROJECT_INDEX);

if ( !$project_list ) {
    croak "Couldn't download project index from $PROJECT_INDEX";
}

my @projects = split( /\n/, $project_list );
for my $project_bare (@projects) {
    $project_bare =~ s/\s+$//;
    my ($project_local) = split( /[.]git$/, $project_bare );
    if ( chdir($project_local) ) {
        printf( 'cd %-30s', "$project_local... " );
        #say glob($FILES_NON_DOT);
        my ( $writer, $reader, $err );
        open3( $writer, $reader, $err, 'git pull' );
        while ( my $line = <$reader> ) {
            print {*STDOUT} $line
              unless $line =~
/^Address 72.93.243.251 maps to vps.v2s.org, but this does not map back to the address - POSSIBLE BREAK-IN ATTEMPT!\s*$/;
        }
        chdir($DOTDOT);
    }
    else {
        print
"Could not cd to $project_local. Clone with:\ngit clone $GIT_CLONE_PATH/$project_bare\n;";
    }
}