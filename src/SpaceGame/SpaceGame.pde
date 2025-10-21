// Joey Zheng | 9/23/25 | SpaceGame
Spaceship s1;
ArrayList<PowerUp> powups = new ArrayList<PowerUp>();
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<Star> stars = new ArrayList<Star>();
Timer rockTimer, puTimer, levelTimer;
int score, rocksPassed, level, rtime;
boolean play;

void setup() {
  size(500, 500);
  rtime = 1000;
  s1 = new Spaceship();
  puTimer = new Timer(5000);
  puTimer.start();
  levelTimer = new Timer(5000);
  levelTimer.start();
  rockTimer = new Timer(rtime);
  rockTimer.start();
  score = 0;
  rocksPassed = 0;
  play = false;
  level = 1;
}

void draw() {
  if (play == false) {
    startScreen();
  } else {
    background(0);

    stars.add(new Star());

    if (puTimer.isFinished()) {
      powups.add(new PowerUp());
      puTimer.start();
    }

    for (int i = 0; i < powups.size(); i++) {
      PowerUp pu = powups.get(i);
      pu.display();
      pu.move();
      //collision detection between powerup and ship
      if (pu.intersect(s1)) {
        //Delete powerup
        powups.remove(pu);
        //Activate powerup
        if (pu.type == 'H') {
          s1.health += 50;
        } else if (pu.type == 'T') {
          s1.turretCount += 1;
          if (s1.turretCount > 5) {
            s1.turretCount = 5;
          }
        } else if (pu.type == 'A') {
          s1.laserCount = s1.laserCount + 100;
        }
      }
      if (pu.reachedBottom()) {
        powups.remove(pu);
        i--;
      }
    }



    if (rockTimer.isFinished()) {
      rocks.add(new Rock());
      rockTimer.start();
    }

    for (int i = 0; i < stars.size(); i++) {
      Star star = stars.get(i);
      star.display();
      star.move();
      if (star.reachedBottom()) {
        stars.remove(star);
        i--;
      }
    }

    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);
      //collision detection between rock and ship
      if (s1.intersect(rock)) {
        rocks.remove(rock);
        score = score + rock.w;
        s1.health -= 15;
      }
      rock.display();
      rock.move();
      if (rock.reachedBottom()) {
        rocks.remove(rock);
        i--;
        rocksPassed++;
      }
    }

    for (int i = 0; i < lasers.size(); i++) {
      Laser laser = lasers.get(i);
      for (int j = 0; j < rocks.size(); j++) {
        Rock rock = rocks.get(j);
        if (laser.intersect(rock)) {
          //Reduce rock hp
          rock.diam = rock.diam - 10;
          if (rock.diam < 1) {
            rocks.remove(rock);
          }
          //Remove laser
          lasers.remove(laser);
          //Do something
          score = score + 10;
          //Provide animated gif and explosion sound
        }
      }
      laser.display();
      laser.move();
      if (laser.reachedTop()) {
        lasers.remove(laser);
        i--;
      }
    }
  s1.display();
  s1.move(mouseX, mouseY);
  infoPanel();
  if (s1.health < 1) {
    gameOver();
  }
  
    if (levelTimer.isFinished()) {
      level += 1;
      rtime -= 200;
      levelTimer.start();
    }
  }
}


void mousePressed() {
  s1.laserCount--;
  if (s1.turretCount == 1) {
    lasers.add(new Laser(s1.x, s1.y));
  } else if (s1.turretCount == 2) {
    lasers.add(new Laser(s1.x-10, s1.y));
    lasers.add(new Laser(s1.x+10, s1.y));
  } else if (s1.turretCount == 3) {
    lasers.add(new Laser(s1.x-10, s1.y));
    lasers.add(new Laser(s1.x, s1.y));
    lasers.add(new Laser(s1.x+10, s1.y));
  } else if (s1.turretCount == 4) {
    lasers.add(new Laser(s1.x-10, s1.y));
    lasers.add(new Laser(s1.x-5, s1.y));
    lasers.add(new Laser(s1.x+5, s1.y));
    lasers.add(new Laser(s1.x+10, s1.y));
  } else if (s1.turretCount == 5) {
    lasers.add(new Laser(s1.x-10, s1.y));
    lasers.add(new Laser(s1.x-5, s1.y));
    lasers.add(new Laser(s1.x, s1.y));
    lasers.add(new Laser(s1.x+5, s1.y));
    lasers.add(new Laser(s1.x+10, s1.y));
  } else {
    lasers.add(new Laser(s1.x-10, s1.y));
    lasers.add(new Laser(s1.x-5, s1.y));
    lasers.add(new Laser(s1.x, s1.y));
    lasers.add(new Laser(s1.x+5, s1.y));
    lasers.add(new Laser(s1.x+10, s1.y));
  }
}
void infoPanel() {
  rectMode(CENTER);
  fill(127, 127);
  rect(width/2, height-25, width, 50);
  fill(220);
  textSize(25);
  text("Score:" + score, 50, 40);
  text("Health: " + s1.health, 350, height-20);
  text("Ammo: " + s1.laserCount, 200, height-20);
  text("Passed Rocks:" + rocksPassed, width - 180, 40);
  text("Turrets:" + s1.turretCount, width - 320, 40);
  fill(255);
  rect(s1.x, s1.y+30, s1.health, 6);
  text("Level:"+ level, 50, height-20);
}

void startScreen() {
  background(0);
  fill(255);
  text("Click anywhere to start! Space Game by Joey Zheng", width/2-100, height/2);
  if (mousePressed) {
    play = true;
  }
}

void gameOver() {
  background(0);
  fill(255);
  text("Game Over!", width/2, height/2);
  noLoop();
}
