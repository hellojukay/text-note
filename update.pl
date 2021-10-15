#!/usr/bin/env perl
use strict;
use warnings;

sub gen_title($){
    my $file = $_[0];
    open my $fh, '<',$file or warn "can not open file $file";
    my $firstLine = <$fh>; 
    chomp $firstLine;
    close $file;
    if ($firstLine =~ m/title:/) {
       my @title_line = split /:/ ,$firstLine;
       return $title_line[1];
    }
    return "unknown title";
}

open(my $fd, ">README.md");
print $fd "# note-text\n\n";
print $fd "Table of Contents\n=================\n";
my @dirs = `ls src`;
for my $dir (@dirs) {
    chomp $dir;
    my @files = glob "src/$dir/*.txt";
    printf $fd  "- %s\n", $dir;
    for my $file (@files){
        my $title = sprintf "\t- [%s](%s)\n",gen_title($file),$file;
        print $fd $title;
    }
}
close $fd;

# 提交代码
system("git add .");
system("git commit -m 'update'");
system("git push");
