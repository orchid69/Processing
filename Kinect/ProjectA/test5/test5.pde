import SimpleOpenNI.*;
import processing.serial.*;
SimpleOpenNI kinect;
Serial myPort;

int SerialTrigger = 0;
int set_coordinates = 1;
float z0=0;
float fov=45.0;

PVector TorsionCoordinatesX = new PVector();
PVector TorsionCoordinatesY = new PVector();
PVector TorsionCoordinatesZ = new PVector();
void setup(){
  size(1028,768,P3D);
  
  frameRate(20);
  println(Serial.list()[0]);
  myPort=new Serial(this,Serial.list()[0],9600);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);
  
  fill(255,0,0);
  z0 = (height/2)/(tan(radians(fov/2)));
}

void draw(){
  kinect.update();
  background(255);
  
  translate(width/2,height/2,z0);
  rotateX(radians(180));
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if(userList.size()>0){
    int userId = userList.get(0);
    
    if(kinect.isTrackingSkeleton(userId)){
      PVector rightHand = new PVector();
      kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
      PVector rightShoulder = new PVector();
      kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,rightShoulder);
      PVector rightElbow = new PVector();
      kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,rightElbow);
      PVector position = new PVector();
      kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,position);      
      PVector EtoS = PVector.sub(rightShoulder, rightElbow);
      PVector EtoH = PVector.sub(rightHand, rightElbow);
      PVector HtoE = PVector.sub(rightElbow, rightHand);
      PVector StoE = PVector.sub(rightElbow, rightShoulder); // Shoulder to Elbow Vector
      PVector HtoS = PVector.sub(rightShoulder, rightHand);
      PVector StoH = PVector.sub(rightHand, rightShoulder);
      
      //get torsion coordinates
      if(set_coordinates == 1){
        TorsionCoordinatesX.set(1,0,0);
        TorsionCoordinatesX.normalize();
        
        //TorsionCoordinatesY = HtoE.get();
        TorsionCoordinatesY.set(0,1,0);
        TorsionCoordinatesY.normalize();
        
        TorsionCoordinatesZ = TorsionCoordinatesX.cross(TorsionCoordinatesY);
        set_coordinates = 0;
      }
      
      //get elbow angle
      int ElbowAngle = get_angle(EtoS, EtoH);
      
      //get Shoulder angle 2 : vertical angle at Shoulder
      PVector ConvertedrightElbow = new PVector();
      ConvertedrightElbow.set(rightShoulder.x, rightElbow.y, rightElbow.z);
      PVector StandardVector2 = new PVector();
      StandardVector2.set(rightShoulder.x, rightShoulder.y - 100, rightShoulder.z);
      StandardVector2.sub(rightShoulder);
      ConvertedrightElbow.sub(rightShoulder);
      int ShoulderAngle2 = get_angle(StandardVector2, ConvertedrightElbow); //ShoulderAngel2: vertical angle at Shoulder 
      
      //get Shoulder angle 1 : horizontal angle at Shoulder
      
      int ShoulderAngle1 = get_angle(ConvertedrightElbow, StoE);
      
      //get torsion coordinates
      PVector Ee = new PVector();
      Ee.set(0,-1,0);
      PVector x = new PVector();
      x.set(1,0,0);
      Ee.mult( EtoS.dot(Ee) / (Ee.mag() * Ee.mag()) );
      PVector Se = new PVector();
      Se = PVector.add(StoE, Ee);
      int angleZ = get_angle(StoE, Se);
      if(rightShoulder.y > rightElbow.y){
        angleZ *= -1;
      }
      int angleY = -1 * get_angle(StoE, x);
            
      pushMatrix();
        translate(rightShoulder.x, rightShoulder.y, rightShoulder.z);
        //translate(rightElbow.x, rightElbow.y, rightElbow.z);
        rotateY(radians(-angleY));
        rotateZ(radians(angleZ));
        //debug
        stroke(255,0,0);
        strokeWeight(5);
        line(0,0,0, 500, 0, 0);
        stroke(0,255,0);
        line(0,0,0, 0, 500, 0);
        stroke(0,0,255);
        //line(0,0,0, 0, 0, 500);
        //debug
        
        PVector Hh = EtoS.get();
        Hh.mult(HtoE.dot(Hh) / (Hh.mag() * Hh.mag()) );
        PVector Eh = new PVector();
        Eh = PVector.add(EtoH, Hh);
        PVector Stand = new PVector();
        Stand.set(0,10,0);
        int TorsionAngle = int(degrees(PVector.angleBetween(Eh,Stand)));
      popMatrix();
      
      println("ElbowAngle:" + ElbowAngle);
      println("ShoulderAngle1:" + ShoulderAngle1);
      println("ShoulderAngle2:" + ShoulderAngle2);
      println("TorsionAngle" + TorsionAngle);
      
      ////myPort.write(1);//start sign to Arduino
      if(myPort.available()>0 || SerialTrigger == 1){
        myPort.write(ElbowAngle);
        myPort.write(ShoulderAngle1);
        myPort.write(ShoulderAngle2);
        myPort.write(TorsionAngle);
        
        if(SerialTrigger == 0){
          myPort.read();
        }
        SerialTrigger = 0;
      }
      
      pushMatrix();
        translate(rightHand.x, rightHand.y, rightHand.z);
        rotateX(PI);
        fill(255,0,0);
        scale(5);
        text("SholderAngle1:" + ShoulderAngle1 + "\n" + "ShoulderAngle2:" + ShoulderAngle2 + "\n" + "TorsionAngle:" + TorsionAngle, 0, 0);
        //text("Se.x,Se.y,Se.z: " + int(Se.x) + " " + int(Se.y) + " " + int(Se.z) + "\n" + "angleZ: " + angleZ, 0 ,0 );
      popMatrix();
      
      //PMatrix3D orientation = new PMatrix3D();
      //float confidence = kinect.getJointOrientationSkeleton(userId,SimpleOpenNI.SKEL_TORSO,orientation); 
      //println(confidence);
      
      drawSkeleton(userId);
      
      /*
      pushMatrix();
        translate(position.x,position.y,position.z);      
      
        applyMatrix(orientation);
        
        stroke(255,0,0);
        strokeWeight(3);
        line(0,0,0,150,0,0);
        
        stroke(0,255,0);
        line(0,0,0,0,150,0);
        
        stroke(0,0,255);
        line(0,0,0,0,0,150);
      popMatrix();
      */
    }
    else{
      //image(kinect.depthImage(),0,0);
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

void drawLimb(int userId,int jointType1,int jointType2)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;

  confidence = kinect.getJointPositionSkeleton(userId,jointType1,jointPos1);
  confidence +=  kinect.getJointPositionSkeleton(userId,jointType2,jointPos2);
  stroke(100);
  strokeWeight(5);
  if(confidence > 1){
    line(jointPos1.x,jointPos1.y,jointPos1.z, jointPos2.x,jointPos2.y,jointPos2.z);
  }
}

void onNewUser(int userId){
  println("Start Pose Detection");
  kinect.startPoseDetection("Psi",userId);
}

void onEndCalibration(int userId, boolean successful){
  if(successful){
    println("Succeed in user Calibration!");
    kinect.startTrackingSkeleton(userId);
    SerialTrigger = 1;
    set_coordinates = 1;
  }else{
    println("Fail in user Calibration!!");
    kinect.startPoseDetection("Psi",userId);
    SerialTrigger = 0;
  }
}

void onStartPose(String pose, int userId){
  println("Start user Pose");
  kinect.stopPoseDetection(userId);
  kinect.requestCalibrationSkeleton(userId, true);
}

int get_angle(PVector Vector1, PVector Vector2){
        int angle = 0;
        float cos = Vector1.dot(Vector2)/(Vector1.mag() * Vector2.mag());
        float anglef = degrees(acos(cos));
        angle = int(anglef);
        
        return angle;
}
      
      




