XML  xmlFile = loadXML("data.xml");
XML[] children = xmlFile.getChildren("apple");

for (int i = 0; i < children.length; i++) {
  int id = children[i].getInt("id");
  String colHex = children[i].getString("col");
  String name = children[i].getContent();
  println(id + ", " + colHex + ", " + name);
}