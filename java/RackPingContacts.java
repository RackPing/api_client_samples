// Program: RackPingContacts.java
// Usage: java RackPingContacts
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
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;

// import javax.net.ssl.HttpsURLConnection;

public class RackPingContacts {

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

      RackPingContacts obj = new RackPingContacts();

      HttpURLConnection.setFollowRedirects(true);
      System.setProperty("http.maxRedirects", "3");

      // response Map with HTTP response headers, response code and content body
      Map<String, List<String>> r;

      try {
         System.out.println("1. Get list of contacts");
         r = obj.send(url + "/contacts", username, password, api_key, timeout, "", "GET");
         System.out.println(r.get("body").get(0));
      }
      catch (IOException e) {
         System.out.println(e);
      }

      String location = "";
      int rc = 0;
      Long id = 0L;

      try {
         System.out.println("2. Add one contact");

         // Xlint gripes because json-simple relies on raw Map
         @SuppressWarnings("unchecked")
         Map<String, String> json = new JSONObject();

         json.put("first", "John");
         json.put("last", "Doe");
         json.put("email", "john.doe@gmail.com");
         json.put("role", "O");
         json.put("cellphone", "408 555 1212");
         json.put("countrycode", "1");
         json.put("countryiso", "US");

         String data = new String(json.toString());
         r = obj.send(url + "/contacts", username, password, api_key, timeout, data, "POST");
         System.out.println(r.get("body").get(0));

         try {
            Object myObj = new JSONParser().parse(r.get("body").get(0));
            final JSONObject jsonObject = (JSONObject) myObj;
            final JSONObject user = (JSONObject) jsonObject.get("contact");

            // 411 - this is a fragile parsing method, and won't work upon call or duplicate errors, hence the try/catch block
            id = (Long) user.get("id");
         }
         catch (Exception e_id) {
            System.out.println("error: unable to parse response for a new numeric contact id. Please login manually, remove the old test contact, and try again, " + e_id +"\n");
            System.exit(1);
         }

         System.out.println("id=" + id);

         // location = r.get("Location").get(0);
         rc = Integer.valueOf(r.get("response-code").get(0));
      }
      catch (IOException e) {
         System.out.println(e);
      }
   
      if (rc == 200 || rc == 201) {
         try {
            System.out.println("3. Update one contact");
   
            // Xlint gripes because json-simple relies on raw Map
            @SuppressWarnings("unchecked")
            Map<String, String> json = new JSONObject();

            json.put("contactid", Long.toString(id));
            json.put("first", "JohnJohn");
            json.put("last", "Doe");
            json.put("email", "john.doe@gmail.com");
            json.put("role", "O");
            json.put("cellphone", "408 555 1212");
            json.put("countrycode", "1");
            json.put("countryiso", "US");

            String data = new String(json.toString());
            r = obj.send(url + "/contacts/" + id, username, password, api_key, timeout, data, "PUT");
            System.out.println(r.get("body").get(0));
   
            // location = r.get("Location").get(0);
            rc = Integer.valueOf(r.get("response-code").get(0));
         }
         catch (IOException e) {
            System.out.println(e);
         }

         try {
            System.out.println("4. Delete one contact");
            r = obj.send(url + "/contacts/" + id, username, password, api_key, timeout, "", "DELETE");
            System.out.println(r.get("body").get(0));
         }
         catch (IOException e) {
            System.out.println(e);
         }
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
         con.setRequestProperty("Content-Type", "application/json");
         con.setRequestProperty("App-key", api_key);

         con.setConnectTimeout(timeout);
         con.setReadTimeout(timeout);

         String encoded = Base64.getEncoder().encodeToString((username+":"+password).getBytes("UTF-8"));
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
     } finally {
         if (con != null) con.disconnect();
         if (wr != null) wr.close();
         if (in != null) in.close();
     }
   }
}

