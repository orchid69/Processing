import processing.serial.*;

Serial myPort;  
  
PFont font;  
  
int   index;  
int[] data;  
  
int   val;  
long  time;  
  
void setup()  
{  
  size(640, 480, P3D);  
    
  font = createFont("Meiryo", 20);  
    
  index = 0;  
  data  = new int[width];  
  for(int i = 0; i < data.length; ++i) data[i] = -1;  
    
  String port = Serial.list()[0];  
  myPort = new Serial(this, port, 9600);  
}  
  
void draw()  
{  
  background(0);  
  camera(0, -0xFF,   width,   
         0, -0xFF/2, 0,   
         0,  1,      0);  
           
  
  float angle = radians(time) * 0.1f;  
  rotateY(angle);  
    
  pushMatrix();  
  translate(-width/2, -0xFF, 0);  
    
  int prevY = 0xFF;  
  for(int x = 1; x < width; ++x) {  
    int v = data[(x + index) % data.length];  // 電圧: 0 ～ 255  
    int y = 0xFF - v;   
  
    stroke(255, v);  
    if(prevY < 0xFF) line(x - 1, prevY, x, y);  
    prevY = y;  
  }  
  popMatrix();  
    
    
  stroke(0, 255, 0, 100);  
  for(int i = -width/2; i <= width / 2; i += 40) {  
    line(-width/2, 0, i, width/2, 0, i);  
    line(i, 0, -width/2, i, 0, width/2);  
  }   
    
  pushMatrix();  
  camera();  
  hint(DISABLE_DEPTH_TEST);  
    
  
  text("Voltage: " + (val * 19.6) + " [mV]", 10, 10);  
    
  hint(ENABLE_DEPTH_TEST);  
  popMatrix();  
    
  ++time;  
}  
   
void serialEvent(Serial p){  
  
  val = myPort.read();  
    
  index = (index + 1) % data.length;  
  data[index] = val;  
}  
