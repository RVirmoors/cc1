 color dataColor[] = new color[3]; // three apple colors
 String dataName[] = new String[3]; // three apple names
 
 String[] stuff = loadStrings("data.csv");
 String values[] = (split(stuff[0], ',')); // delimiter: comma
 for (int i = 0; i < 3; i++) {
   // add "FF" prefix for max alpha (ARGB)
   dataColor[i] = unhex("FF"+values[i]); 
   fill(dataColor[i]);
   rect(i*10,0,i*10+10,height-1);
 }
 dataName = (split(stuff[1], ','));
 printArray(dataName);