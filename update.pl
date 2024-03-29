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
# 获取文件日期
sub get_date($) {
    $_ = shift;
    print "$_\n";
    if(m/(\d\d\d\d)[-]?(\d\d)[-]?(\d\d)/) {
        return $1 . "-" . "$2" . "-" . $3;
    }
    return "";
}
open( my $fd, ">README.md" );
print $fd "<html><body>\n";
printf $fd "<pre>最近更新: %s</pre>\n", `date +"%Y-%m-%d %H:%M:%S"`;
my @dirs = `ls src`;
@dirs = reverse( sort @dirs );
for my $dir (@dirs) {
    chomp $dir;
    my @files = reverse( glob "src/$dir/*" );
    printf $fd "<h2 id=\"%s\">%s</h2>\n", $dir, $dir;
    printf $fd "<ul style=\"list-style: none;\">";
    for my $file (@files) {
        next if ( not -f $file );
        my $title = sprintf "<li> <a href=\"%s\"> %s</a> —— %s</li>\n",  $file, gen_title($file),get_date($file);
        print $fd $title;
    }
    printf $fd "</ul>\n";
    printf $fd "<hr />\n";
}
print $fd "</body></html>";
close $fd;

# 提交代码
system("git add .");
system("git commit -m 'update'");
system("git push");
