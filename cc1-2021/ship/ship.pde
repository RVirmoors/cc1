Spaceship shipA, shipB;

void setup() {
  size(400, 400);
  strokeWeight(2);
  shipA = new Spaceship();
  shipB = new Spaceship('a'); // accel with key 'a'
}

void draw() {
  drawBg();
  shipA.move();
  shipA.draw();
  shipB.move();
  shipB.draw();
  collide(shipA, shipB);
}

void drawBg() {
  background(20);
  stroke(200);  
  randomSeed(42); // pseudo random number generation
  for (int i = 0; i < 20; i++) {
    float pointX = random(width); // X: 0 ... width
    float pointY = random(height); // Y: 0... height
    point(pointX, pointY);
  }
}

void collide (Spaceship a, Spaceship b) {
  
}
