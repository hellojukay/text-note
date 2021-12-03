#!/usr/bin/env perl
use strict;
use warnings;

sub gen_title($) {
    my $file  = $_[0];
    my $title = `grep title -m 1 $file`;
    $title = $title =~ s/\r?\n//r;
    if ( $title =~ m/title:/ ) {
        my @title = split /:/, $title;
        return $title[1];
    }
    return "unknown title";
}

open( my $fd, ">README.md" );
print $fd "# note-text\n\n";
print $fd "Table of Contents\n=================\n";
my @dirs = `ls src`;
@dirs = reverse( sort @dirs );
for my $dir (@dirs) {
    chomp $dir;
    my @files = reverse( glob "src/$dir/*" );
    printf $fd "<h2>%s<h2>", $dir;
    printf $fd "<ul>";
    for my $file (@files) {
        next if ( not -f $file );
        my $title = sprintf "<li><a href=\"%s\">%s</a></li>", $file, gen_title($file);
        print $fd $title;
    }
    printf $fd "</ul>";
    printf $fd "<hr />";
}
close $fd;

# 提交代码
system("git add .");
system("git commit -m 'update'");
system("git push");
