import saito.objloader.*;

OBJModel model;
float rotateX;
float rotateY;

void setup(){
  size(displayWidth, displayHeight, P3D);
  
  model = new OBJModel(this, "kinect.obj", "relative", TRIANGLES);
  BoundingBox box = new BoundingBox(this, model);
  model.translate(box.getMin());
  noStroke();
}

void draw(){
  background(255);
  
  lights();
  
  translate(width/2, height/2, 0);
  rotate(PI/2,1,0,0);
  PVector dif = new PVector(1,0,1);
  dif.normalize();
  stroke(0);
  line(0,0,0,100,0,0);
  line(0,0,0,0,200,0);
  line(0,0,0,0,0,300);
  PVector OrientationVector = new PVector(1,0,0);
  OrientationVector.normalize();
  
  float angle = acos(OrientationVector.dot(dif));
  PVector axis = OrientationVector.cross(dif);
  rotate(angle,axis.x, axis.y, axis.z);
  stroke(255,0,0);
  line(0,0,0,100,0,0);
  line(0,0,0,0,200,0);
  line(0,0,0,0,0,300);
  stroke(0);
  model.draw();
}

void mouseDragged(){
  rotateX += (mouseX - pmouseX) * 0.01;
  rotateY -= (mouseY - pmouseY) * 0.01;
}

boolean drawLines = false;

void keyPressed(){
  if(drawLines){
    model.shapeMode(LINES);
    stroke(0);
  }else{
    model.shapeMode(TRIANGLES);
    noStroke();
  }
  drawLines = !drawLines;
}

void mousePressed(){
  //save("drawing.jpg");
}
