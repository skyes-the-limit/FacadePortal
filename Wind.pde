final float MIN_X_POS = width * -0.1;
final float MAX_X_POS = width * 0.4;
final float MIN_Y_POS = 0;
final float MAX_Y_POS = height * 0.3;

abstract class AWind implements WeatherCondition {
  int lifespan;
  int frequency;
  int strokeLength;
  int speed;
  color strokeColor;

  private ArrayList<WindStroke> strokes = new ArrayList();  

  AWind(int lifespan, int frequency, int strokeLength, int speed, color strokeColor) {
    this.lifespan = lifespan;
    this.frequency = frequency;
    this.strokeLength = strokeLength;
    this.speed = speed;
    this.strokeColor = strokeColor;
  }

  void draw() {
    if (frameCount % this.frequency == 0) {
      float x = map((float) Math.random(), 0, 1, MIN_X_POS, MAX_X_POS);
      float y = map((float) Math.random(), 0, 1, MIN_Y_POS, MAX_Y_POS); 
      float dx = speed;
      float dy = 1;
      this.strokes.add(new WindStroke(x, y, dx, dy));
    }

    for (int i = 0; i < this.strokes.size(); i++) {
      WindStroke stroke = this.strokes.get(i);
      //println(stroke.toString());
      if (stroke.age > lifespan) {
        strokes.remove(stroke);
        i--;
      } else {
        if (frameCount % 2 == 0) {
          stroke.progress();
        }
        noStroke();
        fill(this.strokeColor);
        rect(stroke.location.x, stroke.location.y, strokeLength, 1);
      }
    }
  }
}

class WindStroke {
  int age = 0;
  PVector location;
  PVector velocity;

  WindStroke(float x, float y, float dx, float dy) {
    this.location = new PVector(round(x), round(y));
    this.velocity = new PVector(round(dx), round(dy));
  }

  void progress() {
    this.location.add(this.velocity);
    this.velocity.y = this.velocity.y * -1;
    this.age++;
  }
}

class Wind extends AWind {
  Wind(int windSpeed) {
    super(8, 3, floor(windSpeed / 2), 1, color(255, 255, 255, 120));
  }
}

class Squall extends AWind {
  Squall() {
    super(30, 15, 2, 3, color(150, 150, 150, 160));
  }

  void draw() {
  }
}

class Tornado extends AWind {
  Tornado() {
    super(50, 1, 15, 3, color(99, 99, 99, 200));
  }
}
