//MTS p145
import ddf.minim.*;

Minim minim;
AudioPlayer player;

void setup(){
  minim = new Minim(this);
  player = minim.loadFile("drum1_hat.wav");
  player.play();
}

void draw(){}

void stop(){
  player.close();
  minim.stop();
  super.stop();
}
