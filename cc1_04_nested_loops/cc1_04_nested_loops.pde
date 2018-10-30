// from the Processing Handbook

for (int y = 20; y <= 80; y+=5) {
  for (int x = 20; x <= 80; x+=5) {
    if ((x % 10) == 0) {
      line(x, y, x+3, y-3);
    } else {
      line(x, y, x+3, y+3);
    }
  }  
}