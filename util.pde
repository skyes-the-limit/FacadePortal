int Y_AXIS = 1;
int X_AXIS = 2;

void setGradient(int x, int y, float w, float h, int axis, color ... colors) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int j = 0; j + 1 < colors.length; j++) {
      for (int i = y + (int)(j*h/2); i <= y + (j+1)*h/2; i++) {
        float inter = map(i, y, (y+h)/2, 0, 1);
        color c = lerpColor(colors[j], colors[j+1], inter);
        stroke(c);
        line(x, i, x+w, i);
      }
    }
  } else if (axis == X_AXIS) {  // Left to right gradient
    for (int j = 0; j + 1 < colors.length; j++) {
      for (int i = x + (int)(j*w/2); i <= (j+1)*w/2; i++) {
        float inter = map(i, x, x+w, 0, 1);
        color c = lerpColor(colors[j], colors[j+1], inter);
        stroke(c);
        line(i, x, i, x+w);
      }
    }
  }
}
