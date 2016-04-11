#!/usr/bin/perl -w
use LWP::Simple;
use JSON qw(decode_json);
use Data::Dumper;
use strict;
use Irssi;
use Irssi::Irc;
use Scalar::Util qw(looks_like_number);

use vars qw($VERSION %IRSSI);

$VERSION = "1.00"; %IRSSI = {
  authors => 'Petri Huovinen',
  name => 'Saunan lämpötilan haku',
  description => 'Hakee tupsulan saunan lämpötilan internetistä ja näyttää sen irki$
  license => 'Public Domain'
};

sub bot_action($$$$) {
    my($server,$text,$nick,$address,$channel)=@_;

    if ( $text =~/^!sauna/) {
        sauna($channel);
    }
}
sub sauna {
  my $temperature_url = "http://tupsula.fi/sauna/temperature.json";
  my $temperature_json = get($temperature_url);

  my $decoded_temp = decode_json($temperature_json);

  my($channel) = @_;
  my $witem = Irssi::window_item_find($channel);
  my $temp = $decoded_temp->{'currentTemperature'};
  $temp =~ s/,/\./g;

  if ( looks_like_number($temp) ) {
    if ( $temp > 65 ) {
      $witem->{server}->command('MSG '.$channel.' Saunan lämpötila: '.$decoded_temp$
    } else {
      $witem->{server}->command('MSG '.$channel.' Saunan lämpötila: '.$decoded_temp$
    }
  } else {
    $witem->{server}->command('MSG '.$channel.' Saunan lämpötila: '.$decoded_temp->$
  }
}

Irssi::signal_add_last("message public", "bot_action");
