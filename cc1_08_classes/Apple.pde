class Apple {
  int r, g, b;
  Apple(color _c) {
    r = int(red(_c));
    g = int(green(_c));
  }
  void show() {
    print(r, g, b, "   ");
  }
  void copy(Apple what) {
     r = what.r;
     g = what.g;
     b = what.b;
  }
}
