// adapted from https://processing.org/examples/animatedsprite.html

import processing.net.*;
// Declare a client
Client client;

float drag = 10;
Monstru []m = new Monstru[8];
String[] position = new String[8];
float thresh = 10;
int nImps;

class Monstru{
  float xpos, ypos;
  PImage[] images;
  int frame;
  //color rcol;
  Monstru() {
    ypos = height / 4;
    xpos = random(width);
    frame=int (random(3));
    //rcol= color (int (random(256)),int (random(256)),int (random(256)));
    loadGif("frame", 4);
  }
  void loadGif(String imagePrefix, int count) {
    images = new PImage[count];
    for (int i = 0; i < count; i++) {
      // Use nf() to number format 'i' into two digits
      String filename = imagePrefix + "_" + nf(i, 1) + "_delay-0.17s.png";
      images[i] = loadImage(filename);
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
  
  void drawGif(int count, int newpos) {
     // move xpos towards mouse
    //print(xpos);
    float dx = newpos - xpos;
    xpos = xpos + dx/drag;
    //print(xpos, dx, "\n");
   // collision();
    frame = (frame+1) % count;
   // tint (rcol);
    image(images[frame], xpos - images[frame].width/2, ypos);
    tint (255);
  }
}


void setup() {
  size(640, 360);
  background(20);
  frameRate(15);
  client = new Client(this, "127.0.0.1", 5204);
}

void draw() {
  background(20);
  // draw frame
  client.write(mouseX);
  for (int i = 0; i < nImps; i++) {
    int where = Integer.parseInt(position[i]);
    m[i].drawGif(3, where);
  }
}

void clientEvent(Client client) {
  String msg = client.readStringUntil('\n');
  // The value of msg will be null until the 
  // end of the String is reached
  if (msg != null) {
    position = split(msg, ',');
    int newSize = position.length - 1;
    if (newSize > nImps) {
        nImps = newSize;
        m[nImps - 1] = new Monstru();
    }
    println(nImps);
  }
}
