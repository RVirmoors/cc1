int xtra = 0;
int ytra = 0;

void setup() {
  size(500, 500);
//  frameRate(2);
  textSize(10);
}

void draw() {
  background(0);
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
      fill(150, yDraw / 2, ytra * 300);
//      line(xDraw - xtra, yDraw - ytra, xDraw + xtra, yDraw + ytra);
      text(xtra,xDraw, yDraw);
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
