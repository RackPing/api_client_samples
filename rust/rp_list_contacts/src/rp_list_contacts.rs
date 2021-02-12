// Program: rp_list_contacts.rs
// Usage: cargo run
// Date: 2021 02 06
// Purpose: rust language sample client program for RackPing Monitoring API 2.0
// Version: 1.0
// Copyright: RackPing USA 2021
// Env: rust 1.49.0 (customize source code for your version of rust)
// Returns: exit status is non-zero on failure
// Notes:
// - first do: source ../set.sh
// - read doc/README.md for programming info

use std::env;
use std::process;
use std::time::Duration;
use reqwest::blocking::Client;

fn main() {
    let username   = env::var("RP_USER").unwrap_or("".to_string());
    if username == "" {
       println!("error: do 'source ../set.sh' first.\n");
       process::exit(1);
    }

    let password   = env::var("RP_PASSWORD").unwrap();
    let api_key    = env::var("RP_API_KEY").unwrap();
    let user_agent = env::var("RP_USERAGENT").unwrap();
  
    let domain     = env::var("RP_DOMAIN").unwrap();
    let base_url   = env::var("RP_BASE_URL").unwrap();
    let scheme     = env::var("RP_SCHEME").unwrap();

    let timeout    = env::var("RP_TIMEOUT").unwrap().parse::<u64>().unwrap();
    let debug      = env::var("RP_DEBUG").unwrap().parse::<u8>().unwrap();

    let url        = scheme.to_string() + &domain.to_string() + &base_url.to_string() + "/contacts";

    eprintln!("info: get list of contacts\n");

let custom = reqwest::redirect::Policy::custom(|attempt| {
    let redirects  = env::var("RP_REDIRECTS").unwrap().parse::<usize>().unwrap();

    if attempt.previous().len() > redirects {
        attempt.error("too many redirects")
    } else if attempt.url().host_str() == Some("example.domain") {
        // prevent redirects to 'example.domain'
        attempt.stop()
    } else {
        attempt.follow()
    }
});

    let client = Client::builder()
       .timeout(Duration::from_secs(timeout))
       .redirect(custom)
       .build()
       .unwrap();

    let resp = client.get(&url)
       .header("Accept","application/json")
       .header("Accept-Charset","utf-8")
       .header("User-agent", user_agent)
       .header("app-key", api_key)
       .basic_auth(username, Some(String::from(password)))
       .send();

    let resp = match resp {
        Ok(resp) => resp,
        Err(err) => {
            println!("error: during networking: {}", err);
            process::exit(1);
        }
    };

    if debug == 1 {
       eprintln!("status={}", resp.status());
       eprintln!("headers={:#?}", resp.headers());
    }

    let resp_body = resp.text();
    let _resp_body = match resp_body {
        Ok(resp) => {
          println!("{}", resp);
        },
        Err(err) => {
            println!("error: while receiving respponse body: {}", err);
            process::exit(1);
        }
    };
}

