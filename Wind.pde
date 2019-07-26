final float MIN_X_POS = width * -0.1;
final float MAX_X_POS = width * 0.45;
final float MIN_Y_POS = -0.1;
final float MAX_Y_POS = height * 0.3;

abstract class AWind implements WeatherCondition {
  int lifespan;        // how many ticks a single windstroke lives for
  int frequency;       // how often a new windstroke is spawned
  int strokeSize;      // how large a single windstroke is drawn
  int speed;           // how many ticks until a windstroke is moved
  color strokeColor;   // the color to draw a windstroke

  private ArrayList<WindStroke> strokes = new ArrayList();  

  AWind(int intensity, color strokeColor) {
    this.lifespan = round(intensity * 1.5);
    this.frequency = 8 - intensity; 
    this.strokeSize = intensity;
    this.speed = 20 - (intensity * 4);
    this.strokeColor = strokeColor;
  }

  void draw() {
    if (frameCount % this.frequency == 0) {
      float x = map((float) Math.random(), 0, 1, MIN_X_POS, MAX_X_POS);
      float y = map((float) Math.random(), 0, 1, MIN_Y_POS, MAX_Y_POS); 
      this.strokes.add(new WindStroke(x, y, 1, 1));
    }

    fill(this.strokeColor);  
    for (int i = 0; i < this.strokes.size(); i++) {
      WindStroke stroke = this.strokes.get(i);
      float x = stroke.location.x;
      float y = stroke.location.y;
      if (stroke.age > lifespan) {
        strokes.remove(stroke);
        i--;
      } else {
        if (frameCount % speed == 0) {
          stroke.progress();
        }
        noStroke();
        fill(this.strokeColor);
        for (int j = 0; j < this.strokeSize; j++) {
          if (j % 2 == 0) {
            rect(x + j, y, 1, 1);  
          } else {
            rect(x + j, y - 1, 1, 1);
          }
        }
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
    super(ceil(windSpeed / 4.0) * 2, color(255, 255, 255, 200));
  }
}

class Squall extends AWind {
  Squall() {
    super(6, color(150, 150, 150, 220));
  }

  void draw() {
  }
}

class Tornado extends AWind {
  Tornado() {
    super(12, color(99, 99, 99, 240));
  }
}
