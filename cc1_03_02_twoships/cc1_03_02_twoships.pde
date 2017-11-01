Ship ship, s2;  // declare ship object variable

void setup() {
 size(400, 400); 
 stroke(100);
 strokeWeight(2);
 smooth(2);
 fill(230);
 // initialize ship object
 ship = new Ship(100,100);
 s2 = new Ship(300,300);
}

void draw() {
  background(20);
  drawBg();
//  ship.move();
  s2.move();
  s2.collide(ship);
  ship.draw();
  s2.draw();
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
  
  Ship(int initX, int initY) {
    x = initX;
    y = initY;
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
      edges();
  }
  
  void edges() {
    // screen edges
    if (x > width) x %= width;
    if (x < 0) x = width + x;
    if (y > height) y %= height;
    if (y < 0) y = height + y; 
  }
  
  void draw() {    
    // we need to include translation & rotation into a Matrix, ..
    // ..specific to each object
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
  
  void collide(Ship target) {
    float distance = distEdge(x, y, target.x, target.y);
    float diffX = ((x + width - target.x) % width);
    float diffY = ((y + height - target.y) % height);
    println(x, y, target.x, target.y, distance);
    if (distance < 44) {

      target.x -=  diffX ;
      target.y -=  diffY ;
      target.edges();
    }
  }
}

float distEdge(float x1, float y1, float x2, float y2) {
  return min (min( dist(x1, y1, x2, y2),
                dist(x1 + width, y1, x2, y2),
                dist(x1, y1, x2 + width, y2)
               ),
              min( dist(x1, y1 + height, x2, y2),
                dist(x1, y1, x2, y2 + height),
                dist(x1, y1 + height, x2 + width, y2)
               ),
              min( dist(x1 + width, y1, x2, y2 + height),
                dist(x1, y1, x2 + width, y2 + height),
                dist(x1 + width, y1 + height, x2, y2)
               )
             );
}