float shipX, shipY, shipAngle, shipSpeed;
int scaleCycle;

void setup() {
 size(400, 400); 
 stroke(100);
 strokeWeight(2);
 smooth(2);
 fill(230);
 shipX = width/2; shipY = height/2;
}

void draw() {
  background(20);
  drawBg();
  moveShip();
  drawShip();
}

void drawBg() {
  color(60);
  randomSeed(20);  // same pseudo-random points to be drawn
  for(int i = 0; i < 20; i++) {
    int starX = int(random(width));
    int starY = int(random(height));
    point(starX, starY);
  }
}

void moveShip() {
  if (keyPressed) {
    if (key == ' ') { // accelerate
      shipSpeed = 3;
    }
  } else if (shipSpeed > 0) {
      shipSpeed -= 0.2;
  }
  
  shipAngle += float(mouseX - pmouseX) / 20;
  
  shipX += shipSpeed * sin(shipAngle);
  shipY -= shipSpeed * cos(shipAngle);
  
  // screen edges
  if (shipX > width) shipX = 0;
  if (shipX < 0) shipX = width;
  if (shipY > height) shipY = 0;
  if (shipY < 0) shipY = height;
}

void drawShip() {
  translate(shipX, shipY);
  rotate(shipAngle);
  scale(pulseShip());
  beginShape();
  vertex(-20, 0);
  bezierVertex(13, -15, 0, -30, 0, -30);
  bezierVertex(0, -30, -13, -15, 20, 0);
  vertex(-20, 0);
  endShape();
}

float pulseShip() {
  scaleCycle ++;
  scaleCycle %= 360;
  float shipScale = 1 + sin(scaleCycle) * shipSpeed / 40;
  return shipScale;
}