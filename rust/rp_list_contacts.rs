// Program: rp_list_contacts.rs
// Usage: ./rp_list_contacts.rs
// Date: 2021 02 06
// Purpose: rust language sample client program for RackPing Monitoring API 2.0
// Version: 1.0
// Copyright: RackPing USA 2021
// Env: rust (customize source code for your version of rust)
// Returns: exit status is non-zero on failure
// Notes:
// - first do: source ../set.sh
// - this alpha (non-functional) sample code is a template for advanced rust programmers to customize for their version of rust:
//   - install rust and find out the version
//   - decide if you want async or blocking call to get
//   - update the main() definition with the correct signature if async
//   - update the call to get
//   - update the response println()
//   - See:
//     - https://github.com/seanmonstar/reqwest
//     - https://github.com/seanmonstar/reqwest/blob/master/examples/blocking.rs
//     - https://docs.rs/reqwest/0.9.20/reqwest/struct.Response.html

use reqwest;
use serde_json;
use std::env;
use std::process;
use std::error::Error;
// use std::time::Duration;
// use std::collections::HashMap;

fn main() -> Result<(), Box<dyn Error>> {
   let username   = env::var("RP_USER").unwrap();
   let password   = env::var("RP_PASSWORD").unwrap();
   let api_key    = env::var("RP_API_KEY").unwrap();
   let user_agent = env::var("RP_USERAGENT").unwrap();
  
   if username == "" {
      println!("error: do 'source ../set.sh' first.\n");
      process::exit(1);
   }

   let domain     = env::var("RP_DOMAIN").unwrap();
   let base_url   = env::var("RP_BASE_URL").unwrap();
   let scheme     = env::var("RP_SCHEME").unwrap();

   let _timeout   = env::var("RP_TIMEOUT").unwrap().parse::<u64>().unwrap();
   let _redirects = env::var("RP_REDIRECTS").unwrap().parse::<u32>().unwrap();
   let _debug     = env::var("RP_DEBUG").unwrap().parse::<u8>().unwrap();

   let url        = scheme.to_string() + &domain.to_string() + &base_url.to_string() + "/contacts";

   println!("Get list of contacts\n");

   let client = reqwest::blocking::Client::new();
   let resp = client.get(&url)
       .header("User-agent", user_agent)
       .header("app-key", api_key)
       .basic_auth(username, Some(String::from(password)))
//     .timeout(Duration::from_secs(_timeout))
//     .json::<HashMap<String, String>>();
       .json::<serde_json::Value>()?;

   println!("{:#?}", resp);
   Ok(());
}

