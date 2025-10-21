class Star {
  //Member variables
  int x, y, w, speed;

  Star() {
    x = int (random(width));
    y = -10;
    w = int(random(1, 4));
    speed = int(random(2, 8));
  }

  void display() {
    fill(random(255, 255));
    ellipse(x, y, w, w);
  }

  void move() {
    y = y + speed;
  }

  boolean reachedBottom() {
    if (y>height+w) {
      return true;
    } else {
      return false;
    }
  }
}
