import java.util.Random;
int pixelSize = 1;

abstract class Atmosphere implements WeatherCondition {
  float severity;
  color c;
  boolean particles;
  boolean bad;
  boolean cover;

  Atmosphere(float severity, color c, boolean particles, boolean bad, boolean cover) {
    this.severity = severity;
    this.c = c;
    this.particles = particles;
    this.bad = bad;
    this.cover = cover;
  }
  
  void draw() {
    if (bad) {
      background(#CCD8DE);
    } else {
      background(#A7C7D8);
    }
    if(particles) {
       for (int h = 0; h < height; h += pixelSize) {
         for (int w = 0; w < width; w += pixelSize) {
           int alpha;
           if (cover) {
             alpha = (int) (255 * (0.35 + severity * new Random().nextInt(3) * 0.15));
           } else {
             alpha = (int) (255 * (0.2 + severity * new Random().nextInt(3) * 0.3));
           }
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
    super(0.5, #FFFFFF, false, false, true);
  }
}

class Fog extends Atmosphere {
  Fog() {
    super(1, #FFFFFF, false, false, false);
  }
}

class Smoke extends Atmosphere {
  Smoke() {
    super(1, #857A71, true, true, true);
  }
}

class Haze extends Atmosphere {
  Haze() {
    super(0.7, #B5821B, true, true, true);
  }
}

class Dust extends Atmosphere {
  Dust() {
    super(0.4, #AEA799, true, false, false);
  }
}

class Ash extends Atmosphere {
  Ash() {
    super(0.7, #979797, true, true, false);
  }
}

class Sand extends Atmosphere {
  Sand() {
    super(1, #E0B040, true, true, false);
  }
}
