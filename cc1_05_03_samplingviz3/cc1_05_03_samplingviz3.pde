float[] data = new float[10];
int[] upTo = new int[10];
boolean spawn = false;
boolean reset = true;
boolean animating = false;
float animSize = 600;
PGraphics bg;

class Brick {
  int x, y;
  float f;
  Brick(int _x, int _y, float _f) {
    x = _x; y = _y; f = _f;
  }
}

Brick newOne = new Brick(0, 0, 0);

void setup() {
  size(600, 600); 
  bg = createGraphics(600, 600);
  frameRate(30);
  String[] stuff = loadStrings("data.csv");
  data = float(split(stuff[0], ','));
  float maximum = max(data);
  for(int i = 0; i < 10; i++) 
    data[i] = map(data[i], 0, maximum, 0, 255);
}
void draw() {
  if (reset) {
    drawBg();
    reset = false;
  }
  if (spawn) {
    drawBg();
    image(bg, 0, 0);
    if(!animating) {
      newOne = addPers();
      animating = true;
    } else {
      float drawX = map(animSize, 600, 60, 0, newOne.x);
      float drawY = map(animSize, 600, 60, 0, newOne.y);
      fill(newOne.f);
      rect(drawX*60, height - drawY*60, animSize, -animSize);
      animSize -= 20;
      if (animSize == 60) {
        animating = false;
        animSize = 600;
//        println("done animating");
        drawPers(newOne);
      }
    }
  }
}
void drawBg() {
  background(10,33,20);
  noStroke();
}
Brick addPers() {
    int decile = (int)random(10);
    int column = (int)random(10);
    Brick pers = new Brick(column, upTo[column], data[decile]);
    upTo[column]++;
    return pers;
}
void drawPers(Brick pers) {
    bg.beginDraw();
    bg.fill(pers.f);
    bg.rect(pers.x*60, height - pers.y*60, 60, -60);
    bg.endDraw();
}
void mousePressed() {
  if (mouseButton == LEFT)
    spawn = !spawn;
  else
    reset = true;
}