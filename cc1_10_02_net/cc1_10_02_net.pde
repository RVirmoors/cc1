import processing.net.*;

Client client; // network client
Ship[] ships;  // ship objects
int totalShips = 0;
int myId = -1;

void setup() {
 size(400, 400); 
 stroke(100);
 strokeWeight(2);
 smooth(2);
 fill(230);
 client = new Client(this, "localhost", 10002);
 ships = new Ship[10]; // max 10 ship clients
}

void draw() {
  background(20);
  drawBg();
  if (myId != -1) { // if our ship was init'd by server
    ships[myId].move();
    // send new coords to server
    String data = myId + "," + ships[myId].x + "," + 
                  ships[myId].y + "," + ships[myId].angle;
    client.write(data);
  }
  for (int i = 0; i < totalShips; i++) {
    ships[i].draw();
  }
  if (client.available() > 0) {
    String data = client.readString();
    println(data);
    float shipData[] = float(split(data, ","));
    if (shipData[0] == 666) { // new client 
      while(totalShips < (int)shipData[1]) {
        // initialize new ship(s)
        ships[totalShips] = new Ship();
        totalShips++;
      }
      // if we don't have an Id, then the new client is US!
      if (myId == -1) myId = totalShips-1;  // starting w/ 0

    } else if (shipData[0] != myId) {
      int sId = (int)shipData[0];
      ships[sId].x = shipData[1];
      ships[sId].y = shipData[2];
      ships[sId].angle = shipData[3];    
    }
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

void clientEvent(Client client) {
/*  String data = client.read();
  println(data);/*
*/
}

class Ship {
  float x, y, angle, speed;
  int cycle;
  
  // constructors
  Ship() {
    x = width/2; 
    y = height/2;
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