int xtra = 0;
int ytra = 0;

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
      if(keyPressed) {
        xtra = (int)random(2);
        ytra = (int)random(2);
      } else {
        xtra = ytra = 0;
      }      
      line(xDraw + xtra, yDraw + ytra, xDraw+4 + xtra, yDraw+4 + ytra);
    }
  }
}
/*
void keyPressed() {
  if (key == 8) { // 8 = ASCII code for backspace
    xtra = (int)random(100);
    ytra = (int)random(100);
  }
}
*/
