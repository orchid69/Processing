//Invisible Pencil

import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestDepthValue;
int closestX;
int closestY;

float previousX;
float previousY;

float c1;
float c2;
float c3;

void setup(){
  size(640,480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  background(0);
}

void draw(){
  closestDepthValue = 8000;
  kinect.update();
  
  int[] depthValues = kinect.depthMap();
  
  for(int y=0; y<480; y++){
    for(int x=0; x<640; x++){
      int reverseX = -x + 639;
      int i = reverseX + y*640;
      int currentDepthValue = depthValues[i];
      
      if(610 < currentDepthValue && currentDepthValue < 1525 && currentDepthValue < closestDepthValue){
        closestDepthValue = currentDepthValue;
        //[currentDepthValue>0] is needed in order to remove unreliable data. Kinect shows "0" against "NO DATA"
        closestX = x;
        closestY = y;
      }
    }
  }
  float interpolatedX = lerp(previousX, closestX, 0.5f);
  float interpolatedY = lerp(previousY, closestY, 0.5f);
  strokeWeight(1);
  c1 = random(0,255);
  c2 = random(0,255);
  c3 = random(0,255);
  stroke(c1, c2, c3);
  line(previousX, previousY, interpolatedX, interpolatedY);
  
  previousX = interpolatedX;
  previousY = interpolatedY;
}

void mousePressed(){
  save("drawing.png");
  background(0);
}

