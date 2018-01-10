import java.util.Iterator; 
// based on https://processing.org/examples/simpleparticlesystem.html

ParticleSystem ps;

void setup() {
  size(640, 360);
  ps = new ParticleSystem(new PVector(width/2, 50));
}

void draw() {
  background(0);
  ps.addParticle();
  ps.run();
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
    velocity = new PVector(random(-1, 1), random(-2, 0));
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