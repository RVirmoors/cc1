XML  xmlFile = loadXML("data.xml");
//println(xmlFile);
XML[] children = xmlFile.getChildren("apple");
//println(children);
XML[] leaves = children[0].getChildren("leaf");
println(leaves);

for (int i = 0; i < children.length; i++) {
  int id = children[i].getInt("id");
  String colHex = children[i].getString("col");
  String name = children[i].getContent();
  println(id + ", " + colHex + ", " + name);
}
