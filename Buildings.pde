// to represent a cityscape
class Buildings {
  final static int highDens = 10;
  final static int maxWidth = 50;
  int density;
  int maxHeight;
  ArrayList<float[]> bounds;

  Buildings(int dens, int max) {
    this.density = dens; // space between buildings gen from density-10 to density
    this.maxHeight = max; // height of buildings anywhere from 6 to max.
    this.bounds = new ArrayList<float[]>();
    this.genBuildings();
  }
  
  

  void genBuildings() {
    float currentX = 0;
    while (currentX < width * 0.6) {
      float bWidth = random(20, maxWidth);
      float bHeight = random(maxHeight * 0.4, maxHeight);
      float[] bound = new float[] { currentX, bHeight, bWidth };
      bounds.add(bound);
      currentX += bWidth;
      float space = max(0, random(map(density, 0, 70, -15, -3), density));
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
