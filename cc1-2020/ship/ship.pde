import oscP5.*;
import netP5.*;
  
OscP5 oscP5;

float shipX, shipY, shipAngle, shipSpeed;

float fromWekinator, wekDir;

void setup() {
  size(400, 400);
  strokeWeight(2);
  shipX = width/2;
  shipY = height/2;
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
}

void draw() {
  drawBg();
  moveShip();
  drawShip();  
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

void moveShip() {
  setSpeed();  
  
  float angleDiff = wekDir;//(mouseX - pmouseX) / 20.;
  // int division:   15 / 20  = 0
  // float division: 15 / 20. = 0.75
  //println(angleDiff);
  shipAngle += angleDiff;
  
  shipX += sin(shipAngle) * shipSpeed;
  shipY -= cos(shipAngle) * shipSpeed;
  
  // screen edges
  if (shipX > width) shipX = 0;
  if (shipX < 0) shipX = width;
  if (shipY > height) shipY = 0;
  if (shipY < 0) shipY = height;  
}

void setSpeed() {
  if (fromWekinator == 2) {
      shipSpeed = 3.;    
  } else if (shipSpeed > 0) {
    shipSpeed -= 0.03;
  }
}

void drawShip() {
  translate(shipX, shipY);
  rotate(shipAngle);
  scale( pulseShip() );
  beginShape();
  vertex(-20, 0);
  bezierVertex(13, -15, 0, -30, 0, -30);
  bezierVertex(0, -30, -13, -15, 20, 0);
  vertex(-20, 0);
  endShape();
}

float pulseShip() {
  float shipScale = 1.;
  shipScale += sin(frameCount) / 30. * shipSpeed;
  return shipScale;
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/wek/outputs")==true) {
    println(" typetag speed: "+theOscMessage.typetag());
    if(theOscMessage.checkTypetag("ff")) {   
      fromWekinator = theOscMessage.get(0).floatValue();
      wekDir = theOscMessage.get(1).floatValue();
    }
  }
}
