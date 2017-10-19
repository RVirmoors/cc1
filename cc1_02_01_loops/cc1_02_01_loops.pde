size(100, 100);
int x = 20;
int drawX = 0;

while(drawX < x) {
  line(drawX, 0, drawX, 100);
  drawX += 4;
}