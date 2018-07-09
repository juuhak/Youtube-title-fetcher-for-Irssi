use HTML::Entities;
use strict;
use Irssi;
use LWP::UserAgent;
use JSON;
use Data::Dumper;

#APIKEY HERE
use constant API_KEY => "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
#CHANNELS HERE => ['#channel', '#channel2']
use constant CHANNELS => ['#examplechannel'];

sub youtube_query {
    my $url = shift;
    my $server = shift;
    my $target = shift;
    
    my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });
    $ua->agent("irssi/0.1");
    
    my $res = $ua->get($url);
    print "HTTP status: ", $res->code();
    my $content_json = decode_json($res->content);

    my $output = "";

    #If no video found
    if ($content_json->{pageInfo}->{totalResults} == 0) {
        $output = "Video not found.";
    } else { #Video found, set the title as output
        $output = $content_json->{items}[0]->{snippet}->{title};
    }

	if ($res->is_success()){
        $server->command("msg $target // $output");
	} else {
	    my $status_line = $target->status_line();
	    $server->command("msg $target $status_line");
	}
}

sub message_public {
    my ($server,$msg,$nick,$address,$target) = @_;
    if ($target ~~ CHANNELS) {
        my $id = -1;
        if ($msg =~ /(www\.|m\.)youtube\.com\/watch\?.*v=(.{11})/) {
	        if ($msg =~ /(www\.|m\.)(youtube\.com\/watch\?.*v=.{11})\S*( \*)/) {
	            print "Not getting link";
	            return;
	        }
	        $id = $2;
        }
    
        if ($msg =~ /https?\:\/\/(www.)?\youtu\.be\/(.{11})/) {
	        if ($msg =~ /https?\:\/\/(www.)?\youtu\.be\/(.{11})\S*( \*)/) {
	            print "Not getting link";
	            return;
	        }
	        $id = $2;
        }

        if ($id != -1) {
	        my $query = join('',"https://www.googleapis.com/youtube/v3/videos?key=",API_KEY,"&part=snippet&id=",$id);
	        print $query;
	        youtube_query($query,$server,$target);
	        return;
        }
    }
}

Irssi::signal_add('d signal','message_public');
Irssi::signal_add('message public','message_public');