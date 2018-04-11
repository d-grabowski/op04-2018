#!/usr/bin/perl

#Przykładowy skrypt wyszukujący nieudane logowanie użytkowników, również w przypadku nieistniejących.

use strict;
use warnings;
use Data::Dumper;
use Switch;
use JSON;

my $logFilePath = "/var/log/auth.log";
my @logTries;
my %usersCount;
my $line;

open my $logFile, "<$logFilePath" or die "Cannot open file $logFilePath: $!\n";

sub makeDate {
	my ($month, $day) = @_;
	my $numericMoneth;
	switch ($month) {
		case 'Jan' {$numericMoneth = 1;}
		case 'Feb' {$numericMoneth = 2;}
		case 'Mar' {$numericMoneth = 3;}
		case 'Apr' {$numericMoneth = 4;}
		case 'May' {$numericMoneth = 5;}
		case 'Jun' {$numericMoneth = 6;}
		case 'Jul' {$numericMoneth = 7;}
		case 'Aug' {$numericMoneth = 8;}
		case 'Sep' {$numericMoneth = 9;}
		case 'Oct' {$numericMoneth = 10;}
		case 'Nov' {$numericMoneth = 11;}
		case 'Dec' {$numericMoneth = 12;}
	}
	return "$day.$numericMoneth";
}

while ($line = readline $logFile) {
	if ($line =~ /(\w+)  (\d{1,31}) (\d+:\d+:\d+) (\w+) sshd\[\d+\]: Failed password for (?:invalid user\s)?(\w+) from (\d+\.\d+\.\d+\.\d+) port (\d+) ssh2/) {
		push @logTries, {
			date => makeDate($1, $2),
			'time' => "$3",
			user => $5,
			host => $6,
			port => $7
		};
	}
}

for my $entry (@logTries) {
	$usersCount{$$entry{user}}++;
}

print to_json([@logTries]) . "\n";

