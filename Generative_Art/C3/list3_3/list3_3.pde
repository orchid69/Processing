void setup(){
  size(500,100);
  background(255);
  strokeWeight(5);
  smooth();
  
  stroke(0,30);
  line(20,50,480,50);
  
  stroke(20,50,70);
  int step=1;
  float lastx=-999;
  float lasty=-999;
  float ynoise=random(10);
  float y;
  for(int x=20;x<=480;x+=step){
    float ynoisey=noise(ynoise);
    println(ynoisey);
    y=10+ynoisey*80;
    if(lastx>-999){
      line(x,y,lastx,lasty);
    }
    lastx=x;
    lasty=y;
    ynoise+=0.03;
  }
}
