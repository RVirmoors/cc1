int n, next;
float bWidth;
float prob[][];
boolean playing;

boolean step(float prob) {
  float r = random(1.0);
  if (r > prob) return true;
  else return false;
}

void drawButtons() {
  fill(255);
  for (int i = 0; i < n; i++) {
    ellipse(i*bWidth + bWidth/2, height/2, bWidth, bWidth);
  }
  fill(0,255,0);
  ellipse(n*bWidth + bWidth/2, height/2, bWidth, bWidth);
}

int getButton() {
  int stateClicked = (int)(((float)mouseX / (width-bWidth)) * n);
  return stateClicked;
}

void rec(int s) {
  
}

void play(int previous) {
  next = previous+1;  // CHANGE THIS!!! HOW DO WE GET "next" ?
  // ...
  // ...
  
}

void setup() {
  size(800, 200);
  frameRate(10);
  n = 4; // number of states
  float[][] probs = new float[n][n];
  bWidth = width / (n+1);
}

void draw() {
  background(0);
  drawButtons();
  if (playing) {
     fill(255,0,100);
     ellipse(next*bWidth + bWidth/2, height/2, bWidth, bWidth);
     play(next);  // "next" becomes "previous" for the following loop
  }  
}

void mousePressed() {
 if(mouseX > n*bWidth) {
   fill(255,100,0);
   ellipse(n*bWidth + bWidth/2, height/2, bWidth, bWidth);
   playing = true;
   int startfrom = (int)random(n);
   play(startfrom);
 } else {
   int b = getButton();
   fill(255,0,100);
   ellipse(b*bWidth + bWidth/2, height/2, bWidth, bWidth);
   playing = false;
   rec(b);
 }
}