import processing.serial.*;  

PFont font;  

float   val;  
long  time;

int offsetX=0, offsetY=0, clickX=0, clickY=0;
float clickRotationX=0, clickRotationY=0, targetRotationX=0, targetRotationY=0;
float rotationX=0, rotationY=0;


int iro=0;
boolean xAxis = false;

float sigma = 10;
float b = 8.0 / 3.0;
float r = 28;
float dT = 0.001;
float t=0;
float t_max=100;
int count=0;
float y_0[] = { 1, 0, 20 };//[y1,y2,y3]
float y_1[] = new float[3];
float y[][] = new float[3][(int)(t_max/dT)+100];
float amp;
void get_y_prime(float y[], float k[], float h, float y_prime[]) {
  float temp[] = new float[3];
  for (int i = 0; i < 3; i++) {
    temp[i] = y[i] + k[i] * h;
  }
  y_prime[0] = sigma*(temp[1] - temp[0]);
  y_prime[1] = r*temp[0] - temp[1] - temp[0] * temp[2];
  y_prime[2] = temp[0] * temp[1] - b*temp[2];
}

void setup()  
{  
  size(860, 660, P3D);  
  font = createFont("AgencyFB-Bold-24", 20);  

  int cnt=0;
    for (float t = 0; t<t_max; t += dT) {
      float k1[] = new float[3];
      float k2[] = new float[3];
      float k3[] = new float[3];
      float k4[] = new float[3];

      float k0[] = { 0, 0, 0 };
      get_y_prime(y_0, k0, 0, k1);
      get_y_prime(y_0, k1, dT/2, k2);
      get_y_prime(y_0, k2, dT/2, k3);
      get_y_prime(y_0, k3, dT, k4);

      for (int i = 0; i < 3; i++) {
        y_1[i] = y_0[i] + (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]) * dT / 6;
        y[i][cnt] = y_0[i];
      }

      for (int i = 0; i < 3; i++) {
        y_0[i] = y_1[i];
      }
      cnt++;
    }
    float fov = radians(120);  //視野角
 
  perspective(fov, float(width)/float(height), 0.001, width);
  amp = width/80;
}  

void draw()  
{  
  background(iro);
  //ambientLight(100, 100, 100);    //環境光を当てる
  //lightSpecular(255, 255, 255);    //光の鏡面反射色（ハイライト）を設定
  //directionalLight(255, 255, 255, 1, 1, 1);    //指向性ライトを設定
  lights();
  if (count >= y[0].length-10) {
    count = y[0].length-5;
  }
  if(count>1){
  PVector vec = new PVector(y[0][count]*amp-y[0][count-1]*amp, -width/2-y[1][count]*amp-(-width/2-y[1][count-1]*amp), -0xFF+y[2][count]*amp-(-0xFF+y[2][count-1]*amp));
  vec.normalize();
  camera(y[0][count]*amp-vec.x*300, -width/2-y[1][count]*amp-vec.y*300, -0xFF+y[2][count]*amp-vec.z*300,
    y[0][count]*amp, -width/2-y[1][count]*amp, -0xFF+y[2][count]*amp,
    y[0][count]*amp, -width/2-y[1][count]*amp, -0xFF+y[2][count]*amp);  
  }
  float angle = radians(time) * 0.1f;  
  //rotateY(angle); 

  //----------------- camera angle ops --------------------- 
  if (mousePressed && mouseButton==RIGHT) {
    offsetX = mouseX - clickX;
    offsetY = mouseY - clickY;
    targetRotationX = clickRotationX + offsetY/float(width)*TWO_PI;
    targetRotationY = clickRotationY + offsetX/float(height)*TWO_PI;
  }
  rotationX += (targetRotationX - rotationX)*0.25;
  rotationY += (targetRotationY - rotationY)*0.25;
  rotateX(-rotationX);
  rotateY(rotationY); 
  //---------------------------------------------------------

  
  pushMatrix();
  translate(0, -width/2, -0xFF);  
  scale(1,-1,1);
  for (int i=0; i<count; i++) {

    stroke(255-iro);
    
    line(y[0][i]*amp, y[1][i]*amp, y[2][i]*amp, y[0][i+1]*amp, y[1][i+1]*amp, y[2][i+1]*amp);

    if (xAxis) {
      stroke(0,255,0);
      line(y[0][i]*amp, -width/2, y[2][i]*amp, y[0][i+1]*amp, -width/2, y[2][i+1]*amp);
      stroke(255,0,0);
      line(-width/2, y[1][i]*amp, y[2][i]*amp, -width/2, y[1][i+1]*amp, y[2][i+1]*amp);
      stroke(0,0,255);
      line(y[0][i]*amp, y[1][i]*amp, -width/2+0xFF, y[0][i+1]*amp, y[1][i+1]*amp, -width/2+0xFF);
    }
  }
  popMatrix();

  //current potision
  pushMatrix();
  translate(0, -width/2, -0xFF);
  scale(1,-1,1);
  translate(y[0][count]*amp, y[1][count]*amp, y[2][count]*amp);
  noStroke();
  //fill(0,0,0);
  //fill(255);
  //stroke(30);
  //lights();
  //specular(0, 255, 255);

  specular(200, 200, 200);  //オブジェクトの色を設定
  shininess(5.0);
  sphere(5);
  popMatrix();
  //
  //   
  stroke(255-iro-150);
  strokeWeight(0.4);
  for (int i = -width/2; i <= width / 2; i += 50) {
    line(-width/2, 0, i, width/2, 0, i);  
    line(i, 0, -width/2, i, 0, width/2);
    line(-width/2,i-width/2,-width/2,width/2,i-width/2,-width/2);
    line(i,0,-width/2,i,-width,-width/2);
    line(-width/2,i-width/2,-width/2, -width/2,i-width/2,width/2);
    line(-width/2,0,i, -width/2,-width,i);
  }
  //Axis show
  pushMatrix();
  translate(-width/2,0,-width/2);
  scale(1,-1,1);
  strokeWeight(2);
  stroke(255,0,0);
  line(0,0,0,100,0,0);
  stroke(0,255,0);
  line(0,0,0,0,100,0);
  stroke(0,0,255);
  line(0,0,0,0,0,255);
  strokeWeight(1);
  popMatrix();
  //
  pushMatrix();
  translate(-width/2,0,-width/2);
  fill(255,0,0);
  textSize(30);
  text("y1",120,0,0);
  fill(0,255,0);
  text("y2",0,-120,0);
  fill(0,0,250);
  text("y3",0,0,120);
  popMatrix();
  pushMatrix();  
  camera();  
  hint(DISABLE_DEPTH_TEST);  
  //textMode(SCREEN);  
  // show text 
  fill(255-iro);
  textSize(15);
  //font = createFont("AgencyFB-Bold-24", 20);
  text("y1_0 : "+y[0][0]+" , y2_0 : "+y[1][0]+" , y3_0 : "+y[2][0], 20, 30);
  text("y1 : " + y[0][count], 20, 50);
  text("y2 : " + y[1][count], 20, 70);
  text("y3 : " + y[2][count], 20, 90);

  hint(ENABLE_DEPTH_TEST); 

  popMatrix();  

  --time;
  //t+=dT;
  count+=2;
} 
void mousePressed() {
  clickX = mouseX;
  clickY = mouseY;
  clickRotationX = rotationX;
  clickRotationY = rotationY;
}
void keyPressed() {
  //show graph on X axis
  if (keyCode == UP) {
    xAxis = true;
    //stop();
  }
  if (keyCode == DOWN) {
    xAxis = false;
  }
}