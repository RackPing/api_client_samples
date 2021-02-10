// Program: rp_update_contact.rs
// Usage: cargo run
// Date: 2021 02 06
// Purpose: rust language sample client program for RackPing Monitoring API 2.0
// Version: 1.0
// Copyright: RackPing USA 2021
// Env: rust (customize source code for your version of rust)
// Returns: exit status is non-zero on failure
// Notes:
// - first do: source ../set.sh
// - read doc/README.txt for programming info

use reqwest;
use std::env;
use std::process;
use std::io::Read;
// use serde_json;
// use std::error::Error;
// use std::result::Result;
// use std::time::Duration;
// use std::collections::HashMap;

fn main() {
    let args: Vec<String> = env::args().collect();
    let id = &args[1];

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

    let _timeout   = env::var("RP_TIMEOUT").unwrap().parse::<u64>().unwrap();
    let _redirects = env::var("RP_REDIRECTS").unwrap().parse::<u32>().unwrap();
    let debug      = env::var("RP_DEBUG").unwrap().parse::<u8>().unwrap();

    let url        = scheme.to_string() + &domain.to_string() + &base_url.to_string() + "/contacts/" + id;

    println!("info: update one contact\n");

    let client  = reqwest::blocking::Client::new();

//   let client = reqwest::blocking::Client::builder()
//    .timeout(Duration::from_secs(10))
//    .build()?;

    let email = format!("john.doe+{}@example.com", api_key);

    let params = [
       ("first",       "JohnJohn"),
       ("last",        "Doe"),
       ("email",      &email),
       ("role",        "O"),
       ("cellphone",   "408 555 1212"),
       ("countrycode", "1"),
       ("countryiso",  "US")
    ];

    let mut resp = client.put(&url)
        .form(&params)
        .header("User-agent", user_agent)
        .header("app-key", api_key)
        .header("Accept","application/json")
        .header("Accept-Charset","utf-8")
        .header("Content-type","application/json")
        .basic_auth(username, Some(String::from(password)))
//      .json::<HashMap<String, String>>();
//      .json::<serde_json::Value>();
//      .timeout(Duration::from_secs(_timeout))
        .send()
        .unwrap();

    let mut body = String::new();
    resp.read_to_string(&mut body).unwrap();

    if debug == 1 {
       println!("Status: {}", resp.status());
       println!("Headers:\n{:#?}", resp.headers());
    }

    println!("{}", body);
}

