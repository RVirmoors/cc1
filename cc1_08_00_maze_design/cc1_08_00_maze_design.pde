void setup() {
  size(640,480);
  background(0); 
  stroke(255); strokeWeight(3); fill(0); // drawing params
  quad(50,20, 450,130, 600,330, 80,420);
  line(250, 77, 330, 374);
  stroke(0); strokeWeight(20);
  ellipse(290,200,20,20);
  save("maze.png");  // save to file
}