// to represent a cityscape
class Buildings {
  static final int MAX_WIDTH = 45;

  static final int HIGH_DENS = 10;
  static final int MED_DENS = 25;
  static final int LOW_DENS = 40;

  static final int HIGH_HEIGHT = 125;
  static final int MED_HEIGHT = 90;
  static final int LOW_HEIGHT = 70;

  int density;
  int maxHeight;
  ArrayList<float[]> bounds;

  Buildings(int dens, int max) {
    this.density = dens; // space between buildings gen from density-10 to density
    this.maxHeight = max; // height of buildings anywhere from 6 to max.
    this.bounds = new ArrayList<float[]>();
    this.genBuildings();
  }

  Buildings(int[] specs) {
    this.density = specs[0]; // space between buildings gen from density-10 to density
    this.maxHeight = specs[1]; // height of buildings anywhere from 6 to max.
    this.bounds = new ArrayList<float[]>();
    this.genBuildings();
  }

  void genBuildings() {
    float currentX = 0;
    while (currentX < width * 0.53) {
      float bWidth = random(15, MAX_WIDTH);
      float bHeight = random(maxHeight * 0.4, maxHeight);
      float[] bound = new float[] { currentX, bHeight, bWidth };
      bounds.add(bound);
      currentX += bWidth;
      float space = max(0, (int)random((int)map(density, 10, 40, -6, -2), density));
      currentX += space;
    }
  }

  void draw() {
    noStroke();
    fill(20, 200);
    for ( float[] bound : bounds) {
      rect(bound[0] / aec.getScaleX(), height / 14 - bound[1] / aec.getScaleY(), bound[2] / aec.getScaleX(), bound[1] / aec.getScaleY());
    }
  }
}
