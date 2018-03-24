import processing.serial.*;
Serial myPort;

int x=0;
int y=0;
int z=0;

void setup(){
  size(255,255,P3D);
  myPort=new Serial(this,Serial.list()[0],9600);
  noFill();
}

void draw(){
  background(255);
  translate(x,y,z);
  box(50);
}

//シリアル通信処理
void serialEvent(Serial p){
  if(myPort.available()>2){
    x=myPort.read();
    y=myPort.read();
    z=myPort.read();
    myPort.write(65);
  }
}

void mousePressed(){
  myPort.clear();
  myPort.write(65);
}
