PImage maze;

class Guy {
  int x, y;
  Guy(int _x, int _y) {
    x = _x; y = _y; 
  }
  void display() {
    ellipse(x, y, 20, 20);
  }
  
  boolean checkTraj(int x1, int y1, int x2, int y2) {
    // x1,2 have to be smaller than y1,2
    if (x1 > x2) return checkTraj(x2,y1,x1,y2);
    if (y1 > y2) return checkTraj(x1,y2,x2,y1);
    int i, j; // iterators
    boolean allClear = true;
    for (i = x1; i <= x2; i++) 
      for (j = y1; j <= y2; j++) 
        if (maze.get(i, j) == -1.0) allClear = false;
    return allClear;
  }
  
  void goTo(int xTo, int yTo) {
    int newX, newY;
    float dx = (xTo - x) / 10.;
    float dy = (yTo - y) / 10.;
    newX = x + (int)dx;
    newY = y + (int)dy;
//    println(checkTraj(x, newX, y, newY));
    if (checkTraj(x,y, newX, newY)) {
       x = newX; y = newY;
    }
  }
}

Guy mazeGuy = new Guy(80, 80);

void setup() {
   size(640,480);
   maze = loadImage("maze.png");
}

void draw() {
   background(maze);
   mazeGuy.display();
   if (mousePressed) {
     mazeGuy.goTo(mouseX, mouseY);
   }
}