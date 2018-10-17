int[] x = { 
  5, 12, 3, 7, 20
};

fill(0);
// Read one array element each time through the for loop
for (int i = 0; i < x.length; i++) {
  rect(0, i*20, x[i]*3, 16);
}