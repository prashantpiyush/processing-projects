int n = 100;
star[] stars = new star[n];

void setup() {
  size(800, 600);
  background(0);
  for (int i=0; i<n; i++) {
    stars[i] = new star();
  }
}

void draw() {
  background(0);
  translate(width/2, height/2);
  for (int i=0; i<n; i++) {
    stars[i].show();
    stars[i].move();
  }
}

class star {
  float x;
  float y;
  float z;

  star() {
    x = random(-width/2, width/2);
    y = random(-height/2, height/2);
  }

  void show() {
    float f = dist(0, 0, x, y)*0.03;
    stroke(255);
    ellipse((int)x, (int)y, f, f);
  }

  void move() {
    float d = dist(0, 0, x, y);
    float v = d * 0.003;
    if (x==0) {
      if (y<0) y -= v;
      else y += v;
    } else if (y==0) {
      if (x<0) x -= v*1.5;
      else x += v*1.5;
    } else {
      float m = y/x;
      if (x<0) x -= v*1.5;
      else x += v*1.5;
      y = m * x;
    }
    check();
  }

  void check() {
    if (x<-width*0.5 || x>width*0.5 || y>height*0.5 || y<-height*0.5) {
      x = random(-width/2, width/2);
      y = random(-height/2, height/2);
    }
  }
}