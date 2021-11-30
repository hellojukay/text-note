#!/usr/bin/env perl
use strict;
use warnings;

sub gen_title($){
    my $file = $_[0];
    my $title = `grep title -m 1 $file`;
    $title = $title =~ s/\r?\n//r;
    if ($title =~ m/title:/) {
       my @title = split /:/ ,$title;
       return $title[1];
    }
    return "unknown title";
}

open(my $fd, ">README.md");
print $fd "# note-text\n\n";
print $fd "Table of Contents\n=================\n";
my @dirs = `ls src`;
for my $dir (@dirs) {
    chomp $dir;
    my @files = glob "src/$dir/*";
    printf $fd  "- %s\n", $dir;
    for my $file (@files){
        next if( not -f $file);
        my $title = sprintf "\t- [%s](%s)\n",gen_title($file),$file;
        print $fd $title;
    }
}
close $fd;

# 提交代码
system("git add .");
system("git commit -m 'update'");
system("git push");
