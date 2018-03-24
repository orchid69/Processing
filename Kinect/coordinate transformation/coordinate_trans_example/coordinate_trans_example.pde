float angleX=0;
float angleY=0;
float angleZ=0;
float x=0,y=0,z=0;

float num=1.0;
float fov=45.0;
float z0=0;
PMatrix3D matrixX = new PMatrix3D();
PMatrix3D matrixY = new PMatrix3D();
PMatrix3D matrixZ = new PMatrix3D();
PMatrix3D matrixMove = new PMatrix3D();
void setup(){
  //size(500,500,P3D);
  size(1028,768,P3D);
  noFill();
  z0=(height/2)/(tan(radians(fov/2)));
}

void draw(){
  background(255);
  //translate(width/2,height/2,0);
  perspective(radians(fov),float(width)/float(height),1.0,10000.0);
  translate(width/2,height/2,0);
  camera(0,0,z0,0,0,0.0,0.0,1.0,0);
  //translate(width/2,height/2,0);
  pushMatrix();
  matrixX.set(1,0,0,0,
              0,cos(angleX),-sin(angleX),0,
              0,sin(angleX),cos(angleX),0,
              0,0,0,1);
  matrixY.set(cos(angleY),0,sin(angleY),0,
             0,1,0,0,
             -sin(angleY),0,cos(angleY),0,
             0,0,0,1);
  matrixZ.set(cos(angleZ),-sin(angleZ),0,0,
              sin(angleZ),cos(angleZ),0,0,
              0,0,1,0,
              0,0,0,1);
  matrixMove.set(1,0,0,x,
                 0,1,0,y,
                 0,0,1,z,
                 0,0,0,1);
  //applyMatrix(matrixX);
  applyMatrix(matrixY);
  //applyMatrix(matrixZ);
  //applyMatrix(matrixMove);
  //applyMatrix(1,0,0,0,
    //          0,1,0,0,
      //        0,0,1,0,
        //      0,0,1,1);///kowaiyo!
  stroke(0);
  strokeWeight(0.8);
  //sphere(165);
  box(165);
  popMatrix();
  
  pushMatrix();
  applyMatrix(matrixY);
  applyMatrix(matrixZ);
  applyMatrix(matrixX);
  applyMatrix(matrixMove);
  stroke(75);
  //sphere(100);
  popMatrix();
  
  pushMatrix();
  applyMatrix(matrixZ);
  applyMatrix(matrixX);
  applyMatrix(matrixY);
  applyMatrix(matrixMove);
  strokeWeight(0.5);
  stroke(100);
  //sphere(35);
  angleX+=PI/100;
  angleY+=PI/100;
  angleZ+=PI/100;
  x+=0.5;
  y+=0;
  z-=-0.5;
  popMatrix();
}

void mouseClicked(){
  num+=2;
}
