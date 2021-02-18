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

For running `cargo` and setting the permissions on all files in this folder:

```
# review dependencies in Cargo.toml
./make.sh
./build.sh
```

`build.sh` copies the rust binaries to dist/bin/:
```
$ ls -1

rp_add_check
rp_add_contact
rp_del_check
rp_del_contact
rp_list_checks
rp_list_contacts
rp_pause_check
rp_pause_maint
rp_resume_check
rp_resume_maint
rp_schedule_maint
rp_update_check
rp_update_contact
```

# Directory Structure

Rust's `cargo` build program is used in the standard way, but each RackPing sample program has its own Rust project directory.

```
$ tree

├── build.sh
├── clean.sh
├── make.sh
├── README.md
├── dist
│   └── bin
├── doc
│   └── README.md
├── rp_add_check
│   ├── Cargo.toml
│   └── src
│       ├── bin
│       └── rp_add_check.rs
├── rp_add_contact
│   ├── Cargo.toml
│   └── src
│       ├── bin
│       └── rp_add_contact.rs
[...]
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

