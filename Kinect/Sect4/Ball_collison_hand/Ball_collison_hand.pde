import SimpleOpenNI.*;
SimpleOpenNI kinect;

int numBalls;
boolean state = true;
Ball[] balls = new Ball[1000]; 

float spring = 100;
float reduction = 1;
float gravity = 0;


void setup(){
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  
  size(640,480);
  fill(255,0,0);
  strokeWeight(5);
  textSize(20);
}

void draw(){
  kinect.update();
  //pushMatrix();
  translate(width,0);
  scale(-1,1);
  image(kinect.depthImage(),0,0);
  //popMatrix();
  
  noStroke();
  for(int i=0; i<numBalls; i++){
    balls[i].display();
    balls[i].move();
    balls[i].bound();
    balls[i].collide();
  }
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  
  if(userList.size()>0){
    int userId = userList.get(0);
    
    if(kinect.isTrackingSkeleton(userId)){
      PVector leftHand = new PVector();
      PVector rightHand = new PVector();
      
      kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
      kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
      
      PVector differenceVector = PVector.sub(leftHand,rightHand);
      
      float magnitude = differenceVector.mag();
      
      float convertedMagnitude;
      PVector convertedRightHand = new PVector();
      PVector convertedLeftHand = new PVector();
      kinect.convertRealWorldToProjective(rightHand,convertedRightHand);
      kinect.convertRealWorldToProjective(leftHand,convertedLeftHand);
      convertedMagnitude = PVector.sub(convertedRightHand,convertedLeftHand).mag();
      
      int i;
      for(i=0;i<numBalls;i++){
        float dx1 = balls[i].posx - convertedLeftHand.x;
        float dx2 = balls[i].posx - convertedRightHand.x;
        float dy1 = balls[i].posy - convertedLeftHand.y;
        float dy2 = balls[i].posy - convertedRightHand.y;
        float distance1 = sqrt(dx1*dx1 + dy1*dy1);
        float distance2 = sqrt(dx2*dx2 + dy2*dy2);
        float critical = 10 + balls[i].radi;
        if(distance1 < critical || distance2 < critical){
          /*float force = spring * (critical - distance);
          float theta = atan2(dy,dx);
          float ax = -force * cos(theta) / balls[i].mass;
          float ay = -force * sin(theta) / balls[i].mass;
          balls[i].speedx += ax;
          balls[i].speedy += ay;
          */
          balls[i].speedx *= -1;
          balls[i].speedy *= -1;
        }
      }
  
      fill(255,0,0);
      noStroke();
      //ellipse((convertedRightHand.x+convertedLeftHand.x)/2,(convertedRightHand.y+convertedLeftHand.y)/2,convertedMagnitude,convertedMagnitude);
      
      differenceVector.normalize();
      strokeWeight(5);  
      kinect.drawLimb(userId,SimpleOpenNI.SKEL_LEFT_HAND,SimpleOpenNI.SKEL_RIGHT_HAND);
      
      pushMatrix();
        fill(abs(differenceVector.x)*255,abs(differenceVector.y)*255,abs(differenceVector.z)*255);
        text("m: " + magnitude,5,100);
      popMatrix();
    }
  }
}

//User Track Call back
void onNewUser(int userId){
  println("Start Pose Detection");
  kinect.startPoseDetection("Psi",userId);
}

void onEndCalibration(int userId, boolean successful){
  if(successful){
    println("Succeed in user Calibration!");
    kinect.startTrackingSkeleton(userId);
  }else{
    println("Fail in user Calibration!!");
    kinect.startPoseDetection("Psi",userId);
  }
}

void onStartPose(String pose, int userId){
  println("Start user Pose");
  kinect.stopPoseDetection(userId);
  kinect.requestCalibrationSkeleton(userId, true);
}

class Ball{
  float posx, posy;
  float radi;
  float speedx, speedy;
  color clr;
  int idno;
  float mass;
  Ball[] others;
  
  Ball(float x, float y, float r, float sx, float sy, int id, color c, Ball[] o){
    posx = x;
    posy = y;
    radi = r;
    speedx = sx;
    speedy = sy;
    clr = c;
    idno = id;
    mass = radi*radi;
    others = o;
  }

  void move(){
    speedx *= reduction;
    speedy *= reduction;
    posx += speedx;
    posy += speedy;
    speedy += gravity;
  }
  
  void bound(){
    if(posy + radi >= height){
      speedy = -speedy;
      posy = height - radi;
    }
    if(posy - radi <= 0){
      speedy = -speedy;
      posy = radi;
    }
    if(posx + radi >= width){
      speedx = -speedx;
      posx = width - radi; 
    }
    if(posx - radi <= 0){
      speedx = -speedx;
      posx = radi;
    }
  }
  
  void collide(){    
    for(int i=idno+1; i<numBalls; i++){
      float dx = others[i].posx - posx;
      float dy = others[i].posy - posy;
      float distance = sqrt(dx*dx + dy*dy);
      float critical = others[i].radi + radi;
      if(distance < critical){
        float force = spring * (critical - distance);
        float theta = atan2(dy, dx);
        float ax = -force * cos(theta) / mass;
        float ay = -force * sin(theta) / mass;
        speedx += ax;
        speedy += ay;
        ax = force * cos(theta) / others[i].mass;
        ay = force * sin(theta) / others[i].mass;
      }
    }
  }
  
  void display(){
    fill(clr);
    ellipse(posx, posy, radi*2, radi*2);
  }
}

void mousePressed(){
  float x = mouseX;
  float y = mouseY;
  float r = random(10, 20);
  float sx = random(-10,10);
  float sy = random(-10,10);
  color c = color(random(0,255), random(0,255), random(255));
  balls[numBalls] = new Ball(x, y, r, sx, sy, numBalls, c, balls);
  numBalls = numBalls + 1;

}


