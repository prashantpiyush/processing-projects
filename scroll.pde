void setup() {
  size(800, 600);
  background(0);
}

int x = 100, y = 100;
double vx = 0, vy = 0;
double ay = 2;
int r = 25;

void draw() {
  background(0);
  ellipse(x, y, 2*r, 2*r);
  vy += ay;
  if(y+vy+r>=height) {
    y = height-r;
    vy *= -1;
    vy -= vy * 0.2;
  } else if(y+vy-r<=0) {
    y = 0+r;
    vy *= -1;
    vy -= vy * 0.2;
  } else {
    y += vy;
  }
}

void mouseClicked() {
  y = 100;
  vy = 0;
}