void setup(){
  size(500,500);
  float xstep=1;
  float lastx=-999;
  float lasty=-999;
  float angle=0;
  float y=height/2;
  for(int x=20;x<=480;x+=xstep){
    float rad=radians(angle);
    y=height/2+(pow(sin(rad),3)*40);
    if(lastx>-999){
      line(x,y,lastx,lasty);
    }
    lastx=x;
    lasty=y;
    angle++;
  }
}
