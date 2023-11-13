int state = 0; // 0 = idle, 1 = presence, 2 = sleep

boolean motion;
boolean sound;
int timer = 0;

float x;
float f;

void setup() {
  size(500, 500);
}

void bgCerc() {
  background(0);
  fill(255);
  circle(250, 250, 500);
}

void draw() {
  motion = (mouseX != pmouseX);
  sound = mousePressed;

  if (state == 0) { // from idle
    if (motion) {
      state = 1; // to presence
    }
    timer++;
    if (!motion && timer >= 90) {
      state = 2;
    }
  }
  if (state == 1) { // from presence
    if (motion) {
      timer = 0;
    } else {
      timer++;
    }
    if (!motion && timer >= 60) {
      state = 0;  // to idle
      timer = 0;
    }
  }
  if (state == 2) {
    if (sound) {
      state = 1;
      timer = 0;
    }
  }
  
  bgCerc();
  fill(80);
  if (state == 0) {
    x = lerp(x, 250, 0.05);
    circle(x, 250, 150);
    f = 255;
  } else if (state == 1) {
    x = lerp(x, mouseX, 0.05);
    circle(x, 250, 150);
  } else if (state == 2) {
    f = lerp(f, 80, 0.05);
    fill(f);
    circle(250, 250, 500);
  }

  println("sound: " + sound);
  println(state);
}