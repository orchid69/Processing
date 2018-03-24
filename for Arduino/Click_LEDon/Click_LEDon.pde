import processing.serial.*;
Serial myPort;

void setup(){
  myPort=new Serial(this,Serial.list()[0],38400);
  println(Serial.list());
}

void draw(){
}
void mousePressed(){
  myPort.write("1\r\n");
  println("press");
}

void mouseReleased(){
  myPort.write("0\r\n");
  println("release");
}


