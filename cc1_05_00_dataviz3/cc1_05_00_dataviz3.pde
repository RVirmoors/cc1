int[] x = { 
  5, 12, 3, 7, 20
};

fill(0);
// Read one array element each time through the for loop
for (int i = 1; i < x.length; i++) {
  line((i-1)*25, 100-x[i-1]*3, i*25, 100-x[i]*3);
}