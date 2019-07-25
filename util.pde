import java.util.Date;
import java.text.Format;
import java.text.SimpleDateFormat;

int Y_AXIS = 1;
int X_AXIS = 2;

void setGradient(int x, int y, float w, float h, int axis, color ... colors) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int j = 0; j + 1 < colors.length; j++) {
      for (float i = y + (j*h)/2; i <= y + (j+1)*h/2; i++) {
        float inter = map(i, y + (j*h)/2, y + (j+1)*h/2, 0, 1);
        color c = lerpColor(colors[j], colors[j+1], inter);
        stroke(c);
        line(x, i, x+w, i);
      }
    }
  } else if (axis == X_AXIS) {  // Left to right gradient
    for (int j = 0; j + 1 < colors.length; j++) {
      for (float i = x + (j*w/2); i <= x+(j+1)*w/2; i++) {
        float inter = map(i, x + (j*w/2), x+(j+1)*w/2, 0, 1);
        color c = lerpColor(colors[j], colors[j+1], inter);
        stroke(c);
        line(i, y, i, y+h);
      }
    }
  }
}

String convertTime(long time) {
  Date date = new Date(time);
  Format format = new SimpleDateFormat("HH:mm");
  return format.format(date);
}

String convertTemp(double temp) {
  return (int) (temp - 273.15) + "°C";
}
