# RackPing API 2.0 Client Sample Programs

Sample programs in several programming languages that you can copy-and-paste to automate common RackPing Monitoring tasks from the command line, custom scripts or cron.

These are end-user sample client programs that call the RackPing Monitoring API 2.0.

The philosophy is that they should be easy-to-use, standalone (minimal or no dependencies), cut-and-paste code that illustrate common monitoring automation tasks (ie. "No code".)

See the README in each folder above for language-specific installation notes.

Click on the Docker folder above if you prefer a pre-configured container, instead of installing packages on your machine.

## Getting Started

* [Create a FREE RackPing monitoring account!](https://www.rackping.com/cgi-bin/signup.cgi) (Ctrl-click or Cmd-click link to signup in new tab)
* Click on an above folder for your preferred programming language to view the source code.
* Click on the green Github "Code" button, then "Download zip" to download the complete source code for all languages.
* unzip and cd to your preferred language folder and follow the language-specific instructions or
* click on the Docker folder and follow the instructions to build a Docker container.

## Documentation

See the [RackPing API web page](https://www.rackping.com/api.html) for:

* RackPing 2.0 API PDF
* errata (recent changes)
* interactive Live API demo in your browser.

## Running the tests

A paid RackPing account is required to run the demo_all.sh and demo.sh scripts, since they add and delete a check and a contact. However, Free accounts can run the other scripts in each each language folder to query, update or pause existing checks and contacts.

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
real	1m4.940s
user	0m41.091s
sys	0m5.485s
```

## Notes

The demo_all.sh script progress can be monitored by ear using the following tones emitted from */demo.sh:

* 2 beeps for each failed add contact call
* 3 beeps for each failed add check call
* 1 beep at successful end of run.

(The php and php_with_pecl_http sample demos are mutually exclusive based on whether the pecl http extension is installed or not, so one of those sample demos will always generate 2 beeps when add contact is attempted.)

* See the add contact scripts for how to assign a password and send a password reminder email. Or an account administrator can login to the UI and click on "My Users" ... choose user ... "Reset Password."

* gzip response output is supported by the RackPing REST API using the standard request header `Accept-Encoding: gzip`.

* The API cannot be used to delete the last account user, or any administrative-role users (use the UI to downgrade their role first.) The last monitor also cannot be deleted. These limitations are to reduce support calls over common oops.

* The API does per-request authentication, but caches credentials for 1 minute for performance reasons.

* The provided API test harnesses cannot be parallelized within or across languages because the tests depend on a temporary contact or monitor being created first before subsequent test requests are run. The process ID (PID) is appended to uniqify your test requests run across all accounts and users during the run. (Also, plan limits would prevent most accounts from adding enough users or monitors for all supported language samples simultaneously.)

## RackPing Account Limitations

* Free accounts only allow one contact (user) and one check (monitor.) So the sample API scripts for add and delete check and contact will not succeed, likewise the demo.sh and demo_all.sh test harnesses. Please upgrade to a paid RackPing account if you want more than one user or monitor, or want to do advanced REST API development.

* Paid accounts allow adding checks and contacts up to your plan user, monitor and subaccount limits.

* Do not do load testing against the API servers. If you are doing sequential API requests, please call sleep(1) between them. Contact support if you need performance information or suggestions.

## Versioning

Version 1.0

## License

Copyright RackPing USA 2013-2021

## Keywords

RackPing REST API, SDK, Monitoring, Observability, Nocode, No-code, programming, scripting, automation.
