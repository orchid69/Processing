import saito.objloader.*;

OBJModel model;

void setup(){
  size(500,500,P3D);
  model = new OBJModel(this,"kinect.obj","relative",TRIANGLES);
  //noStroke();
}

void draw(){
  background(255);
  //lights();
  translate(width/2,height/2,0);
  applyMatrix(1,0,0,0,
              0,cos(PI/2),-sin(PI/2),0,
              0,sin(PI/2),cos(PI/2),0,
              0,0,0,1);
  applyMatrix(cos(PI/6),-sin(PI/6),0,0,
              sin(PI/6),cos(PI/6),0,0,
              0,0,1,0,
              0,0,0,1);
  noFill();
  //box(200);
  applyMatrix(1,0,0,0,
              0,1,0,0,
              0,0,1,0,
              0,0,-1,0);
  box(200);
}
