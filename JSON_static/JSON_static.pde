/***************************
 Simple JSON to Processing - STATIC
 by Bernardo Schorr
 
 Uses the Json4Processing Library: 
 https://github.com/agoransson/JSON-processing/tree/master/distribution
 
 Inspired by Jer Thorpe's tutorial for the NY Times API:
 http://blog.blprnt.com/blog/blprnt/processing-json-the-new-york-times
 
 A lot of the DataSets you find online will be provided in JSON format.
 This simple code walks you through parsing data from a JSON local file 
 and building it into a bar graph.
 
 Have a look at the .json file in the data folder before you proceed.
 It contains data on Wikipedia visits to Hugo Chavez page between 2012-12-07 and 2013-03-06.
 
 ****************************/

//import JSON library 
import org.json.*;

//set a width for your graph bars
int rectw = 10;

//make an array to store the data pulled from the JSON
//in this case, they are wikipedia page visits spanning 90 days
int [] visits = new int [0];

void setup() {

  size (900, 600);
  background (0);
  fill (255, 0, 0);

  //We'll make a separate function to parse through the JSON
  getJson();

  //draw your bar graph using the data you pulled
  for (int i = 0; i < visits.length; i++) {

    float h = map (visits[i], 0, 2000, 0, 600);

    rect (10*i, height-h, 10, h);
  }
};

void draw() {
};

void getJson() {

  //pull all the characters from your JSON into a String variable
  String result = join( loadStrings( "hugo.json" ), "");

  /* This is the tricky part:
   In a JSON file, everything inside curly brackets is a JSON Object
   Everything inside square brackets is a JSON Array
   Here we'll be pulling data from a JSON object WITHIN another.
   */
  
  //call the first JSON Object. In this case it wraps around the entire document
  JSONObject hugo = new JSONObject(join(loadStrings("hugo.json"), ""));
  
  //call the second JSON Object, within "hugo", that we just created
  //this one is called "daily_views" in the original document
  JSONObject results = hugo.getJSONObject("daily_views");
  
  // If we wanted to pull data from a JSON Array, the code would look like this
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
      }
      
      // see your array in the console :)
      // Now go back up and play with the numbers
      println (visits);
    }
  }
};

