void setup() {
  size(100, 100); // init screen
  frameRate(0.8); // set frame rate
  textSize(32);
}


void draw() {
  background(0);
  text(int(random(100)), 35, 60); 
}
