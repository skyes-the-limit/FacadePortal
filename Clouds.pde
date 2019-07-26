class Clouds implements WeatherCondition {
  ArrayList<Cloud> clouds;
  int density;
  int tick;

  Clouds(int dens) {
    clouds = new ArrayList<Cloud>();
    density = dens;
    if (density > 20) {
     density = 20; 
    }
    genClouds(true);
    tick = 0;
  }

  void genClouds(boolean start) {
    int genNum;
    int genRange;
    if (start) {
      genNum = density;
      genRange = width - 400;
    } else if (tick % 50 == 0) {
      genNum = round(density * 0.1);
      genRange = 100;
    } else {
      genNum = 0;
      genRange = 0;
    }
    for (int i = 0; i < genNum; i++) {
      this.clouds.add(new Cloud(new PVector(random(1, 2), 0), new PVector(random(genRange) - 200, random(height - 360))));
    }
  }

  void remClouds() {
    ArrayList<Cloud> toRemove = new ArrayList<Cloud>();
    for (Cloud c : clouds) {
      if (c.offCanvas()) {
        toRemove.add(c);
      }
    }
    this.clouds.removeAll(toRemove);
  }

  void draw() {
    this.genClouds(false);
    for (Cloud cloud : clouds) {
      cloud.drawCloud();
      cloud.update();
    }
    this.remClouds();
    tick++;
  }
}

class Cloud {
  PVector vel;
  PVector pos;
  int size = 6;

  Cloud(PVector vel, PVector pos) {
    this.vel = vel;
    this.pos = pos;
  }

  boolean offCanvas() {
    return pos.x > width + 10 || pos.y > height + 10;// || pos.x < -10 || pos.y < -10;
  }

  void update() {
    this.pos = this.pos.add(this.vel);
  }

  // draws this drop
  void drawCloud() {
    noStroke();
    fill(#FFFFFF, 190); //color(#DFDFDF, 100)
    ellipse(this.pos.x / aec.getScaleX(), this.pos.y / aec.getScaleY(), size, size);
  }
}
