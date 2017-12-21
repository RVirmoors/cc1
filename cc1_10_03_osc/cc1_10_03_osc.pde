import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myBroadcastLocation; 
int sendPort = 32000;
int listenPort = 12000;
Ship[] ships;  // ship objects
int totalShips = 0;
int myId = -1;

void setup() {
 size(400, 400); 
 stroke(100);
 strokeWeight(2);
 smooth(2);
 fill(230);
 oscP5 = new OscP5(this, listenPort);
 myBroadcastLocation = new NetAddress("127.0.0.1", sendPort);
 OscMessage mess = new OscMessage("/server/connect");
 oscP5.send(mess, myBroadcastLocation);
 ships = new Ship[10]; // max 10 ship clients
}

void draw() {
  background(20);
  drawBg();
  if (myId != -1) { // if our ship was init'd by server
    ships[myId].move();
    // send new coords to server
    OscMessage mess = new OscMessage("/"+myId); // e.g.: /0/
    mess.add(ships[myId].x);mess.add(ships[myId].y);mess.add(ships[myId].angle);
    oscP5.send(mess, myBroadcastLocation);
  }
  for (int i = 0; i < totalShips; i++) {
    ships[i].draw();
  }
}

void oscEvent(OscMessage theOscMessage) {
  //println(theOscMessage.addrPattern());
  String address[] = split(theOscMessage.addrPattern(),"/");
  int addr = int(address[1]);
  if (theOscMessage.checkAddrPattern("/count")==true) { // new client 
    while (totalShips < theOscMessage.get(0).intValue()) {
      // initialize new ship(s)
      ships[totalShips] = new Ship();
      totalShips++;
    }
    // if we don't have an Id, then the new client is US!
    if (myId == -1) myId = totalShips-1;  // starting w/ 0
  }
  else if (addr != myId) {
    int sId = addr;
    println(theOscMessage.get(0).floatValue());
    ships[sId].x = theOscMessage.get(0).floatValue();
    ships[sId].y = theOscMessage.get(1).floatValue();
    ships[sId].angle = theOscMessage.get(2).floatValue();
  }
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

class Ship {
  float x, y, angle, speed;
  int cycle;
  
  // constructors
  Ship() {
    x = width/2; 
    y = height/2;
    angle = 0;
  }
  Ship(float _x, float _y, float _a) {
    x = _x;
    y = _y;
    angle = _a;
  }
  
  // functions:
  void move() {
      if (keyPressed) {
        if (key == ' ') { // accelerate
          speed = 3;
        }
      } else if (speed > 0) {
          speed -= 0.2;
      }
      
      angle += float(mouseX - pmouseX) / 20;
      
      x += speed * sin(angle);
      y -= speed * cos(angle);
      
      // screen edges
      if (x > width) x = 0;
      if (x < 0) x = width;
      if (y > height) y = 0;
      if (y < 0) y = height;
  }
  
  void draw() {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    scale(pulse());
    beginShape();
    vertex(-20, 0);
    bezierVertex(13, -15, 0, -30, 0, -30);
    bezierVertex(0, -30, -13, -15, 20, 0);
    vertex(-20, 0);
    endShape();
    popMatrix();
  }
  
  float pulse() {
    cycle ++;
    cycle %= 360;
    float shipScale = 1 + sin(cycle) * speed / 40;
    return shipScale;
  }
}