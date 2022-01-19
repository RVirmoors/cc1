class Spaceship {
  float x, y, angle, speed;
  char accelKey;

  Spaceship() {
    x = width/2;
    y = height/2;
    accelKey = ' ';
  }
  
  Spaceship(char _k) {
    x = width/2;
    y = height/2;
    accelKey = _k;
  }

  void move() {
    setSpeed();

    float angleDiff = (mouseX - pmouseX) / 20.;
    // int division:   15 / 20  = 0
    // float division: 15 / 20. = 0.75
    println(angleDiff);
    angle += angleDiff;

    x += sin(angle) * speed;
    y -= cos(angle) * speed;

    // screen edges
    if (x > width) x = 0;
    if (x < 0) x = width;
    if (y > height) y = 0;
    if (y < 0) y = height;
  }

  void setSpeed() {
    if (keyPressed) {
      if (key == accelKey) {
        speed = 2.;
      }
    } else if (speed > 0) {
      speed -= 0.03;
    }
  }

  void draw() {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    scale( pulseShip() );
    beginShape();
    vertex(-20, 0);
    bezierVertex(13, -15, 0, -30, 0, -30);
    bezierVertex(0, -30, -13, -15, 20, 0);
    vertex(-20, 0);
    endShape();
    popMatrix();
  }

  float pulseShip() {
    float shipScale = 1.;
    shipScale += sin(frameCount) / 10. * speed;
    return shipScale;
  }
}
