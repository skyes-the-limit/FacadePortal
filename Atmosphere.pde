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
    if(particles) {
      loadPixels();
       for (int h = 0; h < height; h++) {
         for (int w = 0; w < width; w++) {
           float alpha = severity * noise(w, h);
           pixels[(h * height) + w] = color(c, alpha);
         }
       }
       updatePixels();
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
    super(0.7, #C69F4F, true);
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
