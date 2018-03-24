//make things see p130-
import SimpleOpenNI.*;

SimpleOpenNI kinect;

float rotation = 0;
float s = 1;

void setup(){
  size(1024, 768, P3D);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.alternativeViewPointDepthToImage();
}

void draw(){
  background(0);
  kinect.update();
  
  PImage rgbImage = kinect.rgbImage();
  
  translate(width/2, height/2, -250);
  rotateX(radians(180));
  scale(s);
  //rotateY(radians(rotation));
  //rotation++;
  float mouseRotation = map(mouseX, 0, width, -180, 180);
  rotateY(radians(mouseRotation));
    
  PVector[] depthPoints = kinect.depthMapRealWorld();
  for(int i=0; i < depthPoints.length; i+=5){
    PVector currentPoint = depthPoints[i];
    stroke(rgbImage.pixels[i]);
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
}

void keyPressed(){
  if(keyCode == 38){
    s = s + 0.01;
  }
  if(keyCode == 40){
    s = s - 0.01;
  }
}



void mousePressed(){
  save("drawing.png");
}
