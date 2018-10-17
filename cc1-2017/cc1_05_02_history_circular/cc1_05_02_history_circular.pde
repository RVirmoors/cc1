int num = 50;
int writeAt = 0;
int[] x = new int[num];
int[] y = new int[num];

void setup() { 
  size(100, 100);
  noStroke();
  fill(255, 102);
}

void draw() {
  background(0);
  // Add the new values to the writeAt position
  x[writeAt] = mouseX;
  y[writeAt] = mouseY;
  int nextAt = (writeAt + 1) % num; // circular increment
  // Draw the circles
  for (int i = nextAt; i != writeAt; 
      i = (i + 1) % num) {
    float size = ((i+num - nextAt) % num )/ 2.; // i-nextAt
    ellipse(x[i], y[i], size, size);
  }
  writeAt = nextAt; // increment writeAt
}