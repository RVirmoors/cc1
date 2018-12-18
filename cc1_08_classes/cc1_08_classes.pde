void setup() {
  color red = color(255, 0, 0); 
  color green = #00FF00;
  Apple x = new Apple(red);
  Apple y = new Apple(green);
  x.show();
  y.show();
  print("\n");
  x.copy(y);
  y.r = 12;
  x.show();
  y.show();
}
