//Discribe the nearest point for kinect as a red point.

import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestDepthValue;
int closestX;
int closestY;

void setup(){
  size(640,480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw(){
  closestDepthValue = 8000;
  kinect.update();
  
  int[] depthValues = kinect.depthMap();
  
  for(int y=0; y<480; y++){
    for(int x=0; x<640; x++){
      int i = x+(y*640);
      int currentDepthValue = depthValues[i];
      
      if(currentDepthValue > 0 && currentDepthValue < closestDepthValue){
        closestDepthValue = currentDepthValue;
        //[currentDepthValue>0] is needed in order to remove unreliable data. Kinect shows "0" against "NO DATA"
        closestX = x;
        closestY = y;
      }
    }
  }
  image(kinect.depthImage(), 0, 0);
  fill(255, 0, 0);
  ellipse(closestX, closestY, 25, 25);
}

