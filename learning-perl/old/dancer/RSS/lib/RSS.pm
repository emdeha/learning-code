package RSS;
use Dancer ':syntax';

use LWP::UserAgent;
use XML::RSS::LibXML;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/rss' => sub {
    my $ua = LWP::UserAgent->new;
    $ua->agent("RSS/0.1");

    my $req =
        HTTP::Request->new(GET => param 'url');

    my $res = $ua->request($req);
    if ($res->is_success) {
        my $rss = XML::RSS::LibXML->new;

        $rss->parse($res->content);
        my $ret;
        foreach my $item (@{$rss->{items}}) {
            $ret .= "<a href=\"$item->{link}\">$item->{title}</a><br/>";
        }
        return $ret;
    } else {
        print "Error:\n";
        print $res->status_line, "\n";
    }
};

true;
