class Ship {
  float shipX, shipY, shipAngle, shipSpeed;
  color c;
  boolean active; // TRUE = responding to controls
  
  Ship() {
    shipX = width/2;
    shipY = height/2;
    shipAngle = 0;
    shipSpeed = 0;
    c = 200; // white
    active = true;
  }
  
  Ship(float _x, float _y, color _c, boolean _a) {
    shipX = _x;
    shipY = _y;
    shipAngle = 0;
    shipSpeed = 0;
    c = _c; // whatever color I get from the main program
    active = _a; // program determines whether I am active
  }
  
  void moveShip(Ship other) {
    if (active) {
      shipSpeed = setSpeed(shipSpeed); // update shipSpeed 
    
      float angleDiff = (mouseX - pmouseX) / 20.;
      shipAngle += angleDiff;
    }
    shipX += sin(shipAngle) * shipSpeed;
    shipY -= cos(shipAngle) * shipSpeed;
    
    float d = dist(shipX, shipY, other.shipX, other.shipY);
    if (d < 20.) {
      // collision code
      println("BANG");
      shipAngle = random(360);
      // switch control from one ship to the other
      active = !active; // TRUE becomes FALSE (TODO check for bugs?)
    }
    
    // screen edges
    if (shipX > width) shipX = 0;
    if (shipX < 0) shipX = width;
    if (shipY > height) shipY = 0;
    if (shipY < 0) shipY = height;  
  }
  
  void drawShip() {
    pushMatrix(); // start transform layer
    translate(shipX, shipY);
    rotate(shipAngle);
    scale( pulseShip() );
    stroke(c); // set stroke color
    beginShape();
    vertex(-20, 0);
    bezierVertex(13, -15, 0, -30, 0, -30);
    bezierVertex(0, -30, -13, -15, 20, 0);
    vertex(-20, 0);
    endShape();
    popMatrix(); // end transform layer
  }
  
  float pulseShip() {
    float shipScale = 1.;
    shipScale += sin(frameCount) / 20. * shipSpeed;
    return shipScale;
  }
}

Ship s1, s2; 

void setup() {
  size(400, 400);
  strokeWeight(2);
  s1 = new Ship();
  // constructor args: x, y, color, active
  s2 = new Ship(100, 100, color(255,0,0), false); // color can also be #FF0000
}

void draw() {
  drawBg();
  s1.moveShip(s2); // move ship 1, looking also at ship 2
  s1.drawShip();
  s2.moveShip(s1);
  s2.drawShip();
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

float setSpeed(float shipSpeed) {
  if (keyPressed) {
    if (key == ' ') {
      shipSpeed = 3.;
    }    
  } else if (shipSpeed > 0) {
    shipSpeed -= 0.03;
  }
  return shipSpeed;
}
