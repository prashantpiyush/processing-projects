Start start;
PFont font;

void setup() {
  size(800, 600);
  background(0);
  font = createFont("Arial", 50, true);
  start = new Start(font);
}

Snake snake;
Level lvl;
int highScore;

boolean firstGame = true;
boolean gameActive = false;
boolean showStart = true;

void draw() {
  background(0);
  if (showStart) {
    start.show(firstGame, snake, highScore);
  } else {
    lvl.show();
    snake.show();
    if(lvl.collide() || snake.eatItself()) {
      firstGame = false;
      gameActive = false;
      snake.stop();
      highScore = max(highScore, snake.getScore());
      textFont(font);
      fill(79, 163, 206);
      textAlign(CENTER);
      text("Game Over!! :(", width/2, 100);
      text("Your Score is:", width/2, 170);
      text(""+snake.getScore(), width/2, 240);
    } else {
      textFont(font);
      fill(79, 163, 206);
      textAlign(CENTER);
      text(""+snake.getScore(), width-100, 100);
    }
    if(lvl.eat()) {
      snake.score();
      lvl.spawnFood();
    }
  }
}

void keyPressed() {
  if (showStart && !gameActive) {
    gameActive = true;
    showStart = false;
    snake = new Snake(width/2, height/2);
    lvl = new Level2(snake);
  } else if (gameActive && !showStart) {
    int button = 0;
    if(key=='w' || key == 'W' || key=='8' || keyCode==UP) {
      button = UP;
    } else if(key=='a' || key=='A' || key=='4' || keyCode ==LEFT) button = LEFT;
    else if(key=='s' || key=='S' || key=='2' || key=='5' || keyCode==DOWN) button = DOWN;
    else if(key=='d' || key=='D' || key=='6' || keyCode==RIGHT) button = RIGHT;
    snake.move(button);
  } else {
    showStart = true;
    start.show(firstGame, snake, highScore);
  }
}

class Level {

  static final int size = 10;

  Snake snake;

  int foodx = 0;
  int foody = 0;

  Level(Snake snake) {
    this.snake = snake;
  }
  
  void show() {
  }
  
  boolean collide() {
    return false;
  }

  boolean eat() {
    return headOnFood();
  }

  void showFood() {
    if (foodx==0 && foody==0) {
      spawnFood();
    }
    fill(249, 250, 13);
    rect(foodx, foody, size, size);
  }

  boolean headOnFood() {
    if (snake.x<foodx+size && snake.x+snake.size>foodx) {
      if (snake.y<foody+size && snake.y+snake.size>foody) {
        return true;
      }
    }
    return false;
  }
  
  boolean wrongPos() {
    if(foodx+size>width-100 && foody<100) {
      return true;
    }
    int len = snake.xpos.size();
    for (int i=0; i<len; i++) {
      int x = snake.xpos.get(i);
      int y = snake.ypos.get(i);
      if (x<foodx+size && x+snake.size>foodx) {
        if (y<foody+size && y+snake.size>foody) {
          return true;
        }
      }
    }
    return false;
  }

  void spawnFood() {
    foodx = (int)Math.floor(random(size, width-2*size));
    foody = (int)Math.floor(random(size, height-2*size));
    while (wrongPos()) {
      foodx = (int)Math.floor(random(size, width-2*size));
      foody = (int)Math.floor(random(size, height-2*size));
    }
  }
}

class Level1 extends Level {
  
  Level1(Snake snake) {
    super(snake);
  }
  
  void show() {
    noStroke();
    fill(245, 10, 65);
    rect(0, 0, width, size);
    rect(0, 0, size, height);
    rect(width-size, 0, size, height);
    rect(0, height-size, width, size);
    showFood();
  }
  
  boolean collide() {
    if (snake.x<=size || snake.x+snake.size>=width-size) {
      return true;
    }
    if (snake.y<=size || snake.y+snake.size>=height-size) {
      return true;
    }
    return false;
  }
  
}

class Level2 extends Level {
  
  Level2(Snake snake) {
    super(snake);
  }
  
  void show() {
    noStroke();
    fill(245, 10, 65);
    rect(0, 0, width, size);
    rect(0, 0, size, height);
    rect(width-size, 0, size, height);
    rect(0, height-size, width, size);
    rect(200, 200, size, 200);
    rect(600, 200, size, 200);
    showFood();
  }
  
  boolean collide() {
    int x = snake.x;
    int y = snake.y;
    int d = snake.size;
    if (x<=size || x+d>=width-size) {
      return true;
    }
    if (y<=size || y+d>=height-size) {
      return true;
    }
    if(x<=200+size && x+d>=200 && y<=400 && y+d>=200) {
      return true;
    }
    if(x<=600+size && x+d>=600 && y<=400 && y+d>=200) {
      return true;
    }
    return false;
  }
  
  boolean wrongPos() {
    if(foodx+size>width-100& foody<100) {
      return true;
    }
    if(foodx<=200+size && foodx+size>=200 && foody<=400 && foody+size>=200) {
      return true;
    }
    if(foodx<=600+size && foodx+size>=600 && foody<=400 && foody+size>=200) {
      return true;
    }
    int len = snake.xpos.size();
    for (int i=0; i<len; i++) {
      int x = snake.xpos.get(i);
      int y = snake.ypos.get(i);
      if (x<foodx+size && x+snake.size>foodx) {
        if (y<foody+size && y+snake.size>foody) {
          return true;
        }
      }
    }
    return false;
  }
  
}

class Snake {

  int x, y;
  int vx, vy;
  int size = 5;
  int speed = 1;
  int score;
  int lastButton = 1000;

  boolean hasEaten = false;
  boolean firstCommand = true;

  ArrayList<Integer> xpos;
  ArrayList<Integer> ypos;

  Snake(int sx, int sy) {
    xpos = new ArrayList<Integer>(20);
    ypos = new ArrayList<Integer>(20);
    x = sx;
    y = sy;
    for (int i=0; i<5; i++) {
      xpos.add(sx+i*size);
      ypos.add(sy);
    }
    vy = vx = score = 0;
  }

  void move(int button) {
    if(firstCommand && button==RIGHT) {
      return;
    }
    firstCommand = false;
    if (button==UP && lastButton!=DOWN) {
      vy = -speed;
      vx = 0;
      lastButton = button;
    } else if (button==DOWN && lastButton!=UP) {
      vy = speed;
      vx = 0;
      lastButton = button;
    } else if (button==RIGHT && lastButton!=LEFT) {
      vx = speed;
      vy = 0;
      lastButton = button;
    } else if (button==LEFT && lastButton!=RIGHT) {
      vx = -speed;
      vy = 0;
      lastButton = button;
    }
  }

  void show() {
    noStroke();
    int len = xpos.size();
    if (vx==0 && vy==0) {
      for (int i=0; i<len; i++) {
        if (i==0) {
          fill(188, 0, 22);
        } else {
          fill(255, 255, 255);
        }
        rect(xpos.get(i), ypos.get(i), size, size);
      }
      return;
    }
    if (hasEaten) {
      addHead();
      addHead();
      hasEaten = false;
    }
    addHead();
    clearTail(len);
    for (int i=0; i<len; i++) {
      if (i==0) {
        fill(188, 0, 22);
      } else {
        fill(255, 255, 255);
      }
      rect(xpos.get(i), ypos.get(i), size, size);
    }
  }

  void addHead() {
    x = xpos.get(0)+ size*vx;
    y = ypos.get(0)+ size*vy;
    xpos.add(0, x);
    ypos.add(0, y);
  }

  void clearTail(int len) {
    xpos.remove(len);
    ypos.remove(len);
  }

  boolean eatItself() {
    int len = xpos.size();
    int x1 = xpos.get(0);
    int x2 = xpos.get(1);
    int y1 = ypos.get(0);
    int y2 = ypos.get(1);
    for (int i=2; i<len; i++) {
      int x = snake.xpos.get(i);
      int y = snake.ypos.get(i);
      if (x<x1+size && x+snake.size>x1) {
        if (y<y1+size && y+snake.size>y1) {
          return true;
        }
      }
      if (x<x2+size && x+snake.size>x2) {
        if (y<y2+size && y+snake.size>y2) {
          return true;
        }
      }
    }
    return false;
  }

  void stop() {
    vx = 0;
    vy = 0;
  }

  void score() {
    hasEaten = true;
    score++;
  }

  int getScore() {
    return score;
  }
}

class Start {
  
  PFont font;
  
  Start(PFont font) {
    this.font = font;
  }
  
  void show(boolean firstGame, Snake snake, int high) {
    fill(166, 229, 252);
    rect(0, 0, width, height);
    textFont(font);
    fill(79, 163, 206);
    textAlign(CENTER);
    text("Press any button to\nstart the game!!", width/2, 100);
    if(!firstGame && snake!=null) {
      text("Your Score was:", width/2, 240);
      text(""+snake.getScore(), width/2, 300);
      text("Highest Score:", width/2, 360);
      text(""+high, width/2, 420);
    }
  }
  
}