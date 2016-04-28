#!/usr/bin/perl
###############################################
# SMTPwn - SMTP service enumerator 
# Author: Alexis Vanden Eijnde
# Date: 28/04/2016
# Usage: SMTPenum.pl <server_ip> <port>
################################################

use strict;
use Socket;
use IO::Handle;
use IO::Select;
use IO::Socket::INET;
use Data::Dumper;
use Time::Progress; # libtime-progress-perl
$| = 1;

if ($#ARGV != 1) {
    die "Usage: $0 <server_ip> <port>\n";
}

my $email = 'guest@localhost';
my $query_timeout = 3;
my $host = $ARGV[0];
my $port = $ARGV[1];
my $pbar = new Time::Progress;
my @validUsers;
open(FILE, "<usernames") or die "ERROR: Can't open username file: $!\n";
my @usernames = map {chomp($_);$_}<FILE>;
$pbar->attr( min => 0, max => scalar @usernames);
my $p = 0;
eval {
	local $SIG{ALRM} = sub { die "alarm\n" };
	alarm $query_timeout;
	print "[+] SMTPenum Starting\n";
	foreach my $username (@usernames){
 		$p++;
  	  	print $pbar->report("%45b %p\r", $p);
		my $s = IO::Socket::INET->new(PeerAddr => $host,PeerPort => $port,Proto => 'tcp') or die "Can't connect to $host:$port: $!\n";
		my $buffer;
		my $enum = {};
		$s->recv($buffer, 1024); # recv banner
		$s->send("HELO $ARGV[0]\r\n");
		$s->recv($buffer, 1024);
		$s->send("VRFY $username\r\n");
		$s->recv($buffer, 1024);
		$enum->{'VRFY'}=$buffer;
		#
		$s->send("EXPN $username\r\n");
		$s->recv($buffer, 1024);
		$enum->{'EXPN'}=$buffer;
		#
		$s->send("MAIL FROM:$email\r\n");
		$s->recv($buffer, 1024);
		$s->send("RCPT TO:$username\@$ARGV[0]\r\n");
		$s->recv($buffer, 1024);
		$enum->{'RCPT'}=$buffer;
		alarm 0;
		foreach my $val (values %$enum) {
			if ($val =~ /250 \S+/s) {
				push @validUsers, $username;
				last;
			}
		}	
	}
};

print $pbar->report("\n[+] Done elapsed:%L\n", $p);
foreach (@validUsers){
	print "[+] Found:$_\n"
}
