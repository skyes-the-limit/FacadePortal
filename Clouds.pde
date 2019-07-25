class Clouds {
  ArrayList<Cloud> clouds;
  int density;
  int tick;

  Clouds(int dens) {
    clouds = new ArrayList<Cloud>();
    density = dens;
    genClouds(true);
    tick = 0;
  }

  void genClouds(boolean start) {
    int genNum;
    if (start) {
      genNum = density;
    } else {
      if (tick % 35 == 0) {
        genNum = round(density * 0.5);
      } else {
        genNum = 0;
      }
    }
    for (int i = 0; i < genNum; i++) {
      this.clouds.add(new Cloud(new PVector(random(1, 5), 0), new PVector(random(width - 400) - 200, random(height - 200))));
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

  void draw(color c) {
    this.genClouds(false);
    for (Cloud cloud : clouds) {
      cloud.drawCloud(c);
      cloud.update();
    }
    this.remClouds();
    tick++;
  }
}

class Cloud {
  PVector vel;
  PVector pos;
  int size = 10;

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
  void drawCloud(color c) {
    noStroke();
    fill(c); //color(#DFDFDF, 100)
    ellipse(this.pos.x / aec.getScaleX(), this.pos.y / aec.getScaleY(), size, size);
  }
}
