import saito.objloader.*;

OBJModel model,model1,model2,model3;
float rotateX;
float rotateY;

void setup(){
  size(640, 480, P3D);
  
  model = new OBJModel(this, "kinect.obj", "relative", TRIANGLES);
  model1 = new OBJModel(this, "model1.obj", "relative", TRIANGLES);
  model2 = new OBJModel(this, "model2.obj", "relative", TRIANGLES);
  model3 = new OBJModel(this, "model3.obj", "relative", TRIANGLES);
  model.translateToCenter();
  model1.translateToCenter();
  model2.translateToCenter();
  model3.translateToCenter();
  noStroke();
}

void draw(){
  background(255);
  lights();
  
  translate(width/2, height/2, 0);
  
  rotateX(rotateY);
  rotateY(rotateX);
  
  translate(0,0,200);
  //model.draw()
  translate(-200,0,0);
  model1.draw();
  translate(200,0,0);
  model2.draw();
  translate(200,0,0);
  model3.draw();
}

void mouseDragged(){
  rotateX += (mouseX - pmouseX)*0.01;
  rotateY -= (mouseY - pmouseY)*0.01;
}
