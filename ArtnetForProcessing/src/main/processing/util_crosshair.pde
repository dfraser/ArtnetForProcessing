import org.capybara.artnetforprocessing.*;
import artnet4j.events.*;
import artnet4j.packets.*;
import artnet4j.*;

import java.util.*;
import java.awt.Color;

int xpos = 48;
int ypos = 12;
int allon = 0;
int oldx, oldy;
boolean flash;

List<Color> colourList = new ArrayList<Color>();
int currentColour; 

void setup() {
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


  colourList.add(Color.RED);
  colourList.add(Color.GREEN);
  colourList.add(Color.BLUE);
  colourList.add(Color.WHITE);
  
  textFont(loadFont("SansSerif-9.vlw"));
  textMode(SCREEN);
  size(170, 170);
  frameRate(10);
}


void draw() {
  noStroke();
  fill(0);
  rect(0, 0, width, height);

  Color colour = colourList.get(currentColour);
  stroke(colour.getRed(),colour.getGreen(),colour.getBlue());
  line(0, ypos, width, ypos);
  line(xpos, 0, xpos, height);

   
  set(xpos, ypos, flash ? color(0) : color(255));
  flash = !flash;

  fill(255);
  
//  text(xpos + " - " + ypos, 20, 20);

  if(allon > 0) {
    fill(255); 
    rect(0, 0, width, height);  
  }
  if (oldx != xpos || oldy != ypos) {
     System.out.println("x: " + xpos + " - y: " + ypos);
  }
    oldx = xpos;
    oldy = ypos;
}


void keyPressed() {
  if(key == CODED) {
    if(keyCode == UP) {
      if(ypos > 0) ypos --;
    }  
    if(keyCode == DOWN) {
      if(ypos < height - 1) ypos ++; 
    }
    if(keyCode == LEFT) {
      if(xpos > 0) xpos --; 
    }
    if(keyCode == RIGHT) {
      if(xpos < width - 1) xpos ++;
    }
  }
  
  if(key == 'a') {
    if(allon == 0) allon = 1;
    else allon = 0;
  }

  if (key == 'c') {
    currentColour = (currentColour + 1) % colourList.size();
    println("new colour: "+currentColour);
  }
}