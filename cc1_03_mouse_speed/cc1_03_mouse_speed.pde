boolean drawing; // global value

void setup() {
  
  size(400,300); // set width, height
  frameRate(50);
  stroke(0);
  drawing = true;
}

void draw() {
  if (drawing) {
    int speed = abs(mouseX - pmouseX);
    print(speed+"\n");
    if (speed > 50) {
      background(255);
    }
    line(mouseX, height, mouseX, height-speed);
  }
}

void mousePressed() {
  drawing = !drawing;
}
