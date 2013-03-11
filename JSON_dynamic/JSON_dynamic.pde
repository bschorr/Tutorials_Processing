/***************************
 Simple JSON to Processing - DYNAMIC
 by Bernardo Schorr - 2013
 
 Uses the Json4Processing Library: 
 https://github.com/agoransson/JSON-processing/tree/master/distribution
 
 Inspired by Jer Thorpe's tutorial for the NY Times API:
 http://blog.blprnt.com/blog/blprnt/processing-json-the-new-york-times
 
 A lot of the DataSets you find online will be provided in JSON format.
 This simple code walks you through parsing data from an online JSON provided at
 http://stats.grok.se
 
 This website dynamically generates JSON files with the page views for 
 the last 90 days (among other things), which means the visualizations generated 
 by the data in it will most likely be up-to-date.
 
 ****************************/
 
//Choose the term to be searched - we'll use this string later 
String term = "earth";

//import JSON library 
import org.json.*;

//set a width for your graph bars
int rectw = 10;

//make an array to store the data pulled from the JSON
//in this case, they are wikipedia page visits spanning 90 days
int [] visits = new int [0];

int maxValue;
int maxMap;

void setup() {

  size (900, 600);
  background (0);
  fill (255, 0, 0);

  //We'll make a separate function to parse through the JSON
  getJson();
  
  // The following sequences of if statements provides the capping value
  // for the graphic. This is used because some pages will have viewcounts
  // in the tens of thousands and others in the hundreds
  if (maxValue > 10) maxMap = 100;
  if (maxValue > 100) maxMap = 1000;
  if (maxValue > 1000) maxMap = 5000;
  if (maxValue > 5000) maxMap = 10000;
  if (maxValue > 10000) maxMap = 20000;
  if (maxValue > 20000) maxMap = 40000;
  if (maxValue > 40000) maxMap = 100000;
  
  //draw your bar graph using the data you pulled
  for (int i = 0; i < visits.length; i++) {

    float h = map (visits[i], 0, maxMap, 0, 600);

    rect (10*i, height-h, 10, h);
  }
  
  //Write the term you're searching for
  fill (255);
  textSize (36);
  text (term, 20, 40);
  
  //Write the capping values for your data
  textSize (24);
  textAlign (RIGHT);
  text ("0", width - 40, height - 20);
  text (maxMap, width-20, 40);
  
};

void draw() {
};

void getJson() {

  //Pull the string from the website, using the format provided
  //adding the searched term after the URL
  String request = "http://stats.grok.se/json/en/latest90/" + term;
  
  /* This is the tricky part:
   In a JSON file, everything inside curly brackets is a JSON Object
   Everything inside square brackets is a JSON Array
   Here we'll be pulling data from a JSON object WITHIN another.
   */
  
  //call the first JSON Object. In this case it wraps around the entire document
  JSONObject views = new JSONObject(join(loadStrings( request ), ""));
  
  //call the second JSON Object, within "views", that we just created
  //this one is called "daily_views" in the original document
  JSONObject results = views.getJSONObject("daily_views");
  
  //If we wanted to pull data from a JSON Array, the code would look like this
  //JSONArray results = wikiData.getJSONArray("results");
  
  // 3 For Loops, one for year, one for month, one for day, 
  // this way we can use the same code for longer datasets
  for (int year = 2012; year <= 2013; year++) {
    for (int m = 1; m <=12; m++) {
      for (int d = 1; d <= 31; d++) {
        
        // total visits in that day
        int total;
        
        //this is done to add the 0 that sometimes appears in the file, such as in july (07)
        String month, day;

        if (d < 10) { 
          day = "0"+ d;
        } 
        else { 
          day = "" + d;
        }

        if (m < 10) { 
          month = "0"+m;
        } 
        else { 
          month = "" + m;
        }
        
        //You now have everything you need
        //PULL that data out of the JSON File
        total = results.getInt(year +"-"+ month + "-" + day);
        
        
        // If you code looks for something that doesn't exist
        // such as February 30, it'll return -1. 
        // In that case, do not add this value to your array
        if (total != -1) {  
          visits = append(visits, total);
        }
        
        if (total > maxValue) maxValue = total;
        
      }
      
      // see your array in the console :)
      // Now go back up and play with the numbers
      println (visits);
    }
  }
};

