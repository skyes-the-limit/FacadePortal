abstract class AirQuality implements WeatherCondition {
  float severity;
  color c;
  boolean particles;

  AirQuality(float severity, color c, boolean particles) {
    this.severity = severity;
    this.c = c;
    this.particles = particles;
  }
  
  void draw() {
    
  }
}

class Mist extends AirQuality {
  Mist() {
    super();
  }
}

class Fog extends AirQuality {
  Fog() {
    super();
  }
}

class Smoke extends AirQuality {
  Smoke() {
    super();
  }
}

class Haze extends AirQuality {
  Haze() {
    super();
  }
}

class Dust extends AirQuality {
  Dust() {
    super();
  }
}

class Ash extends AirQuality {
  Ash() {
    super();
  }
}

class Sand extends AirQuality {
  Sand() {
    super();
  }
}
