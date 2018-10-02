void setup() {
  size(100, 100);
  frameRate(30);
  textSize(32);
}

int number=50;

void draw() {
  background(0);
  text(number, 30, 60); 
}

void keyPressed() {
  number = int(random(100));
}
