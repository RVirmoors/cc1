String response[] = loadStrings("http://api.openweathermap.org/data/2.5/forecast?id=524901&mode=xml&APPID=075e3741a2137c9e61063f3d3581d512");
XML xmlData = parseXML(response[1]);
//printArray(xmlData);
XML[] children = xmlData.getChildren("sun");
//printArray(children);
for (int i = 0; i < children.length; i++) {
  String rise = children[i].getString("rise");
  String set = children[i].getString("set");
  println(rise + ", " + set);
}