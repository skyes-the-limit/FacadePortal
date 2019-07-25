// to represent a storm
class Thunderstorm implements WeatherCondition { 
  final APrecipitation precipitation;
  boolean flash = false;
  boolean isDec = false;
  boolean stutter = true;
  int count = 0;
  int add = 3;
  int max = 80;

  Thunderstorm(APrecipitation precipitation) {
    this.precipitation = precipitation;
  }

  void draw() {
    this.precipitation.draw();
    if (frameCount % 25 == 0) {
      flash = true;
    }
    if (flash) {
      drawFlash();
    }
  }

  void drawFlash() {
    fill(255, map(count, 0, 30, 0, 100));
    rect(0, 0, width, height);
    if (count > max) {
      isDec = true;
    } else if (count < 25 && isDec && stutter) {
      isDec = false;
      stutter = false;
      max = 120;
    } else if (count < 0) {
      flash = false;
      isDec = false;
      add = 3;
      max = 60;
      stutter = true;
    }
    if (isDec) {
      count -= add;
      add -= 5;
    } else {
      count += add;
      add+=5;
    }
  }
}
