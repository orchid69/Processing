import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup(){
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);
  
  size(640,480);
  fill(255,0,0);
  strokeWeight(5);
  textSize(20);
}

void draw(){
  kinect.update();
  //pushMatrix();
  //translate(width,0);
  //scale(-1,1);
  image(kinect.depthImage(),0,0);
  //popMatrix();

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
      ellipse(convertedRightHand.x,convertedRightHand.y,50,50);
      convertedMagnitude = PVector.sub(convertedRightHand,convertedLeftHand).mag();
      fill(255,0,0);
      noStroke();
      ellipse((convertedRightHand.x+convertedLeftHand.x)/2,(convertedRightHand.y+convertedLeftHand.y)/2,convertedMagnitude,convertedMagnitude);
      
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
