import processing.opengl.*;
import SimpleOpenNI.*;
import saito.objloader.*;

SimpleOpenNI kinect;
OBJModel model;

void setup(){
  size(1028,768,P3D);
  
  model = new OBJModel(this,"kinect.obj","relative",TRIANGLES);
  model.translateToCenter();
  
  BoundingBox box = new BoundingBox(this,model);
  model.translate(box.getMin());
  
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);
}

void draw(){
  kinect.update();
  background(255);
  translate(width/2,height/2,0);
  rotateX(radians(180));
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if(userList.size()>0){
    int userId = userList.get(0);
    if(kinect.isTrackingSkeleton(userId)){
      PVector leftHand = new PVector();
      kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
      PVector rightHand = new PVector();
      kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
      PVector difHand = new PVector();
      difHand=PVector.sub(rightHand,leftHand);
      difHand.normalize();
      
      PVector axisX = new PVector(1,0,0);
      float angle = acos(axisX.dot(difHand));
      PVector rotateAxis = axisX.cross(difHand);
      
      stroke(255,0,0);
      strokeWeight(5);
      drawSkeleton(userId);
      
      pushMatrix();
        lights();
        stroke(175);
        strokeWeight(1);
        fill(250);
        translate(leftHand.x,leftHand.y,leftHand.z);
        rotate(angle, rotateAxis.x, rotateAxis.y, rotateAxis.z);
        model.draw();
      popMatrix();
    }
  }
}

void drawSkeleton(int userId){
  
  drawLimb(userId,SimpleOpenNI.SKEL_HEAD,SimpleOpenNI.SKEL_NECK);
  drawLimb(userId,SimpleOpenNI.SKEL_NECK,SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawLimb(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawLimb(userId,SimpleOpenNI.SKEL_LEFT_ELBOW,SimpleOpenNI.SKEL_LEFT_HAND);
  drawLimb(userId,SimpleOpenNI.SKEL_NECK,SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawLimb(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawLimb(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,SimpleOpenNI.SKEL_RIGHT_HAND);
  drawLimb(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,SimpleOpenNI.SKEL_TORSO);
  drawLimb(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,SimpleOpenNI.SKEL_TORSO);
  drawLimb(userId,SimpleOpenNI.SKEL_TORSO,SimpleOpenNI.SKEL_LEFT_HIP);
  drawLimb(userId,SimpleOpenNI.SKEL_LEFT_HIP,SimpleOpenNI.SKEL_LEFT_KNEE);
  drawLimb(userId,SimpleOpenNI.SKEL_LEFT_KNEE,SimpleOpenNI.SKEL_LEFT_FOOT);
  drawLimb(userId,SimpleOpenNI.SKEL_TORSO,SimpleOpenNI.SKEL_RIGHT_HIP);
  drawLimb(userId,SimpleOpenNI.SKEL_RIGHT_HIP,SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawLimb(userId,SimpleOpenNI.SKEL_RIGHT_KNEE,SimpleOpenNI.SKEL_RIGHT_FOOT);
  drawLimb(userId,SimpleOpenNI.SKEL_RIGHT_HIP,SimpleOpenNI.SKEL_LEFT_HIP);
}

void drawLimb(int userId,int jointType1,int jointType2){
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float confidence1,confidence2;
  confidence1 = kinect.getJointPositionSkeleton(userId,jointType1,jointPos1);
  confidence2 = kinect.getJointPositionSkeleton(userId,jointType2,jointPos2);
  stroke(100);
  strokeWeight(5);
  if(confidence1>0.5 && confidence2>0.5){
    line(jointPos1.x,jointPos1.y,jointPos1.z,jointPos2.x,jointPos2.y,jointPos2.z);
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



