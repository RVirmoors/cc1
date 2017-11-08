float[] data = new float[10];
boolean spawn = false;
boolean reset = true;
void setup() {
  size(800, 600); 
  frameRate(15);
  String[] stuff = loadStrings("data.csv");
  data = float(split(stuff[0], ','));
  for(int i = 0; i < 10; i++) 
    data[i] *= 25.;
}
void draw() {
  if (reset) {
    drawBg();
    reset = false;
  }
  if (spawn) {
    int decile = (int)random(10);
    ellipse(random(500)+50, random(500)+50,
      data[decile], data[decile]);
  }
}
void drawBg() {
  background(0);
  fill(50);
  rect(600, 0, 200, height);
  fill(255,50);
  noStroke();
  for(int i = 0; i < 10; i++) {
    ellipse(700, (9-i)* (height / (9.5-i/5.)), data[i], data[i]);
  }
}
void mousePressed() {
  if (mouseButton == LEFT)
    spawn = !spawn;
  else
    reset = true;
}