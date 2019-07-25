
interface WeatherCondition {
  void draw();
}

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
    super(0.5, #FFFFFF, false);
  }
}

class Fog extends AirQuality {
  Fog() {
    super(1, #FFFFFF, false);
  }
}

class Smoke extends AirQuality {
  Smoke() {
    super(1, #, false);
  }
}

class Haze extends AirQuality {
  Haze() {
    super(0.7, #, false);
  }
}

class Dust extends AirQuality {
  Dust() {
    super(0.7, # );
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
