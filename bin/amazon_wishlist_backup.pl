#!/usr/bin/perl -w

use Net::Amazon;
use Net::Amazon::Request::Wishlist;

my $ua = Net::Amazon->new(
    token      => 'AKIAIVPF5IR3VACLQ3UQ',
    secret_key => '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',

    max_pages => 100
);

my $req = Net::Amazon::Request::Wishlist->new(
    id  => '1NDL4V6G5ZXMH'
);

# Response is of type Net::Amazon::ASIN::Response
my $resp = $ua->request($req);

if($resp->is_success()) {
    print $resp->as_string, "\n";
} else {
    print $resp->message(), "\n";
}
