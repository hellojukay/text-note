use strict;
use warnings;
use utf8;

sub gen_title($){
    my $file = $_[0];
    open my $fh, '<',$file or warn "can not open file $file";
    my $firstLine = <$fh>; 
    close $file;
    if ($firstLine =~ m/title:/) {
       my @title_line = split /:/ ,$firstLine;
       return $title_line[1];
    }
    return "unknown title";
}

my @files = glob "src/**/*.txt";
for my $file (@files){
    my $title = sprintf "![%s](%s)\n",gen_title($file),$file;
    print $title;
}
