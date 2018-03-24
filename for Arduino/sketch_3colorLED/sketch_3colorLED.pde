import processing.serial.*;
Serial myPort;
int state = 0;

void setup(){
  myPort=new Serial(this,Serial.list()[0],9600);
}

void draw(){
  myPort.write(state);
}

void keyPressed(){
  if(key == 'b'){
    myPort.write(0);
  }
  else if(key == 'r'){
    myPort.write(1);
  }
  else if(key == 'g'){
    myPort.write(2);
  }
  else if(key == 'B'){
    myPort.write(3);
  }
  else if(key == 'R'){
    myPort.write(4);
  }
  else if(key == 'G'){
    myPort.write(5);
  }
  
}




