JSONArray values = loadJSONArray("data.json");

for (int i = 0; i < values.size(); i++) {
  JSONObject apple = values.getJSONObject(i);
  String colHex = apple.getString("color");
  String name = apple.getString("name");
}
