float[] data = new float[10];
boolean spawn = false;
boolean reset = true;
void setup() {
  size(800, 600); 
  frameRate(15);
  String[] stuff = loadStrings("data.csv");
  data = float(split(stuff[0], ','));
  float maximum = max(data);
  for(int i = 0; i < 10; i++) 
    data[i] = map(data[i], 0, maximum, 0, 255);
}
void draw() {
  if (reset) {
    drawBg();
    reset = false;
  }
  if (spawn) {
    int decile = (int)random(10);
    fill(data[decile]);
    ellipse(random(600), random(600),
      5, 5);
  }
}
void drawBg() {
  background(0);
  noStroke();
  for(int i = 0; i < 10; i++) {
    fill(data[i]);
    rect(600, height - i*60, 200, -60);
  }
}
void mousePressed() {
  if (mouseButton == LEFT)
    spawn = !spawn;
  else
    reset = true;
}