import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup(){
  size(640,480);
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
}

void draw(){
  float confidence;
  kinect.update();
  PImage depth = kinect.depthImage();
  image(depth,0,0);
  
  IntVector userList = new IntVector();
  
  kinect.getUsers(userList);
  
  if(userList.size()>0){
    int userId = userList.get(0);
    
    if(kinect.isTrackingSkeleton(userId)){
      PVector rightHand = new PVector();
      confidence = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,rightHand);
      //println(confidence);
      
      PVector convertedRightHand = new PVector();
      kinect.convertRealWorldToProjective(rightHand,convertedRightHand);
      
      fill(255,0,0);
      float ellipseSize = map(convertedRightHand.z, 700, 2500, 50, 1);
      if(confidence>0.6){
        ellipse(convertedRightHand.x, convertedRightHand.y,ellipseSize,ellipseSize);
      }  
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
