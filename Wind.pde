abstract class AWind implements WeatherCondition {
  int severity;
  int frequency;
  
  AWind(int severity, int frequency) {
    this.severity = severity;
    this.frequency = frequency;
  }
}

class Wind extends AWind {
  Wind(int windSpeed) {
    super(windSpeed, 10);
  }
  
  void draw() {
    
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
