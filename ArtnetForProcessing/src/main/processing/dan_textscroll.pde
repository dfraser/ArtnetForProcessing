PFont font;

String textToScroll[] = {
  "HACKLAB.TO", 
  "MAKER FAIRE",
  "HACK THE PLANET"
};

int textPos = 0;
int messagePos = 0;
float textLength;
String textString;
int textSpace = 100; // pixels of delay between messages
int textColor;

void setup() {
  size(34,70);
  font = createFont("SansSerif", 32); 
  textFont(font,32); 
  colorMode(HSB);
  nextMessage();
}

void draw() {
  background(0);
  text(textString,0+width-textPos,30);
  textPos++;
  if (textPos > textLength+textSpace) {
    nextMessage();
    textPos = 0;
  }
}

void nextMessage() {
  fill(random(360),255,255);
  textString = textToScroll[messagePos];
  textLength = textWidth(textString);
  messagePos++;
  if (messagePos >= textToScroll.length) {
    messagePos = 0;
  }
}