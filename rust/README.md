# RackPing API 2.0 Client Sample Rust Programs

Rust sample programs that you can copy-and-paste to automate common RackPing monitoring tasks from the command line or cron.

Rust is a strictly-typed programming language, so these samples are more suitable for programmers who already have experience with Rust.

## Getting Started

* [Create a FREE RackPing monitoring account!](https://www.rackping.com/cgi-bin/signup.cgi) (Ctrl-click or Cmd-click link to signup in new tab)
* Download or copy-and-paste a program, then configure set.sh with your RackPing login and API key.
* For a linux cron job, download or copy-and-paste a RackPing Monitoring client program and manually set the RackPing account login information in the script according to the explanation in set.sh

```
# linux cron entry to run a script every 5 minutes
*/5 * * * * /path/to/script parameters >>/tmp/logfile.log 2>&1
```

### Prerequisites

Install the following dependencies:

```
rustc --version (1.49.0+ recommended)
OpenSSL and headers (needed for linux)
jq (optional for the demo.sh test harness)
```

On linux or Mac OS, you can upgrade rust using `rustup`:

https://www.rust-lang.org/tools/install

### Installing

For running cargo and setting the permissions on all files in this folder:

```
# review dependencies in Cargo.toml
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

## Keywords

RackPing REST API, SDK, Monitoring, Observability, Nocode, No-code, programming, scripting, automation.

