import SimpleOpenNI.*;
import ddf.minim.*;

SimpleOpenNI kinect;

float rotation = 0;

Minim minim;
AudioPlayer kick;
AudioPlayer snare;

Hotpoint snareTrigger;
Hotpoint kickTrigger;

float s = 1;

void setup(){
  size(1024, 768, P3D);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  minim = new Minim(this);
  snare = minim.loadFile("drum2_snare.wav");
  kick = minim.loadFile("drum2_bassdrum.wav");
  
  snareTrigger = new Hotpoint(200,0,600,150);
  kickTrigger = new Hotpoint(-200,0,600,150);
}

void draw(){
  background(0);
  kinect.update();
  translate(width/2,height/2,-1000);
  rotateX(radians(180));
  
  translate(0,0,1400);
  rotateY(radians(map(mouseX,0,width,-180,180)));
  rotateX(radians(map(mouseY,0,height,-180,180)));
  
  translate(0,0,s*-1000);
  scale(s);
  
  stroke(255);
  
  PVector[] depthPoints = kinect.depthMapRealWorld();
  for(int i=0;i<depthPoints.length;i+=8){
    PVector currentPoint = depthPoints[i];
    snareTrigger.check(currentPoint);
    kickTrigger.check(currentPoint);
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
  
  //println(snareTrigger.pointsIncluded);
  
  if(snareTrigger.isHit()){
    snare.play();
  }
  if(!snare.isPlaying()){
    snare.rewind();
    snare.pause();
  }
  
  if(kickTrigger.isHit()){
    kick.play();
  }
  if(!kick.isPlaying()){
    kick.rewind();
    kick.pause();
  }
  
  snareTrigger.draw();
  snareTrigger.clear();
  
  kickTrigger.draw();
  kickTrigger.clear();
}

void stop(){
  kick.close();
  snare.close();
  
  minim.stop();
  super.stop();
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


