// adapted from https://processing.org/examples/animatedsprite.html

float drag = 10;
Monstru []m = new Monstru[2];
float thresh = 10;

class Monstru{
  float xpos, ypos;
  PImage[] images;
  int frame;
  color rcol;
  Monstru() {
    ypos = height / 4;
    xpos = random(width);
    frame=int (random(3));
    rcol= color (int (random(256)),int (random(256)),int (random(256)));
    loadGif("frame", 4);
    println("init",rcol);
  }
  void loadGif(String imagePrefix, int count) {
    images = new PImage[count];
    for (int i = 0; i < count; i++) {
      // Use nf() to number format 'i' into two digits
      String filename = imagePrefix + "_" + nf(i, 1) + "_delay-0.17s.png";
      images[i] = loadImage(filename);
      println("aftertint",rcol);
    }
  }
  void collision(){
    for (int i = 0; i < m.length; i++)
    {float dist = abs (m[i].xpos - xpos);
      if( dist<thresh && dist>0) {
        m[i].xpos += random(width) - width / 2;
      }
    }
    
   }
  
  void drawGif(int count) {
     // move xpos towards mouse
    //print(xpos);
    float dx = mouseX - xpos;
    xpos = xpos + dx/drag;
    //print(xpos, dx, "\n");
    collision();
    frame = (frame+1) % count;
    tint (rcol);
    image(images[frame], xpos - images[frame].width/2, ypos);
    tint (255);
  }
}


void setup() {
  size(640, 360);
  background(20);
  frameRate(15);
  m[0] = new Monstru();
  m[1] = new Monstru();
}

void draw() {
  background(20);
  // draw frame
  m[0].drawGif(3);
  m[1].drawGif(3);
}
