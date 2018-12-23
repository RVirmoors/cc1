import processing.sound.*;

int counter = -1; // 0 1 2 3. first trigger makes 0
int countRot = -1; // 0 1 2 3.
color f, h, v;

AudioIn micIn;
Amplitude loudness;
float thresh = 0.05;
float prevVol = 0.;
int timer = 0;

FFT fft;
float[] sum = new float[4];
float smoothingFactor = 0.2;

void setup() {
  size(500, 500);
  noStroke();
  
  // Create an Audio input and grab the 1st channel
  micIn = new AudioIn(this, 0);
  micIn.start();
  
  // Patch the input to the volume analyzer
  loudness = new Amplitude(this);
  loudness.input(micIn);
  
  // Create the FFT analyzer and connect the mic input.
  fft = new FFT(this, 4);
  fft.input(micIn);
}

void draw() {
  background(f); 
  processSound();
  // rotate from center
  translate(width/2, height/2);
  rotate(countRot * PI / 2.);
  // draw rectangles
  if (counter % 2 == 1) {  // 1 and 3 
    fill(v);
    rect(0, -height/2, width/2, height);
  }
  if (counter >= 2) {      // 2 and 3
    fill(h);
    rect(-width/2, 0, width, height/2);
  }
}

void processSound() {
  fft.analyze();
  for (int i = 0; i < 4; i++) {
    // Smooth the FFT spectrum data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;
  }
  
  float volume = loudness.analyze();
  //println(volume);
  if (volume > thresh && prevVol < thresh && timer >= 15) {
    step();
    timer = 0;
  }
  prevVol = volume;
  timer++;
}

color setCol() {
  int alpha = 127;
  int red = int(map(sum[0], 0., 0.01, 0, 255));
  int green = int(map(sum[1], 0., 0.01, 0, 255));
  int blue = int(map(sum[2], 0., 0.01, 0, 255));
  color newCol = color(red, green, blue, alpha);
  println(alpha);
  return newCol;
}

color randCol() {
  // generates a random colour with 50% transparency
  color randomColor = color(int(random(255)), int(random(255)), int(random(255)), 127);
  return randomColor; 
}

void step() {
  // increment counter
  counter = (counter + 1) % 4;
  //println(h);
  if (counter == 0) {
    // set colours
    f = setCol();
    countRot = (countRot + 1) % 4;
  }
  if (counter % 2 == 1) {  // 1 and 3
    v = setCol();
    v = v-f;
  }
  if (counter >= 2) {      // 2 and 3
    h = setCol();
    h = v-f;
  }
}
