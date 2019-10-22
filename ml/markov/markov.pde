boolean step(float prob) {
  float r = random(1.0);
  if (r > prob) return true;
  else return false;
}

void drawButtons(int n) {
  float bWidth = width / (n+1);
  fill(255);
  for (int i = 0; i < n; i++) {
    ellipse(i*bWidth + bWidth/2, height/2, bWidth, bWidth);
  }
  fill(0,255,0);
  ellipse(n*bWidth + bWidth/2, height/2, bWidth, bWidth);
}

void setup() {
  size(800, 200);
  
}

void draw() {
  background(0);
  drawButtons(4);

}