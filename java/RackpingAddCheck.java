// Program: RackpingAddCheck.java
// Usage: java RackpingAddCheck
// Purpose: Java language sample client program for RackPing Monitoring API 2.0
// Copyright: RackPing USA 2020
// Env: Java 1.8
// Returns: exit status is non-zero on failure
// Note: source ../set.sh and run build.sh

import java.util.List;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Base64;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
// import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
// import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;

// import javax.net.ssl.HttpsURLConnection;

public class RackpingAddCheck {

   private final String USER_AGENT = "Mozilla/5.0";

   public static void main(String[] args) throws Exception {

      int timeout = 0;

      try {
         timeout = Integer.parseInt(System.getenv("RP_TIMEOUT")) * 1000;
      }
      catch (NumberFormatException e) {
         System.out.println("error: do source ../set.sh first");
         System.exit(1);
      }

      final String url      = System.getenv("RP_SCHEME") + System.getenv("RP_DOMAIN") + System.getenv("RP_BASE_URL");

      final String username = System.getenv("RP_USER");
      final String password = System.getenv("RP_PASSWORD");
      final String api_key  = System.getenv("RP_API_KEY");

      RackpingAddCheck obj = new RackpingAddCheck();

      HttpURLConnection.setFollowRedirects(true);
      System.setProperty("http.maxRedirects", "3");

      // response Map with HTTP response headers, response code and content body
      Map<String, List<String>> r;

      Long id = 0L;

      try {
         System.err.println("2. Add one check");

         // Xlint gripes because json-simple relies on raw Map
         @SuppressWarnings("unchecked")
         Map<String, String> json = new JSONObject();

         json.put("name", "APITest");
         json.put("host", "https://www.rackping.com/?" + api_key);
         json.put("port", "443");
         json.put("resolution", "60");
         json.put("paused", "1");

         String data = new String(json.toString());
         r = obj.send(url + "/checks", username, password, api_key, timeout, data, "POST");
         if (r != null) {
            System.out.println(r.get("body").get(0));
         }
         else {
            System.exit(1);
         }
      }
      catch (IOException e) {
         System.out.println(e);
      }
   }

   // HTTP request
   private Map<String, List<String>> send(String url, String username, String password, String api_key, int timeout, String data, String method) throws Exception {

      URL obj = new URL(url);
      HttpURLConnection con = (HttpURLConnection) obj.openConnection();
      BufferedReader in = null;
      DataOutputStream wr = null;

      try {
         // Set request headers
         con.setRequestMethod(method);
         con.setRequestProperty("User-Agent", USER_AGENT);
         con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
         // con.setRequestProperty("Accept-Encoding", "gzip, deflate");
         con.setRequestProperty("Accept", "application/json");
         con.setRequestProperty("Content-Type", "application/json");
         con.setRequestProperty("App-key", api_key);
         con.setRequestProperty("Accept-Charset", "utf-8");

         con.setConnectTimeout(timeout);
         con.setReadTimeout(timeout);

         String encoded = Base64.getEncoder().encodeToString((username+":"+password).getBytes("utf-8"));
         con.setRequestProperty("Authorization", "Basic "+encoded);

         // Send request
         con.setDoOutput(true);

         if (method.equals("POST") || method.equals("PUT")) {
            wr = new DataOutputStream(con.getOutputStream());
            wr.writeBytes(data);
            wr.flush();
         }

         // Get response headers
         int responseCode = con.getResponseCode();

         if (responseCode==200) {
            String inputLine;
            StringBuffer response = new StringBuffer();

            in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            while ((inputLine = in.readLine()) != null) {
               response.append(inputLine).append("\n");
            }

            // getHeaderFields() returns an unmodifiable Map of the header fields so ...
            // Make a writable copy of headers to add body and response code
            Map<String, List<String>> h = new HashMap<String, List<String>>(con.getHeaderFields());

            h.put("body", Arrays.asList(response.toString()));
            h.put("response-code", Arrays.asList(String.valueOf(responseCode)));

            return h;
         }
         else {
            System.out.println("HTTP response code is " + responseCode);
         }
     } finally {
         if (con != null) con.disconnect();
         if (wr != null) wr.close();
         if (in != null) in.close();
     }

     return null;
   }
}
