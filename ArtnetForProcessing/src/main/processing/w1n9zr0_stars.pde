import org.capybara.artnetforprocessing.*;
import artnet4j.events.*;
import artnet4j.packets.*;
import artnet4j.*;

int STAGE_W = 36;
int STAGE_H = 70;

float DIAGONAL = sqrt(STAGE_W * STAGE_W + STAGE_H * STAGE_H);

int STARS = 100;

void artnetSetup() {
  ArtnetForProcessing afp = new ArtnetForProcessing(this);
  afp.setBroadcastAddress("2.0.0.255");

  Universe u0 = new Universe(0,0);
  u0.addPixelRange(new VertPixelRange(31,69,-70,0));
  u0.addPixelRange(new VertPixelRange(32,0, (101-70), (70*3+1)));
  u0.addPixelRange(new VertPixelRange(32,39, (116-102), (102*3+1)));
  u0.addPixelRange(new VertPixelRange(33,52, (117-162), (117*3+1)));
  afp.addUniverse(u0);

  Universe u1 = new Universe(0,1);
  u1.addPixelRange(new VertPixelRange(28,50,-51,0));
  u1.addPixelRange(new VertPixelRange(29,0, (115-59), (59*3+1)));
  u1.addPixelRange(new VertPixelRange(30,56, (117-141), (117*3+1)));
  u1.addPixelRange(new VertPixelRange(30,25, (142-159), (142*3+1)));
  afp.addUniverse(u1);

  Universe u2 = new Universe(0,2);
  u2.addPixelRange(new VertPixelRange(25,57,-58,0));
  u2.addPixelRange(new VertPixelRange(26,0, (120-66), (66*3+1)));
  u2.addPixelRange(new VertPixelRange(27,54, (122-143), (122*3+1)));
  u2.addPixelRange(new VertPixelRange(27,25, (144-159), (144*3+1)));
  afp.addUniverse(u2);

  Universe u4 = new Universe(0,4);
  u4.addPixelRange(new VertPixelRange(19,69,-70,0));
  u4.addPixelRange(new VertPixelRange(20,0,(93-70),(70*3+1)));
  u4.addPixelRange(new VertPixelRange(20,31,(109-94),(94*3+1)));
  u4.addPixelRange(new VertPixelRange(21, 45, (110-125), (110*3+1)));
  u4.addPixelRange(new VertPixelRange(21, 22, (126-149), (126*3+1)));
  afp.addUniverse(u4);

  Universe u5 = new Universe(0,5);
  u5.addPixelRange(new VertPixelRange(16, 61, -62, 0));
  u5.addPixelRange(new VertPixelRange(17, 0, (123-70), (70*3+1)));
  u5.addPixelRange(new VertPixelRange(18, 52, (124-143), (124*3+1)));
  u5.addPixelRange(new VertPixelRange(18, 25, (144-159), (144*3+1)));
  afp.addUniverse(u5);

  Universe u6 = new Universe(0,6);
  u6.addPixelRange(new VertPixelRange(13, 47, -48, 0));
  u6.addPixelRange(new VertPixelRange(14, 0, (106-48),  (48*3+1)));
  u6.addPixelRange(new VertPixelRange(15, 49, (116-159),  (116*3+1)));
  afp.addUniverse(u6);

  Universe u7 = new Universe(0,7);
  u7.addPixelRange(new VertPixelRange(10, 69, -70, 0));
  u7.addPixelRange(new VertPixelRange(11, 0, (101-70),  (70*3+1)));
  u7.addPixelRange(new VertPixelRange(11, 39, (115-102),  (102*3+1)));
  u7.addPixelRange(new VertPixelRange(12, 52, (118-159),  (118*3+1)));
  afp.addUniverse(u7);

  Universe u8 = new Universe(0,8);
  u8.addPixelRange(new VertPixelRange(9, 47, -48, 0));
  u8.addPixelRange(new VertPixelRange(8, 0, (108-48),  (48*3+1)));
  u8.addPixelRange(new VertPixelRange(7, 43, -43,  (116*3+1)));
  afp.addUniverse(u8);

  Universe u9 = new Universe(0,9);
  u9.addPixelRange(new VertPixelRange(6, 0, (139-70), (70*3+1)));
  u9.addPixelRange(new VertPixelRange(5, 69, -70, 0));
  afp.addUniverse(u9);

  Universe u10 = new Universe(0,10);
  u10.addPixelRange(new VertPixelRange(2, 69, -70, 0));
  u10.addPixelRange(new VertPixelRange(3, 0, (93-70), (70*3+1)));
  u10.addPixelRange(new VertPixelRange(3, 31, (109-94), (94*3+1)));
  u10.addPixelRange(new VertPixelRange(4, 23, (126-149), (126*3+1)));
  u10.addPixelRange(new VertPixelRange(4, 46, (110-125), (110*3+1)));
  afp.addUniverse(u10);

  afp.start();
}

void setup() {
  size(STAGE_W, STAGE_H);
  artnetSetup();

  frameRate(30);
  noStroke();
  clear();

  for (int i = 0; i < stars.length; i++) {
    Star s = new Star();
    stars[i] = s;
  }
}

int lastFrame = millis();

void draw() {
  int currentFrame = millis();
  int frameTime = currentFrame - lastFrame;
  lastFrame = currentFrame;

  fill(0, frameTime);
  rect(0, 0, width, height);

  for (int i = 0; i < stars.length; i++) {
    Star s = stars[i];
    if (s.update(frameTime))
      s.draw();
    else
      stars[i] = new Star();
  }

  spin = sin(millis() / 5000) * .1;

  if (random(frameTime * 3) < 1)
    hue = random(360);
  else
    hue += random(-10, 11);
}

float spin;
float hue = random(360);

Star[] stars = new Star[STARS];

public class Star {
  public color col = HSL2RGB(
    (hue + random(60)) % 360,
    random(.5, 1),
    random(.5, .8));
  public float size = random(1);
  public float angle = random(TWO_PI);
  public float distance = random(1);
  public float speed = -random(0.01, .1);
  public float aspeed = random(-.05, 0.05) + spin;

  private float x, y, drawSize;

  void draw() {
    fill(col);
    ellipse(
      x - drawSize/2,
      y - drawSize/2,
      drawSize,
      drawSize);
  }

  boolean update(int time) {
    float timeFactor = time / 50.0;
    distance += (speed * timeFactor) / (pow(distance, 1) * 10);
    if (distance < 0 || distance > 1)
      return false;

    angle += (aspeed * timeFactor) / (pow(distance, 1.5) * 10);

    x = cos(angle) * distance * DIAGONAL + width / 2;
    y = sin(angle) * distance * DIAGONAL + height / 2;

    drawSize = size * pow(distance, .5) * 5 + 3;

    return true;
  }
}


// http://www.openprocessing.org/sketch/39065
// Given H,S,L in range of 0-360, 0-1, 0-1  Returns a Color
color HSL2RGB(float hue, float sat, float lum)
{
  float v;
  float red, green, blue;
  float m;
  float sv;
  int sextant;
  float fract, vsf, mid1, mid2;

  red = lum;   // default to gray
  green = lum;
  blue = lum;
  v = (lum <= 0.5) ? (lum * (1.0 + sat)) : (lum + sat - lum * sat);
  m = lum + lum - v;
  sv = (v - m) / v;
  hue /= 60.0;  //get into range 0..6
  sextant = floor(hue);  // int32 rounds up or down.
  fract = hue - sextant;
  vsf = v * sv * fract;
  mid1 = m + vsf;
  mid2 = v - vsf;

  if (v > 0)
  {
    switch (sextant)
    {
    case 0:
      red = v;
      green = mid1;
      blue = m;
      break;
    case 1:
      red = mid2;
      green = v;
      blue = m;
      break;
    case 2:
      red = m;
      green = v;
      blue = mid1;
      break;
    case 3:
      red = m;
      green = mid2;
      blue = v;
      break;
    case 4:
      red = mid1;
      green = m;
      blue = v;
      break;
    case 5:
      red = v;
      green = m;
      blue = mid2;
      break;
    }
  }
  return color(red * 255, green * 255, blue * 255);
}
