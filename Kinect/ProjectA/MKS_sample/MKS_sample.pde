//Example A-7 forward_kinematics_serial.pde
import SimpleOpenNI.*;
SimpleOpenNI  kinect;

// import the processing serial library
import processing.serial.*;
// and declare an object for our serial port
Serial port;

void setup() {
  size(640, 480);

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);

  // Get the name of the first serial port
  // where we assume the Arduino is connected.
  // If it doesn't work, examine the output of
  // the println, and replace 0 with the correct
  // serial port index.
  println(Serial.list());

  // initialize our serial object with this port
  // and the baud rate of 9600
  port = new Serial(this, Serial.list()[0], 9600);
}

void draw() {
  kinect.update();
  PImage depth = kinect.depthImage();
  image(depth, 0, 0);

  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  if (userList.size() > 0) {
    int userId = userList.get(0);

    if ( kinect.isTrackingSkeleton(userId)) {
      // get the positions of the three joints of our arm
      PVector rightHand = new PVector();
      kinect.getJointPositionSkeleton(userId,
        SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);

      PVector rightElbow = new PVector();
      kinect.getJointPositionSkeleton(userId,
            SimpleOpenNI.SKEL_RIGHT_ELBOW, rightElbow);

      PVector rightShoulder = new PVector();
      kinect.getJointPositionSkeleton(userId,
            SimpleOpenNI.SKEL_RIGHT_SHOULDER, rightShoulder);

      // convert our arm joints into screen space coordinates
      PVector convertedRightHand = new PVector();
      kinect.convertRealWorldToProjective(rightHand, convertedRightHand);

      PVector convertedRightElbow = new PVector();
      kinect.convertRealWorldToProjective(rightElbow, convertedRightElbow);

      PVector convertedRightShoulder = new PVector();
      kinect.convertRealWorldToProjective(rightShoulder,
                                          convertedRightShoulder);

      // we need right hip to orient the shoulder angle
      PVector rightHip = new PVector();
      kinect.getJointPositionSkeleton(userId,
        SimpleOpenNI.SKEL_RIGHT_HIP, rightHip);

      // reduce our joint vectors to two dimensions
      PVector rightHand2D = new PVector(rightHand.x, rightHand.y);
      PVector rightElbow2D = new PVector(rightElbow.x, rightElbow.y);
      PVector rightShoulder2D = new PVector(rightShoulder.x,
                                            rightShoulder.y);
      PVector rightHip2D = new PVector(rightHip.x, rightHip.y);

      // calculate the axes against which we want to measure our angles
      PVector torsoOrientation = PVector.sub(rightShoulder2D, rightHip2D);
      PVector upperArmOrientation =
        PVector.sub(rightElbow2D, rightShoulder2D);

      // calculate the angles of each of our arms
      float shoulderAngle =
        angleOf(rightElbow2D, rightShoulder2D, torsoOrientation);
      float elbowAngle =
        angleOf(rightHand2D, rightElbow2D, upperArmOrientation);

      // show the angles on the screen for debugging
      fill(255,0,0);
      scale(3);
      text("shoulder: " + int(shoulderAngle) + "\n" +
           " elbow: " + int(elbowAngle), 20, 20);
      
      /*     
      int ConvertedshoulderAngle, ConvertedelbowAngle;
      ConvertedshoulderAngle = int(shoulderAngle) - 127;
      ConvertedelbowAngle = int(elbowAngle) - 127;
      println(ConvertedshoulderAngle);
      println(ConvertedelbowAngle);
      */
      
      byte out[] = new byte[2];
      out[0] = byte(shoulderAngle);
      out[1] = byte(elbowAngle);
      port.write(out);
    }
  }
}

float angleOf(PVector one, PVector two, PVector axis) {
  PVector limb = PVector.sub(two, one);
  return degrees(PVector.angleBetween(limb, axis));
}

// user-tracking callbacks!
void onNewUser(int userId) {
  println("start pose detection");
  kinect.startPoseDetection("Psi", userId);
}

void onEndCalibration(int userId, boolean successful) {
  if (successful) {
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  }
  else {
    println("  Failed to calibrate user !!!");
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId) {
  println("Started pose for user");
  kinect.stopPoseDetection(userId);
  kinect.requestCalibrationSkeleton(userId, true);
}
