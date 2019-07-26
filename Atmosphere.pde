import java.util.Random;
int pixelSize = 1;
int numShapes = 10;
Random rand = new Random();
PShape s;

abstract class Atmosphere implements WeatherCondition {
  float severity;
  color c;
  boolean bad;
  boolean cover;

  Atmosphere(float severity, color c, boolean cover) {
    this.severity = severity;
    this.c = c;
    this.cover = cover;
  }

  void draw() {
    for (int h = 0; h < height; h += pixelSize) {
      for (int w = 0; w < width; w += pixelSize) {
        int alpha;
        if (cover) {
          alpha = (int) (255 * (0.2 + severity * new Random().nextInt(3) * 0.15));
        } else {
          alpha = (int) (255 * (0.1 + severity * new Random().nextInt(3) * 0.3));
        }
        fill(c, alpha);
        noStroke();
        rect(w, h, pixelSize, pixelSize);
      }
    }
  }
}

class Mist extends Atmosphere {
  Mist() {
    super(0.2, #FFFFFF, true);
  }

  @Override
    void draw() {
    background(#A7C7D8);
    for (int h = 0; h < height; h += pixelSize) {
      for (int w = 0; w < width; w += pixelSize) {
        int alpha;
        alpha = (int) (255 * new Random().nextInt(11) * 0.02);
        fill(c, alpha);
        noStroke();
        rect(w, h, pixelSize, pixelSize);
      }
    }
  }
}

class Fog extends Atmosphere {
  Fog() {
    super(0.7, #FFFFFF, false);
  }
}

class Smoke extends Atmosphere {
  Smoke() {
    super(1, #857A71, true);
  }
}

class Haze extends Atmosphere {
  Haze() {
    super(0.2, #B5821B, true);
  }
}

class Dust extends Atmosphere {
  Dust() {
    super(0.4, #AEA799, false);
  }
}

class Ash extends Atmosphere {
  Ash() {
    super(0.7, #979797, false);
  }
}

class Sand extends Atmosphere {
  Sand() {
    super(1, #E0B040, false);
  }
}
