import saito.objloader.*;

OBJModel model;
float rotateX;
float rotateY;

void setup(){
  size(displayWidth, displayHeight, P3D);
  
  model = new OBJModel(this, "kinect.obj", "relative", TRIANGLES);
  
  model.translateToCenter();
  noStroke();
}

void draw(){
  background(255);
  
  lights();
  
  translate(width/2, height/2, 0);
  
  /*rotateX(rotateY);
  rotateY(rotateX);*/
  PVector vector = new PVector(1,0,0);
  float angle = PI/2.0;
  rotate(angle,vector.x, vector.y, vector.z);
  
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
  save("drawing.jpg");
}
