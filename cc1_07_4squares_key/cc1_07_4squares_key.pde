int counter = -1; // 0 1 2 3. first trigger makes 0
int countRot = -1; // 0 1 2 3.
color f, h, v;

void setup() {
  size(500, 500);
  noStroke();
}

void draw() {
  background(f); 
  // rotate from center
  translate(width/2, height/2);
  rotate(countRot * PI / 2.);
  // draw rectangles
  if (counter % 2 == 1) {  // 1 and 3 
    fill(v);
    //print(countRot);
    rect(0, -height/2, width/2, height);
  }
  if (counter >= 2) {      // 2 and 3
    fill(h);
    rect(-width/2, 0, width, height/2);
  }
}

color randCol() {
  // generates a random colour with 50% transparency
  color randomColor = color(int(random(255)), int(random(255)), int(random(255)), 127);
  return randomColor; 
}

void keyPressed() {
  // increment counter
  counter = (counter + 1) % 4;
  if (counter == 0) {
    // reset colours
    f = randCol();
    h = randCol();
    v = randCol();
    countRot = (countRot + 1) % 4;
  }
}
