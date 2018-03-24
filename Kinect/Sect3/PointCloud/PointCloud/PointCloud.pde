import SimpleOpenNI.*;

SimpleOpenNI kinect;

void setup(){
  size(1024, 768, P3D);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw(){
  background(0);
  kinect.update();
  
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  
  stroke(255);
  
  PVector[] depthPoints = kinect.depthMapRealWorld();
  for(int i=0; i < depthPoints.length; i+=1){
    PVector currentPoint = depthPoints[i];
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
}

