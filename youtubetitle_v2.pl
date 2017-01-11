use HTML::Entities;
use strict;
use Irssi;
use LWP::UserAgent;


sub youtube_query {

    my $url = shift;
    my $server = shift;
    my $target = shift;
    
    my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });
    $ua->agent("irssi/0.1");
    
    my $res = $ua->get($url);
    my $content = $res->content;

    print "HTTP status: ", $res->code();
    
    $content =~ /\"title\": \"(.*)\"/;
    
    my $title = $1;
    
    my $title_decoded = decode_entities($title);
    
    if ($target =~ m/#(?:sigh|asd098asd)/) {
	
	if ($res->is_success()){
	    	
	    if ($title_decoded =~ /^YouTube$/){
		$server->command("msg $target Invalid Youtube ID.");
	    }
	    else {
		$server->command("msg $target // $title_decoded");
	    }
	}
	else {
	    my $status_line = $target->status_line();
	    $server->command("msg $target $status_line");
	}
	    
    }
}



sub message_public {

    # Insert Youtube API key here
    use constant API_KEY => "API KEY HERE";
    
    my ($server,$msg,$nick,$address,$target) = @_;
    my $id = -1;
    
    if ($msg =~ /(www\.|m\.)youtube\.com\/watch\?.*v=(.{11})/) {
	if ($msg =~ /(www\.|m\.)(youtube\.com\/watch\?.*v=.{11})\S*( \*)/) {
	    # print "Not getting link";
	    return;
	}
	$id = $2;
    }
    
    if ($msg =~ /https?\:\/\/(www.)?\youtu\.be\/(.{11})/) {
	if ($msg =~ /https?\:\/\/(www.)?\youtu\.be\/(.{11})\S*( \*)/) {
	    # print "Not getting link";
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

Irssi::signal_add('message public','message_public');