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
  float segmentLength, angleGen;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
    segmentLength = 50;
  }

  void addParticle() {
    PVector newPos = origin;
    PVector displace = new PVector(1, 0);
    displace.setMag(30);
    displace.rotate(angleGen);
    newPos.add(displace);
    if (random(1) < 0.995)
      particles.add(new Particle(newPos));
    else
      particles.add(new Deflector(newPos)); 
    angleGen += 10;
    if (angleGen == 360) angleGen = 0;
  }
  
  void display() {
    Iterator<Particle> it1 = particles.iterator();
    while (it1.hasNext()) {
      Particle p1 = it1.next();
      Iterator<Particle> it2 = particles.iterator();
      while (it2.hasNext()) {
        Particle p2 = it2.next();
        float distance = dist(p1.position.x, p1.position.y, p2.position.x, p2.position.y);
        if ((distance < segmentLength) && (distance > segmentLength*0.9)) {
          stroke(255, 255);
          // if deflector, deflect!
          if (p1 instanceof Deflector)
            p2.acceleration = PVector.mult(p1.velocity,-0.1*p1.lifespan/225);      
          // else, link velocities for regular particles
          else if (!(p2 instanceof Deflector)) {
            line(p1.position.x, p1.position.y, p2.position.x, p2.position.y);
            p2.velocity = p1.velocity;
          }
        }
      }
    }   
  }

  void run() {
    origin.set(mouseX, mouseY);
    segmentLength = abs(mouseX-pmouseX) + abs(mouseY-pmouseY);
    segmentLength = constrain(segmentLength, 20, 70);
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
    //acceleration = new PVector(0, 0);//random(-0.01, 0.01));
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = PVector.mult(velocity, -0.0001);
    position = l.copy();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
  // acceleration.mult(0.5);
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(position.x, position.y, 3, 3);
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

class Deflector extends Particle {
  Deflector (PVector l) {
   super(l); 
  }
  
  void update() {
    PVector m = new PVector(mouseX, mouseY);
    m.sub(position);
    m.mult(0.001);
    velocity.add(m);
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 0.2;
  }
  
  void display() {
    stroke(255, 0, 0, lifespan);
    fill(255, 0, 0, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }
}