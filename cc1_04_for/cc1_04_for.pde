void setup() {
  size(500, 500);
}

void draw() {
  background(255);
/*  int xDraw = 0;
  while ( xDraw < mouseX ) {
    line(xDraw, 0, xDraw, xDraw);
    xDraw = xDraw + 10; // xDraw += 10;
  }*/
  for( int xDraw = 0; xDraw < mouseX; xDraw+=10) {
    line(xDraw, 0, xDraw, xDraw);
  }
}
