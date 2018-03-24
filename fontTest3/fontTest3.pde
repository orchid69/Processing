PFont myFont1, myFont2;
String[] msg = new String[]
  {"A problem has been detected and windows has been shut down to prevent damage to your computer.\n", 
  "The problem seems to be caused by the following file: BSODMKR.SYS\n", 
  "PAGE_FAULT_IT_NONPAGE_AREA\n", 
  "If this is the first time you've seen this stop error screen,\nrestart your computer. If this screen appears again, follow\nthese steps:\n", 

  "Check to make sure any new hardware or software is properly installed.\nIf this is a new installation, ask your hardware or software manufacturer\nfor any windows updates you might need.\n", 
  "If problems continue, disable or remove any newly installed hardware\nor software. Disable BIOS memory options such as caching or shadowing.\nIf you need to use safe Mode to remove or disable components, restart\nyour computer, press F8 to select Advanced Startup Options, and then\nselect Safe Mode.\n", 
  "Technical information:\n", 
  "*** STOP: 0x00000074 (0x0000002, 0x84567BA8,0x00000002, 0x000009A)\n", 
  "Collecting data for crash dump", 
  ".", 
  ".", 
  ".", 
  ".", 
  "Failed.\n", 
  "Initializing disk for crash dump", 
  ".", 
  ".", 
  ".", 
  ".", 
  "Failed.\n", 
  "Beginning dump of physical memory", 
  ".", 
  ".", 
  ".", 
  ".", 
  "Failed.\n", 
  "Dumping physical memory to disk:   ", 
  "70", 
  "endflag"
};
String done = new String("Done.");
String msgA = new String("");
;
boolean endFlag = false;

void setup() {
  fullScreen();
  myFont1 = loadFont("PxPlus_IBM_VGA9-12.vlw");
  myFont2 = loadFont("PxPlus_TandyNew_225-2y-20.vlw");
  //background(0, 0, 200);
  background(0);
  for (int i = 0; i<msg.length; i++) {
    msgA += "\n" + msg[i];
  }
}

float heightPos = 20;
float widthPos = 20;
int count = 0;
int start = 0;
int end = 1;
int wait = 2;
int cnt = 0;
boolean cntFlag = true;
void draw() {
  background(0, 0, 200);
  textFont(myFont2);
  fill(205);
  String temp = msgA.substring(start, end);
  if (msgA.substring(end, end+2).equals("\n\n")) {
    if (cntFlag) {
      cntFlag = false;
      cnt = 2;
    }
    wait = 120;
  } else wait = 2;
  if (cnt%wait == 1) {
    if (msgA.substring(end-1, end).equals(" ")) delay(0);
    else delay(0);
    end++;
    cntFlag = true;
  }
  if (frameCount%60 < 30) temp+= "|";
  else temp += " ";
  text(temp, widthPos, heightPos);
  cnt++;
  /*
  if (!endFlag) {
   String temp = msg[frameCount-1];
   text(temp, widthPos, heightPos);
   if (msg[frameCount].equals("endflag")) endFlag = true;
   String[][] m = matchAll(temp, "\n");
   String[][] mm = matchAll(msg[frameCount], "\\.");
   if (m != null) {
   widthPos = 20;
   heightPos += 20*(m.length+1);
   } else if (frameCount > 1) {
   if ((!msg[frameCount-1].equals(".")) && msg[frameCount].equals(".")) {
   widthPos = msg[frameCount-1].length()*7.7;
   } else if (msg[frameCount-1].equals(".") && msg[frameCount].equals(".")) {
   widthPos += 7.7;
   } else {
   widthPos = 20;
   heightPos+=20;
   }
   }
   
   if(msg[frameCount-1].equals(".")){
   delay(1000);
   }
   else delay((int)random(500,1000));
   }
   */
}

void keyPressed() {
  if (key == 'q') {
    exit();
  }
}