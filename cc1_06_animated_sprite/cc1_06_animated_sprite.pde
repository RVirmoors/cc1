// adapted from https://processing.org/examples/animatedsprite.html

float xpos, ypos;
float drag = 10;
PImage[] images;
int frame;

void setup() {
  size(640, 360);
  background(20);
  frameRate(15);
  ypos = height / 4;
  xpos = width / 2;
  loadGif("frame", 12);
}

void draw() {
  background(20);
  float dx = mouseX - xpos;
  xpos = xpos + dx/drag;
  drawGif(xpos, ypos, 12);
}

void loadGif(String imagePrefix, int count) {
  images = new PImage[count];
  for (int i = 0; i < count; i++) {
    // Use nf() to number format 'i' into two digits
    String filename = imagePrefix + "_" + nf(i, 2) + "_delay-0.18s.png";
    images[i] = loadImage(filename);
  }
}

void drawGif(float xpos, float ypos, int count) {
  frame = (frame+1) % count;
  image(images[frame], xpos - images[frame].width, ypos);
}