void setup(){
  size(displayWidth,displayHeight,P3D);
}

void draw(){
  background(255);
  stroke(0,50);
  camera(mouseX,mouseY,-300,width/2,height/2,0,0,1,0);
  float xstart = random(10);
  float ynoise = random(10);
  translate(width/2,height/2,0);
  for (float y = -(height/8);y<=(height/8);y+=3){
    ynoise += 0.02;
    
    float xnoise = xstart;
    for(float x= -(width/8);x<=(width/8);x+=3){
      xnoise += 0.02;
      drawPoint(x,y,noise(xnoise,ynoise));
    }
  }
}

void drawPoint(float x,float y,float noiseFactor){
  pushMatrix();
  float edgeSize = noiseFactor*26;
  line(0,0,0,x*noiseFactor*4,y*noiseFactor*4,-y);
  popMatrix();
}

void mousePressed(){
  save("drawing.png");
}
