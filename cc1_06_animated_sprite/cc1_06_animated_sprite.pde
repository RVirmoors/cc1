// adapted from https://processing.org/examples/animatedsprite.html

float xpos, ypos;
float drag = 10;
PImage[] images;
int frame;
boolean shooting;

void setup() {
  size(640, 360);
  background(20);
  frameRate(15);
  ypos = height / 4;
  xpos = width / 2;
  loadGif("frame", 18);
}

void draw() {
  background(20);
  // move xpos towards mouse
  float dx = mouseX - xpos;
  xpos = xpos + dx/drag;
  // draw frame
  if (shooting) {
    drawGif(xpos, ypos, 12, 6);
    if (frame == 17) {
      shooting = false;
      println("stop shooting");
      frame = 0;
    }
  }
  else // walking
    drawGif(xpos, ypos, 0, 12);
}

void loadGif(String imagePrefix, int count) {
  images = new PImage[count];
  for (int i = 0; i < count; i++) {
    // Use nf() to number format 'i' into two digits
    String filename = imagePrefix + "_" + nf(i, 2) + "_delay-0.18s.png";
    images[i] = loadImage(filename);
  }
}

void drawGif(float xpos, float ypos, int start, int count) {
  frame = (frame+1) % count + start;
  image(images[frame], xpos - images[frame].width/2, ypos);
}

void mousePressed() {
  shooting = true;
}
