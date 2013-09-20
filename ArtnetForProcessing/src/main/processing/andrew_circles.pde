import org.capybara.artnetforprocessing.*;
import artnet4j.events.*;
import artnet4j.packets.*;
import artnet4j.*;

// constants
int STAGE_W = 100;
int STAGE_H = 100;
int NUM_POINTS = 4;
int RINGS = 10;
int RING_SPACING = 10;
int ROTATE_SIZE = 10;
double sine[];
double cos[];

// states
int pointPos[][];
int pointPhase[];
int rotatePhase[];
int colorOffset[];

// setup
void setup() {
/*
  ArtnetForProcessing afp = new ArtnetForProcessing(this);
  afp.setBroadcastAddress("192.168.113.255");
  Universe u = new Universe(0,4);
  Universe u2 = new Universe(0,7);

  u.addPixelRange(new VertPixelRange(40,0,100,1));
  u2.addPixelRange(new VertPixelRange(45,0,100,1));

  afp.addUniverse(u);
  afp.addUniverse(u2);
  size(STAGE_W, STAGE_H);
  afp.start();
*/  
//  noSmooth();
  size(width, height);
  frameRate(20);
 
  // make a sine table
  sine = new double[256];
  cos = new double[256];
  for(int i = 0; i < sine.length; i ++) {
     sine[i] = Math.sin((2 * Math.PI / 128) * i) + 0.5;
     cos[i] = Math.cos((2 * Math.PI / 128) * i) + 0.5;
  }
   
  // set up stuff
  pointPos = new int[NUM_POINTS][2];
  pointPhase = new int[NUM_POINTS];
  rotatePhase = new int[NUM_POINTS];
  colorOffset = new int[NUM_POINTS];
  for(int i = 0; i < NUM_POINTS; i ++) {
    pointPos[i][0] = (int)((Math.random() * 50) + 25);
    pointPos[i][1] = (int)((Math.random() * 50) + 25);
    pointPhase[i] = (int)(Math.random() * 255);
    rotatePhase[i] = 0;
    colorOffset[i] = (int)(Math.random() * 50);
  }
}

// draw this shit
void draw() {
//  clear();
  strokeWeight(1);
  stroke(255, 0, 0);
  noFill();
  
  // render each point
  for(int i = 0; i < NUM_POINTS; i ++) {
      // render waves from each point
      for(int j = 0; j < (RINGS * RING_SPACING); j += RING_SPACING) {
        int r = (int)((double)255 * sine[(pointPhase[i] + j) & 0xff]); 
        int g = (int)((double)255 * sine[(pointPhase[i] + j + colorOffset[i]) & 0xff]); 
        int b = (int)((double)255 * sine[(pointPhase[i] + j + (colorOffset[i] * 2)) & 0xff]); 
        stroke(r, g, b);
        if((i & 0x01) == 1) {
          ellipse(pointPos[i][0] + (int)(sine[rotatePhase[i]] * ROTATE_SIZE), 
            pointPos[i][1] + (int)(cos[rotatePhase[i]] * ROTATE_SIZE), 10 + j, 10 + j);
        }
        else {
          ellipse(pointPos[i][0] + (int)(cos[rotatePhase[i]] * ROTATE_SIZE), 
            pointPos[i][1] + (int)(sine[rotatePhase[i]] * ROTATE_SIZE), 10 + j, 10 + j);          
        }
     }
     pointPhase[i] = (pointPhase[i] + 1) & 0xff;
     rotatePhase[i]  = (rotatePhase[i] + 1) & 0xff;
  }
}
