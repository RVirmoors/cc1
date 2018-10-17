size(100, 100);
int N = 50;
/*
int drawX = 0;
while(drawX < N) {
  line(drawX, 0, drawX, 100);
  drawX = drawX + 4; // or "drawX += 4"
}*/
for( int drawX = 0; drawX < N ; drawX+=6 ) {
  line(drawX, 0, drawX, 100);
}