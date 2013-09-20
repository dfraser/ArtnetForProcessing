import org.capybara.artnetforprocessing.*;
import artnet4j.events.*;
import artnet4j.packets.*;
import artnet4j.*;


float a = 0.0;
float inc = TWO_PI/100.0;

void setup() {
  
  ArtnetForProcessing afp = new ArtnetForProcessing(this);
  afp.setBroadcastAddress("10.0.1.255");

  Universe u = new Universe(0,0);
  u.addPixelRange(new HorizPixelRange(0,0,20,1));
  u.addPixelRange(new VertPixelRange(0,0,30,97));
  afp.addUniverse(u);

  afp.start();
  
  size(200,200);
  frameRate(20);
}

void draw() {
  a = a + inc; 
  noStroke();
  for (int i=0; i < height; i++) {
    float phase = PI * i / height;
    fill(128+sin(a+phase)*128.0,128+sin(a+phase*0.3)*128.0,128+sin(a+phase*0.6)*128.0);
    rect(0,i,250,1);
  }
}