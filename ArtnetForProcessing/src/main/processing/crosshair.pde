import java.util.*;
import java.awt.Color;

int xpos = 48;
int ypos = 12;
int allon = 0;

List<Color> colourList = new ArrayList<Color>();
int currentColour; 

void setup() {
  colourList.add(Color.RED);
  colourList.add(Color.GREEN);
  colourList.add(Color.BLUE);
  colourList.add(Color.WHITE);
  
  textFont(loadFont("SansSerif-9.vlw"));
  textMode(SCREEN);
  size(170, 170);
  background(0);
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

  set(xpos, ypos, 255);

  fill(255);
  text(xpos + " - " + ypos, 20, 20);

  if(allon > 0) {
    fill(255); 
    rect(0, 0, width, height);  
  }

  
//  System.out.println("x: " + xpos + " - y: " + ypos);

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
