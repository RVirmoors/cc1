 color dataColor[] = new color[3]; // three apple colors
 //String dataName[] = new String[3]; // three apple names
 
 String[] stuff = loadStrings("data.csv");
 String[] values = split(stuff[0], ','); // delimiter: comma
 
 String[] dataName = split(stuff[1], ',');
 
 for (int i = 0; i < values.length; i++) {
   // add "FF" prefix for max alpha (ARGB)
   dataColor[i] = values[i]; 
   fill(dataColor[i]);
   ellipse(i*30+20,height/2,20,18);
   text(dataName[i], i*30,height/4);
 }
 printArray(dataName);
