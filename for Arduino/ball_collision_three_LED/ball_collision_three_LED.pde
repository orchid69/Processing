import processing.serial.*;
Serial myPort;
int state = 0;
int numBalls;
Ball[] balls = new Ball[1000];
float spring = 100;
float reduction = 0.99;
float gravity = 0.1;

void setup(){
  myPort=new Serial(this,Serial.list()[0],9600);
  size(1000,600);
  smooth();
  frameRate(30);
}

void draw(){
  myPort.write(state);
  background(0);
  for(int i=0; i<numBalls; i++){
    balls[i].display();
    balls[i].move();
    balls[i].bound();
    balls[i].collide();
  }
}

class Ball{
  float posx, posy;
  float radi;
  float speedx, speedy;
  color clr;
  int idno;
  float mass;
  Ball[] others;
  
  Ball(float x, float y, float r, float sx, float sy, int id, color c, Ball[] o){
    posx = x;
    posy = y;
    radi = r;
    speedx = sx;
    speedy = sy;
    clr = c;
    idno = id;
    mass = radi*radi;
    others = o;
  }
  
  void move(){
    speedx *= reduction;
    speedy *= reduction;
    posx += speedx;
    posy += speedy;
    speedy += gravity;
  }
  
  void bound(){
    if(posy + radi >= height){
      speedy = -speedy;
      posy = height - radi;
    }
    if(posy - radi <= 0){
      speedy = -speedy;
      posy = radi;
    }
    if(posx + radi >= width){
      speedx = -speedx;
      posx = width - radi; 
    }
    if(posx - radi <= 0){
      speedx = -speedx;
      posx = radi;
    }
  }
  
  void collide(){
    for(int i=idno+1; i<numBalls; i++){
      float dx = others[i].posx - posx;
      float dy = others[i].posy - posy;
      float distance = sqrt(dx*dx + dy*dy);
      float critical = others[i].radi + radi;
      if(distance < critical){
        state = state + 1;
        if(state > 3){
          state = 0;
        }
        float force = spring * (critical - distance);
        float theta = atan2(dy, dx);
        float ax = -force * cos(theta) / mass;
        float ay = -force * sin(theta) / mass;
        speedx += ax;
        speedy += ay;
        ax = force * cos(theta) / others[i].mass;
        ay = force * sin(theta) / others[i].mass;
      }
    }
  }
  
  void display(){
    fill(clr);
    ellipse(posx, posy, radi*2, radi*2);
  }
}

void mousePressed(){
  float x = mouseX;
  float y = mouseY;
  float r = random(10, 20);
  float sx = random(-10,10);
  float sy = random(-10,10);
  color c = color(random(0,255), random(0,255), random(255));
  balls[numBalls] = new Ball(x, y, r, sx, sy, numBalls, c, balls);
  numBalls = numBalls + 1;
}
