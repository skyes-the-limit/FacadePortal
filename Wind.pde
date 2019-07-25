static final int WIND_AGE_LIMIT = 8;
final float MIN_X_POS = width * -0.1;
final float MAX_X_POS = width * 0.4;
final float MIN_Y_POS = 0;
final float MAX_Y_POS = height * 0.15;

abstract class AWind implements WeatherCondition {
  double severity;  // a double 0-1 of how severe the condition is
  int frequency;    // How many ticks until a new WindStroke is drawn

  AWind(double severity, int frequency) {
    this.severity = severity;
    this.frequency = frequency;
  }
}

class WindStroke {
  int age = 0;
  PVector location1;
  PVector location2;
  PVector velocity;

  WindStroke(float x, float y, float dx, float dy) {
    this.location1 = new PVector(round(x), round(y));
    this.location2 = new PVector(round(x) + 1, round(y));
    this.velocity = new PVector(round(dx), round(dy));
  }

  void progress() {
    this.location1.add(this.velocity);
    this.location2.add(this.velocity);
    this.velocity.y = this.velocity.y * -1;
    this.age++;
  }
}

class Wind extends AWind {
  private ArrayList<WindStroke> strokes = new ArrayList();

  Wind(int windSpeed) {
    super(windSpeed, 3);
  }

  void draw() {
    if (frameCount % this.frequency == 0) {
      float x = map((float) Math.random(), 0, 1, MIN_X_POS, MAX_X_POS);
      float y = map((float) Math.random(), 0, 1, MIN_Y_POS, MAX_Y_POS); 
      float dx = 1;
      float dy = 1;
      this.strokes.add(new WindStroke(x, y, dx, dy));
    }

    for (int i = 0; i < this.strokes.size(); i++) {
      WindStroke stroke = this.strokes.get(i);
      //println(stroke.toString());
      if (stroke.age > WIND_AGE_LIMIT) {
        strokes.remove(stroke);
        i--;
      } else {
        if (frameCount % 2 == 0) {
          stroke.progress();
        }
        noStroke();
        fill(#FFFFFF, 160);
        rect(stroke.location1.x, stroke.location1.y, 1, 1);
        rect(stroke.location2.x, stroke.location2.y, 1, 1);
      }
    }
  }
}

class Squall extends AWind {
  Squall() {
    super(50, 10);
  }

  void draw() {
  }
}

class Tornado extends AWind {
  Tornado() {
    super(100, 100);
  }

  void draw() {
  }
}
