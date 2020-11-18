# RackPing API 2.0 Client Sample Programs

Sample programs in several programming languages that you can copy-and-paste to automate common RackPing Monitoring tasks from the command line, custom scripts or cron.

These are end-user sample client programs that call the RackPing Monitoring API 2.0.

The philosophy is that they should be easy-to-use, standalone (minimal or no dependencies), cut-and-paste code that illustrate common monitoring automation tasks (ie. "No code".)

See the README in each folder above for language-specific installation notes.

## Getting Started

* [Create a FREE RackPing monitoring account!](https://www.rackping.com/cgi-bin/signup.cgi) (Ctrl-click or Cmd-click link to signup in new tab)
* Click on an above folder for your preferred programming language to view the source code.
* Click on the green Github "Code" button, then "Download zip" to download the complete source code for all languages.
* unzip and cd to your preferred language folder and follow the language-specific instructions

## Documentation

See the [RackPing API web page](https://www.rackping.com/api.html) for:

* RackPing 2.0 API PDF
* errata (recent changes)
* interactive Live API demo in your browser.

## Running the tests

A paid RackPing account is required to run the demo_all.sh and demo.sh scripts, since they add and delete a check and a contact. However, Free accounts can run the other scripts in each each language folder to update or pause existing checks and contacts.

After installing all the files in this repo, you can optionally use demo_all.sh as a test harness to create a temporary check (monitor) and contact (user) using your RackPing account with all supported programming languages:

```
# on Mac OS X
brew install jq
ln -s /usr/local/bin/jq /usr/bin/jq
```

```
source ../set.sh
time ./demo_all.sh
```

Sample output on linux and Mac OS X:
```
real	1m47.736s
user	0m40.550s
sys	0m6.428s
```

## Notes

The demo_all.sh script progress can be monitored aurally using the following tones emitted from */demo.sh:

* 2 beeps for each failed add contact call
* 3 beeps for each failed add check call
* 1 beep at end of run

(The php and php_with_pecl_http sample demos are mutually exclusive based on whether the pecl http extension is installed or not, so one of those sample demos will always generate 2 beeps when add contact is attempted.)

* The add contact scripts don't assign a password or send a reminder email. You will have to login to the UI and click on "My Users" ... choose user ... "Reset Password."

## RackPing Account Limitations

* Free accounts only allow one contact (user) and one check (monitor.) So the sample API scripts for add and delete check and contact will not succeed, likewise the demo.sh and demo_all.sh test harnesses. Please upgrade to a paid RackPing account.

* Paid accounts allow adding checks and contacts up to your plan limits.

## Versioning

Version 1.0

## License

Copyright RackPing USA 2013-2021

## Keywords

RackPing REST API, SDK, Monitoring, Observability, Nocode, No-code, programming, scripting, automation.
