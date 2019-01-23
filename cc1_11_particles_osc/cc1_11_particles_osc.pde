import java.util.Iterator; 
// based on https://processing.org/examples/simpleparticlesystem.html
import oscP5.*;
import netP5.*;

OscP5 oscP5;
float lumina;

ParticleSystem ps;

void setup() {
  size(640, 360);
  ps = new ParticleSystem(new PVector(width/2, 50));
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,7400);
}

void draw() {
  background(lumina); 
  ps.addParticle();
  ps.run();
}

void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */  
  if(theOscMessage.checkAddrPattern("/light")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      lumina = theOscMessage.get(0).floatValue();  
      //print("### received an osc message /test with typetag f.");
      return;
    }  
  } 
}


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }
  
  void display() {
    Iterator<Particle> it1 = particles.iterator();
    while (it1.hasNext()) {
      Particle p1 = it1.next();
      Iterator<Particle> it2 = particles.iterator();
      it2 = it1;
      while (it2.hasNext()) {
        Particle p2 = it2.next();
        if (dist(p1.position.x, p1.position.y, p2.position.x, p2.position.y) < 50) {
          stroke(255, 255);
          line(p1.position.x, p1.position.y, p2.position.x, p2.position.y);
        }
      }
    }   
  }

  void run() {
    display();
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}


// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(lumina/10 - 0.5, random(-2, 0)); // random(-1, 1)
    position = l.copy();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
