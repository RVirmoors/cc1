PVector p1, p2, p3, p4; // coordinates
float l1, l2, l3, l4; // initial light values
int dir = 1;

void setup() {
  size(500, 500);
  p1 = new PVector(0.0, 0.0, 0.0);
  p2 = new PVector(0.0, 0.0, 0.0);
  p3 = new PVector(0.0, 0.0, 0.0);
  p4 = new PVector(0.0, 0.0, 0.0);
  p1.set(random(width),random(height),random(5));
  p2.set(random(width),random(height),random(5));
  p3.set(random(width),random(height),random(5));
  p4.set(random(width),random(height),random(5));
  l1 = p1.z;
  l2 = p2.z;
  l3 = p3.z;
  l4 = p4.z;
}

void draw() {
  background(0);
  drawPoints();
  float chance = random(1);
  if (chance < 0.1) 
    sparkle((int)random(4));
  if (p1.z > l1)
     sparkle(0);
  if (p2.z > l2)
     sparkle(1);
  if (p3.z > l3)
     sparkle(2);
  if (p4.z > l4)
     sparkle(3);   
//  connectPoints();
}

void drawPoints() {
  stroke(255);
  strokeWeight(p1.z);
  point(p1.x, p1.y);
  strokeWeight(p2.z);
  point(p2.x, p2.y);
  strokeWeight(p3.z);
  point(p3.x, p3.y);
  strokeWeight(p4.z);
  point(p4.x, p4.y);
}

void sparkle(int which) {
  if (which == 0) {
    if (p1.z > 10)
      dir = -1;
    if (p1.z < l1)
      dir = 1;
    p1.z+= dir * random(3);
//    print(p1.z , " > ", l1, "\n");
  }
  if (which == 1 && p2.z < 10) {
    p2.z+= random(3);
  }
  if (which == 2 && p3.z < 10) {
    p3.z+= random(3);
  }
  if (which == 3 && p4.z < 10) {
    p4.z+= random(3);
  }
}
