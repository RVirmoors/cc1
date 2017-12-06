PImage maze;

class Guy {
  int x, y;
  Guy(int _x, int _y) {
    x = _x; y = _y; 
  }
  void display() {
    ellipse(x, y, 20, 20);
  }
  
  void goTo(int xTo, int yTo) {
    int newX, newY;
    if (xTo > x) newX=x+1; else newX=x-1;
    if (yTo > y) newY=y+1; else newY=y-1;
    float wall = maze.get(newX, newY);
    println(wall);
    if (wall != -1.0) {
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
   loadPixels(); // refresh pixels[] array
   mazeGuy.display();
   if (mousePressed) {
     mazeGuy.goTo(mouseX, mouseY);
   }
}