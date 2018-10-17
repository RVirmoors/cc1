Ship ship;  // declare ship object variable

void setup() {
 size(400, 400); 
 stroke(100);
 strokeWeight(2);
 smooth(2);
 fill(230);
 // initialize ship object
 ship = new Ship();
}

void draw() {
  background(20);
  drawBg();
  ship.move();
  ship.draw();
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
  
  // constructor
  Ship() {
    x = width/2; 
    y = height/2;
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
    translate(x, y);
    rotate(angle);
    scale(pulse());
    beginShape();
    vertex(-20, 0);
    bezierVertex(13, -15, 0, -30, 0, -30);
    bezierVertex(0, -30, -13, -15, 20, 0);
    vertex(-20, 0);
    endShape();
  }
  
  float pulse() {
    cycle ++;
    cycle %= 360;
    float shipScale = 1 + sin(cycle) * speed / 40;
    return shipScale;
  }
}