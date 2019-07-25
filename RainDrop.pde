class Rain implements Drop {
  PVector acc;
  PVector vel;
  PVector pos;
  color col;

  Rain() {
    colorMode(HSB, 360, 100, 100);
    this.pos = new PVector(random(width), 0);
    this.vel = new PVector(0, random(1, 5));
    this.acc = new PVector(0, random(1, 7));
    this.col = color(random(168, 200), 100, 100);
  }
  
  void update() {
    this.pos = this.pos.add(this.vel);
    this.vel = this.vel.add(this.acc);
  }
  
  void drawDrop() {
    ellipse(this.pos.x / aec.getScaleX(), this.pos.y / aec.getScaleY(), 1, 1);
  }
}
