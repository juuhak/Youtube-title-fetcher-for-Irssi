# Youtube title fetcher for Irssi
Perl script for Irssi to fetch titles of videos from Youtube links.

Uses Youtube API to fetch the topic of a video from a link posted in a channel and posts the topic to the channel.

Insert Youtube API key and active channel(s) into the script at commented spots.

Put the script to `~/.irssi/scripts/` and in Irssi do `/script load youtubetitle_v2.pl`

Ignores links that have ` *` after the link. Ie. `https://www.youtube.com/watch?v=<id> *`
