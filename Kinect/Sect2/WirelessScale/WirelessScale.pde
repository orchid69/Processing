import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup(){
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw(){
  kinect.update();
  PImage depthImage = kinect.depthImage();
  image(depthImage, 0, 0);
}

void mousePressed(){
  int[] depthValues = kinect.depthMap();
  int ClickPosition = mouseX + (mouseY*640);
  int ClickedDepth = depthValues[ClickPosition];
  
  println(ClickedDepth + "mm");
}
