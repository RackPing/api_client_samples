# RackPing API 2.0 Client Sample wget Programs

wget sample programs that you can copy-and-paste to automate common RackPing monitoring tasks from the command line or cron.

Note: curl is generally recommended instead of wget for programming. These wget sample programs are provided in case you cannot install curl. If you must use wget, install GNU wget version 1.15+ and use the --method option for DELETE, POST and PUT methods for best results.

## Getting Started

* Download or copy-and-paste a program, then configure set.sh with your RackPing login and API key.
* For a linux cron job, download or copy-and-paste a RackPing Monitoring client program and manually set the RackPing account login information in the script according to the explanation in set.sh

```
# linux cron entry to run a script every 5 minutes
*/5 * * * * /path/to/script parameters >>/tmp/logfile.log 2>&1
```

### Prerequisites

Tested with wget 1.12, but earlier versions may also work. GNU wget 1.15+ is recommended since it supports the --method option.

Install the following dependencies:

```
wget --version
jq (optional for the demo.sh test harness)
```

https://www.gnu.org/software/wget/

### Installing

For setting the permissions on all files in this folder:

```
./make.sh
```

For a single program file:

```
chmod 755 filename
```

## Running the tests

After installing all the files in this folder, you can use demo.sh as a test harness to create a temporary check and contact using your account:

```
source ../set.sh
time ./demo.sh
```

## Version

1.0

## License

Copyright RackPing USA 2013-2021

