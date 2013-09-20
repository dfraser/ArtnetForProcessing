import org.capybara.artnetforprocessing.*;
import artnet4j.events.*;
import artnet4j.packets.*;
import artnet4j.*;

int lines = 20;

int linePos[] = new int[lines];

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
 
  // set up the lines
  for (int i = 0; i < lines; i++) {
    linePos[i] = (int) random(width);
  }
 
  
}

void draw() {
  a = a + inc; 
  noStroke();
  
  // plot the lines
  fill(255);
  for (int i = 0; i < lines; i++) {
      // erase the old line
      fill(0);
      rect(linePos[i]-1,0,3,height);
      
      if ((i%2) == 0) {
        // move the line left
        linePos[i] = linePos[i] + 1;
        if (linePos[i] > width) {
          linePos[i] = 0;
        }
      } else {
        linePos[i] = linePos[i] - 1;
        if (linePos[i] < 0) {
          linePos[i] = width;
        }
      }
      
      // draw the new line
      fill(0,255/lines*i,0);
      rect(linePos[i]-1,0,3,height);
  }
}