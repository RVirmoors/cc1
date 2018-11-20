int[] x = { 
  5, 12, 3, 7, 20, 25, 66
};

fill(0);
float scaleFactor = (float)width / max(x);
print(scaleFactor);
// Read one array element each time through the for loop
for (int i = 0; i < x.length; i++) {
  float barHeight = height / x.length;
  fill(0);
  rect(i*barHeight, height-(x[i]*scaleFactor), barHeight - 4, height);
  fill(255);
  text(x[i], i*barHeight, height);
}
