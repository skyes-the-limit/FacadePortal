abstract class ADrop {
  PVector acc;
  PVector vel;
  PVector pos;

  void update() {
    this.pos = this.pos.add(this.vel);
    this.vel = this.vel.add(this.acc);
  }
}
