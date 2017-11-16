String response[] = loadStrings("http://api.openweathermap.org/data/2.5/forecast?id=524901&mode=xml&APPID=075e3741a2137c9e61063f3d3581d512");
XML xmlData = parseXML(response[1]);
//printArray(xmlData);
XML[] children = xmlData.getChildren("location");
//printArray(children);
for (int i = 0; i < children.length; i++) {
  int id = children[i].getInt("id");
  String name = children[i].getContent();
  println(id + ", " + name);
}