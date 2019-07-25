import java.util.Random;
int pixelSize = 1;

abstract class Atmosphere implements WeatherCondition {
  float severity;
  color c;
  boolean particles;

  Atmosphere(float severity, color c, boolean particles) {
    this.severity = severity;
    this.c = c;
    this.particles = particles;
  }
  
  void draw() {
    background(#A7C7D8);
    if(particles) {
       for (int h = 0; h < height; h += pixelSize) {
         for (int w = 0; w < width; w += pixelSize) {
           int alpha = (int) (255 * (0.2 + severity * new Random().nextInt(3) * 0.2));
           fill(c, alpha);
           noStroke();
           rect(w,h,pixelSize,pixelSize);
         }
       }
    } else {
      
    }
  }
}

class Mist extends Atmosphere {
  Mist() {
    super(0.5, #FFFFFF, false);
  }
}

class Fog extends Atmosphere {
  Fog() {
    super(1, #FFFFFF, false);
  }
}

class Smoke extends Atmosphere {
  Smoke() {
    super(1, #979797, false);
  }
}

class Haze extends Atmosphere {
  Haze() {
    super(0.7, #B5821B, true);
  }
}

class Dust extends Atmosphere {
  Dust() {
    super(0.4, #BEB7A9, true);
  }
}

class Ash extends Atmosphere {
  Ash() {
    super(0.7, #979797, true);
  }
}

class Sand extends Atmosphere {
  Sand() {
    super(0.7, #F4CB5F, true);
  }
}
