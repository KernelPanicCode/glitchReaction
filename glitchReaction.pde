import oscP5.*;
import netP5.*;
import processing.video.*;
import glitchP5.*;

Movie m1;
Movie m2;
Movie mov1A, mov1B, mov2A, mov2B, mov3A, mov3B, mov4A, mov4B;     
OscP5 oscP5;
GlitchP5 gP5;

String twe=":)";
int tip=0, emo=4, past_emo=4;
float jum;

//PFont font = createFont("Monofur", 18);
//PFont font = createFont("Arial Black", 16);
PFont font = createFont("Courier New Bold", 16);

void setup(){
  //set canvas
  size(900, 600);
  //size(displayWidth, displayHeight);
  frameRate(20);
  //init handlers
  m1= new Movie (this, "./video/01_alegria.mp4");
  m2 = new Movie (this, "./video/01_alegria.mp4");
  //m1.loop();
  //m2.loop();
  //m2.speed(2);

  //define objetcs for glitch, osc and text
  oscP5 = new OscP5(this, 9009);
  oscP5.plug(this, "isTweetMsg", "/tweet");
  oscP5.plug(this, "isEmotMsg", "/gesto");
  gP5 = new GlitchP5(this);
  textFont(font);
  }


void draw(){
  background( 0 );
  image( m1, 0, 0, width, height-100 );
  
  //select effect according to tip
  //there was a funct here
  blend(tip);
  
  // then write them up
  fill( 0, 0, 0, 170 );
  noStroke();
  rect(0, 500, 900, 560 );

  fill( 220);
  textAlign( CENTER );
  float standardLeading = ( textAscent() + textDescent() ) * 1.0f;
  textLeading( standardLeading );
  text( twe, 450, 520 );
  gP5.run();  
}

void movieEvent( Movie m ){
  m.read();
  } 

void blend(int tip){
  switch(tip) {
    case 1: 
      blend(m2, 0, 0, width, height, 0, 0, width, height, ADD);
      break;
    case 2: 
      blend(m2, 0, 0, width, height, 0, 0, width, height, SUBTRACT);
      break;
    case 4:
      blend(m2, 0, 0, width, height, 0, 0, width, height, EXCLUSION);
      break;
    case 5:
      blend(m2, 0, 0, width, height, 0, 0, width, height, DODGE);
      break;
    case 6:
      blend(m2, 0, 0, width, height, 0, 0, width, height, HARD_LIGHT);
      break;
    case 7:
      blend(m2, 0, 0, width, height, 0, 0, width, height, SCREEN);
      break;
    case 8:
      blend(m2, 0, 0, width, height, 0, 0, width, height, DARKEST);
      break;
    default:
      blend(m2, 0, 0, width, height, 0, 0, width, height, OVERLAY);
      break;
    }
} 


public void isTweetMsg(String msgText, int msgIndex) {
  //first. report
  println("##=>[osc]: tweet");
  println("\t ###: "+msgIndex+", "+msgText);    
  //second. glitch!
  gP5.glitch(int(random(20, 620)), int(random(20, 460)), 1000, 2000, 800, 1000, 4, 0.9, 3, 7);
  //third. update value to global vars
  twe = msgText; 
  tip = msgIndex;
  jum = m1.duration()*random(1);
  m1.jump(jum);
  }

public void isEmotMsg(int emotIndex, int emotForce, String emotName){
//public void isEmotMsg(int emotIndex){
  //first. report
  println("##=>[osc]: gesture");
  println("\t ###: "+emotIndex);
  //select video to show acording to range
  if (emotIndex<4){
    emo = emotIndex;
  }
  if (emo!=past_emo){
    m1.stop();
    m2.stop();
    twe = "";
    tip = 0;
    switch (emo){
      case 0:
        m1= new Movie (this, "./video/01_alegria.mp4");
        m2 = new Movie (this, "./video/01_alegria.mp4");  
        break;
      case 1:
        m1= new Movie (this, "./video/02_ira.mp4");
        m2 = new Movie (this, "./video/02_ira.mp4");  
        break;
      case 2:
        m1= new Movie (this, "./video/03_tristeza.mp4");
        m2 = new Movie (this, "./video/03_tristeza.mp4");  
        break;
      case 3:
        m1= new Movie (this, "./video/04_miedo.mp4");
        m2 = new Movie (this, "./video/04_miedo.mp4");  
        break;
      }
    m1.loop();
    m2.loop();
    m2.speed(2);
    past_emo = emo;
    jum = m1.duration()*random(1);
    m1.jump(jum);
    //image( m1, 0, 0, width, height );
    image( m1, 0, 0, width, height-100 );
    }
  }


/* unplugged incoming osc msgs are fwded to oscEvent handler. */
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.isPlugged()==false) {
    println("##=> [osc]: other");
    println("\t\t### pattern:\t"+theOscMessage.addrPattern());
    println("\t\t### typetag:\t"+theOscMessage.typetag());
    }
  }

