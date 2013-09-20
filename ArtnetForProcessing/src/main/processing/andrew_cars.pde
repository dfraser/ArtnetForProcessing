import org.capybara.artnetforprocessing.*;
import artnet4j.events.*;
import artnet4j.packets.*;
import artnet4j.*;

// constants
int STAGE_W = 100;
int STAGE_H = 100;
int NUM_CARS = 5;
int NUM_LEVELS = 10;
int CAR_W = STAGE_W / NUM_CARS;

// states
int carpos[][];
int levelSpacing[];
int carColor[][];
int carDirection[];

// setup
void setup() {
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
  
  noSmooth();
  size(width, height);
  frameRate(10); 
   
  // set up stuff
  carpos = new int[NUM_CARS][2];
  levelSpacing = new int[NUM_CARS];
  carColor = new int[NUM_CARS][3];
  carDirection = new int[NUM_CARS];
  for(int i = 0; i < NUM_CARS; i ++) {
    carpos[i][0] = i * (STAGE_W / NUM_CARS);
    carpos[i][1] = (int)(Math.random() * STAGE_H) - STAGE_H;
    levelSpacing[i] = (int)(Math.random() * 5) + 2;
    carColor[i][0] = (int)(Math.random() * 256);
    carColor[i][1] = (carColor[i][0] + (int)(Math.random() * 128)) & 0xff;
    carColor[i][2] = (carColor[i][1] + (int)(Math.random() * 128)) & 0xff;
    carDirection[i] = (int)(Math.random() * 2.0);
  }  
}


// draw this shit
void draw() {
  clear();
  strokeWeight(1);
  noFill();
  
  for(int i = 0; i < NUM_CARS; i ++) {
     stroke(carColor[i][0], carColor[i][1], carColor[i][2]);
     for(int j = 0; j < NUM_LEVELS; j ++) {
        if(carDirection[i] == 1) {
            line(carpos[i][0], carpos[i][1] + (levelSpacing[i] * j), 
              carpos[i][0] + CAR_W, carpos[i][1] + (levelSpacing[i] * j));
        }
        else {
            line(carpos[i][0], STAGE_H - carpos[i][1] + (levelSpacing[i] * j), 
              carpos[i][0] + CAR_W, STAGE_H - carpos[i][1] + (levelSpacing[i] * j));
        }
        
       carpos[i][1] ++;
       // reset stuff
       if(carpos[i][1] > STAGE_H) {
          levelSpacing[i] = (int)(Math.random() * 5);
          carpos[i][1] = (int)(Math.random() * STAGE_H) - STAGE_H;
          carColor[i][0] = (int)(Math.random() * 256);
          carColor[i][1] = (carColor[i][0] + (int)(Math.random() * 128)) & 0xff;
          carColor[i][2] = (carColor[i][1] + (int)(Math.random() * 128)) & 0xff;
          carDirection[i] = (int)(Math.random() * 2.0);
       }
    }
  }
}