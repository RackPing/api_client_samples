# RackPing API 2.0 Client Sample Perl Programs

Perl sample programs that you can copy-and-paste to automate common RackPing monitoring tasks from the command line or cron.

## Getting Started

* Download or copy-and-paste a program, then configure set.sh with your RackPing login and API key.
* For a linux cron job, download or copy-and-paste a RackPing Monitoring client program and manually set the RackPing account login information in the script according to the explanation in set.sh

```
# linux cron entry to run a script every 5 minutes
*/5 * * * * /path/to/script parameters >>/tmp/logfile.log 2>&1
```

### Prerequisites

Tested with Perl 5.10.1, but earlier versions may also work.

Install the following dependencies:

```
perl --version
sudo cpan LWP
sudo cpan HTTP::Request
jq (optional for the demo.sh test harness)
```

```
# on Mac OS X, SSL certificates are needed:
sudo cpan Mozilla::CA
```

Note: Perl CPAN module HTTP::Request::Common 6.07+ is required for some PUT and POST requests (the version can be checked with perldoc -m HTTP::Request::Common)

### Installing

For setting the permissions on all files in this folder:

```
./make.sh
```

For a single program file:

```
chmod 755 filename
```

## Documentation

See the [RackPing API web page](https://www.rackping.com/api.html) for:

* RackPing 2.0 API PDF
* errata (recent changes)
* interactive Live API demo in your browser.

## Running the tests

After installing all the files in this folder, you can use demo.sh as a test harness to create a temporary check and contact using your RackPing account:

```
source ../set.sh
time ./demo.sh
```

## Version

1.0

## License

Copyright RackPing USA 2013-2021

