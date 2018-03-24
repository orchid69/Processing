import processing.serial.*;  

PFont font;  
long  time;

int offsetX=0, offsetY=0, clickX=0, clickY=0;
float clickRotationX=0, clickRotationY=0, targetRotationX=0, targetRotationY=0;
float rotationX=0, rotationY=0;

int iro=0;
boolean drawing = true;
boolean drawing_flag = true; 
boolean xAxis = false;
boolean xAxis_flag = false;
boolean yAxis = false;
boolean yAxis_flag = false;
boolean zAxis = false;
boolean zAxis_flag = false;

PVector perspec;

float sigma = 10;
float b = 8.0 / 3.0;
float r = 28;
float dT = 0.001;
float t=0;
float t_max=10;

float amp;
int count=0;
int delta = 1; //speed

PVector y0 = new PVector(1, 0, 20);
float y[][] = new float[3][(int)(t_max/dT)+100];
/*
PVector yy0 = new PVector(1+pow(10, -2), 0, 20);
float yy[][] = new float[3][(int)(t_max/dT)+100];

PVector yyy0 = new PVector(1+pow(10, -3), 0, 20);
float yyy[][] = new float[3][(int)(t_max/dT)+100];
*/
PVector initY;
ArrayList<PVector> list = new ArrayList<PVector>();

void get_y_prime(float y[], float k[], float h, float y_prime[]) {
  float temp[] = new float[3];
  for (int i = 0; i < 3; i++) {
    temp[i] = y[i] + k[i] * h;
  }
  y_prime[0] = sigma*(temp[1] - temp[0]);
  y_prime[1] = r*temp[0] - temp[1] - temp[0] * temp[2];
  y_prime[2] = temp[0] * temp[1] - b*temp[2];
}

PVector get_next_y(PVector initY) {
  float y_0[] = { initY.x, initY.y, initY.z };//[y1,y2,y3]
  float y_1[] = new float[3];
  //int cnt=0;
  //for (float t = 0; t<t_max; t += dT) {
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
    }
    /*
    for (int i = 0; i < 3; i++) {
      y_0[i] = y_1[i];
    }
    */
    PVector next = new PVector(y_1[0], y_1[1], y_1[2]);
    return next;
}

void setup()  
{  
  size(1000, 650, P3D);  
  //font = createFont("AgencyFB-Bold-24", 20);  
  perspec = new PVector(0, -width, width);
  amp = width/50;
  for (int i = 0; i <= width; i += 200) {
    for(int j=0;j<width; j+=200){
      for(int k=-width/2;k<width/2;k+=200){
        list.add( new PVector(k/amp, (j-width/2)/amp, i/amp));
      }
    }
  }
}  

void draw()  
{  
  background(iro);
  ambientLight(100, 100, 100);    //環境光を当てる
  lightSpecular(255, 255, 255);    //光の鏡面反射色（ハイライト）を設定
  directionalLight(255, 255, 255, 1, 1, 1);    //指向性ライトを設定
  //lights();
  //------------------speed up or down --------------------------
  if (keyPressed && key == 'u') {
    if (delta < 300) delta +=1;
  }
  if (keyPressed && key == 'd') {
    if (delta > -100) delta -=1;
  }
  //-------------------------------------------------------------

  //------------------perspective move --------------------------
  PVector target = new PVector(y0.x-perspec.x, y0.y-perspec.y, y0.z-perspec.z);
  target.normalize();
  if (keyPressed && keyCode == UP) {
    perspec.x+=target.x*10;
    perspec.y+=target.y*10;
    perspec.z+=target.z*10;
  } else if (keyPressed && keyCode == DOWN) {
    perspec.x-=target.x*10;
    perspec.y-=target.y*10;
    perspec.z-=target.z*10;
  }
  camera(perspec.x, perspec.y, perspec.z, 
    0, -width/2, 0, 
    0, 1, 0);  
  //--------------------------------------------------------------
  float angle = radians(time) * 0.1f;  
  rotateY(angle); 

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
  
  //---------------- Locus draw -----------------------------
  /*
  float test[][];
  for (int j=0; j<list.size(); j++) {
    test = list.get(j);
    pushMatrix();
    translate(0, -width/2, -width/2);  
    scale(1, -1, 1);
    for (int i=0; i<count; i++) {
      if (drawing) {
        stroke(255, 0, 0);
        line(test[0][i]*amp, test[1][i]*amp, test[2][i]*amp, test[0][i+1]*amp, test[1][i+1]*amp, test[2][i+1]*amp);
      } else {
        int alpha = 255 - (count - i)/4;
        if (alpha > 0) {      
          stroke(255, 0, 0, alpha);
          //line(test[0][i]*amp, test[1][i]*amp, test[2][i]*amp, test[0][i+1]*amp, test[1][i+1]*amp, test[2][i+1]*amp);
        }
      }
      if (xAxis) {
        stroke(255, 0, 0);
        line(-width/2, test[1][i]*amp, test[2][i]*amp, -width/2, test[1][i+1]*amp, test[2][i+1]*amp);
      }
      if (yAxis) {
        stroke(255, 0, 0);
        line(test[0][i]*amp, -width/2, test[2][i]*amp, test[0][i+1]*amp, -width/2, test[2][i+1]*amp);
      }
      if (zAxis) {
        stroke(255, 0, 0);
        line(test[0][i]*amp, test[1][i]*amp, 0, test[0][i+1]*amp, test[1][i+1]*amp, 0);
      }
    }
    popMatrix();
  }
  */
  //-----------------------------------------------------------

  //----------------current potision ------------------------------
  for (int j=0; j<list.size(); j++) {
    PVector pos = list.get(j);
    pushMatrix();
    translate(0, -width/2, -width/2);
    scale(1, -1, 1);
    translate(pos.x*amp, pos.y*amp, pos.z*amp);
    noStroke();
    if(j%2==0) fill(255, 255, 255);
    else fill(255,255,0);
    specular(255, 0, 0);
    shininess(5.0);
    sphere(5);
    popMatrix();
    
    list.set(j, get_next_y(pos));
  }
  //-----------------------------------------------------------
  //   

  //----------------------- scale show ---------------------------------
  strokeWeight(0.4);
  int cnt=0;
  for (int i = -width/2; i <= width / 2; i += 50) {
    if (cnt%2==0) {
      lights();
      fill(255, 255, 255);
      stroke(55);
      textSize(30);
      textAlign(CENTER);
      pushMatrix();
      translate(-width/2, 0, i);
      rotateX(-rotationX);
      rotateY(-rotationY);
      rotateY(-angle);
      text(String.format("%.1f", (width/2+i)/amp), 0, 0, 0);
      popMatrix();

      pushMatrix();
      //fill(0,255,0);
      translate(-width/2, -width/2+i, -width/2);
      rotateX(-rotationX);
      rotateY(-rotationY);
      rotateY(-angle);
      text(String.format("%.1f", -i/amp), 0, 0, 0);
      popMatrix();

      pushMatrix();
      //fill(255,0,0);
      translate(i, 0, -width/2);
      rotateX(-rotationX);
      rotateY(-rotationY);
      rotateY(-angle);
      text(String.format("%.1f", i/amp), 0, 0, 0);
      popMatrix();
    }
    stroke(255-iro-150);
    line(-width/2, 0, i, width/2, 0, i);  
    line(i, 0, -width/2, i, 0, width/2);
    line(-width/2, i-width/2, -width/2, width/2, i-width/2, -width/2);
    line(i, 0, -width/2, i, -width, -width/2);
    line(-width/2, i-width/2, -width/2, -width/2, i-width/2, width/2);
    line(-width/2, 0, i, -width/2, -width, i);
    cnt++;
  }
  //---------------------------------------------------------------------
  //Axis show
  pushMatrix();
  translate(-width/2, 0, -width/2);
  scale(1, -1, 1);
  strokeWeight(2);
  stroke(255, 0, 0);
  line(0, 0, 0, 100, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 100, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 255);
  strokeWeight(1);
  popMatrix();
  //
  pushMatrix();
  translate(-width/2, 0, -width/2);
  fill(255, 0, 0);
  textSize(30);
  text("y1", 120, 0, 0);
  fill(0, 255, 0);
  text("y2", 0, -120, 0);
  fill(0, 0, 250);
  text("y3", 0, 0, 120);
  popMatrix();

  pushMatrix();
  camera();  
  hint(DISABLE_DEPTH_TEST);  
  //textMode(SCREEN);  
  // show text 
  fill(255);
  textSize(12);
  textAlign(LEFT);
  text("y1_0 : "+String.format("%.1f", y[0][0])+" , y2_0 : "+String.format("%.1f", y[1][0])+" , y3_0 : "+String.format("%.1f", y[2][0]), 20, 30);
  text("y1 : " + String.format("%.1f", y[0][count]), 20, 50);
  text("y2 : " + String.format("%.1f", y[1][count]), 20, 70);
  text("y3 : " + String.format("%.1f", y[2][count]), 20, 90);
  text("t : " + String.format("%.2f", count*dT), 20, 110);
  text("speed : " + String.format("%d", delta), 20, 130);

  hint(ENABLE_DEPTH_TEST); 

  popMatrix();  

  --time;
  if (count+delta <= (int)(t_max/dT)-delta && count+delta > 0) count+=delta;
  if(t+dT < t_max) t+=dT;
} 
void mousePressed() {
  clickX = mouseX;
  clickY = mouseY;
  clickRotationX = rotationX;
  clickRotationY = rotationY;
}
void keyPressed() {
  //show graph on X axis
  if (key == 'x') {
    if (xAxis_flag == false) {
      xAxis = true;
      xAxis_flag = true;
    } else {
      xAxis = false;
      xAxis_flag = false;
    }
  }

  if (key == 'y') {
    if (yAxis_flag == false) {
      yAxis = true;
      yAxis_flag = true;
    } else {
      yAxis = false;
      yAxis_flag = false;
    }
  }

  if (key == 'z') {
    if (zAxis_flag == false) {
      zAxis = true;
      zAxis_flag = true;
    } else {
      zAxis = false;
      zAxis_flag = false;
    }
  }

  if (key == 'w') {
    if (drawing_flag == false) {
      drawing = true;
      drawing_flag = true;
    } else {
      drawing = false;
      drawing_flag = false;
    }
  }
}