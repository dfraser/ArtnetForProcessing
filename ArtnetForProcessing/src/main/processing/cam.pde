import processing.video.*;

import org.capybara.artnetforprocessing.*;
import artnet4j.events.*;
import artnet4j.packets.*;
import artnet4j.*;


Capture cam;

void setup() {

  ArtnetForProcessing afp = new ArtnetForProcessing(this);
  afp.setBroadcastAddress("192.168.113.255");
  Universe u = new Universe(0,4);
  Universe u2 = new Universe(0,7);

  u.addPixelRange(new VertPixelRange(0,0,100,1));
  u2.addPixelRange(new VertPixelRange(5,0,100,1));

  afp.addUniverse(u);
  afp.addUniverse(u2);
  size(100,100);

  afp.start();
  
  noSmooth();
  size(width, height);
  frameRate(20);
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  cam.start();    
  
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0,width ,height);
}