int state;
boolean open;
boolean moving;
// 0: open (white), 1: closing, 
// 2: closed (black), 3: opening
int brightness = 255;

void setup() {
  size(200, 200);
}

void draw() {
  background(brightness);
  if (open == true && moving == true) {
    brightness --;
  } else if (open == false && moving == true) {
    brightness ++;    
  }
  if (brightness == 0) {
    open = false;
    moving = false;
  }
  if (brightness == 255) {
    open = true;
    moving = false;
  }
  //print(state);
  //println(brightness);
}

void mouseClicked() {
  if (!moving) { // state == 0 || state == 2 
    // state is 0 or 2, then
    // start closing / opening
    moving = true;// = state + 1;
  }
}
