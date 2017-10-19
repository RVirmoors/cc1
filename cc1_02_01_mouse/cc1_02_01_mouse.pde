boolean freeze = false;

void setup() {
  size(100, 100);
}

void draw() {
  //background(204);
  float speed = (mouseX - pmouseX)^2 + (mouseY - pmouseY)^2;
  if (!freeze)
    line(mouseX, 0, mouseX, speed*10);
}

void mousePressed() {
  freeze = !freeze;
}