int xtra = 0;
int direction = 1;

void setup() {
  size(500, 500);
}

void draw() {
  background(255);
  smooth();
/*  int xDraw = 0;
  while ( xDraw < mouseX ) {
    line(xDraw, 0, xDraw, xDraw);
    xDraw = xDraw + 10; // xDraw += 10;
  }*/
  for( int xDraw = 0; xDraw < mouseX; xDraw+=10) {
    for(int yDraw = 0; yDraw < mouseY; yDraw+=10) {
      if (mousePressed)
        print(xDraw,", ",yDraw,"\n");
      line(xDraw, yDraw, xDraw+4, yDraw+4);
    }
  }
}

void keyPressed() {
  
}
