PImage maze;
PGraphics pg;  // graphics context
float factor = 2.7; // alt zoom
float zoom = 1; // current zoom
float transX, transY;

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
  
  void goTo(float xTo, float yTo) {
    int newX, newY;
    float dx = (xTo - x) / 10.;
    float dy = (yTo - y) / 10.;  
    newX = x + (int)dx;
    newY = y + (int)dy;
    if (checkTraj(x,y, newX, newY)) {
       x = newX; y = newY;
    }
  }
}

Guy mazeGuy = new Guy(80, 80);

void setup() {
   size(640,480);
   pg = createGraphics(640,480); // NOT "new PGraphics()"
   maze = loadImage("maze.png");
}

void draw() {
   pg.beginDraw();
   pg.background(maze); 
   
   if (zoom != 1) {
     altView(); // zoom in on player
   }
         
   pg.loadPixels(); // refresh pixels[] array


   if (mousePressed) // move player twd mouse
     mazeGuy.goTo(mouseX, mouseY);

   pg.endDraw();
   image(pg,0,0); // draw the pg image
   mazeGuy.display(); // draw ellipse
}

void altView() {  
  transX = (width / 2 - mazeGuy.x*zoom);
  transY = (height / 2 - mazeGuy.y*zoom);

  translate(transX, transY);
  scale(zoom, zoom);
}

void keyPressed() {
  if (zoom == factor) {
    zoom = 1;
  } else zoom = factor;
  println(width/zoom/2,mazeGuy.x);
}