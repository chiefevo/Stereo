/*
6CDStereo
 Liam Hill
 May 14 2018
 This program acts as a 6-CD stero player with Volume control, Cd selector, wave form, pause/play functionaloity and display the song your listing to 
 */

//Import stuff
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//<== for sound support==>
Minim minim; 
AudioPlayer[] players; 
AudioMetaData meta;

//<==for the dial support==>
Dial dial;

//<==for volume control support==>
VolumeControl volControl;

//Global variables
//background image 
PImage background;

// CD Button Varibles
PVector[] cdButtonPos = new PVector [6];
PVector cdButtonSize = new PVector(50, 50);
PVector cdButtonGap = new PVector(65, 70/2);

//Screen Varibles 
PVector screenSize = new PVector(500, 150);
String title = "";


//control Button varibles
PVector[] conButtonPos = new PVector [3];
PVector conButtonSize = new PVector(125, 30);
PVector conButtonGap = new PVector(150, 70/2);

//mouse PVector
PVector mouse = new PVector(mouseX, mouseY);

//what song is playing
int mm; 

void setup() {
  size(1000, 250);
  strokeWeight(4);
  rectMode(CENTER); 
  textAlign(CENTER, CENTER);
  textSize(14);
  init();
}

//used to set up anything that needs to be set up
void init() {
  background = loadImage("background.jpg");
  background.resize(width, height*4);

  //<== for sound support==>  
  minim = new Minim(this); //make the minim object
  players = new AudioPlayer[6];

  //loading the files individually rather than with a for loop, just because there is just a couple in my example
  for (int i = 0; i<6; i++) {
    players[i] = minim.loadFile("SoundTrack"+i+".mp3");
  }


  //<==for the dial support==>
  mouse = new PVector(); 
  dial = new Dial(0, 10, 10, true);
  dial.setTitle("Volume");

  while (players[1] == null) {
  }
  //<==for volume control support==>
  volControl = new VolumeControl(players, dial); //<== need to send in the array of audio players and the dial
}




void info() {

  strokeWeight(3);
  fill(255);
  rect(width/2, height/10, 500, 30);
  fill(0);
  if (players[mm].isPlaying()) { // if a song is playing grab the title

    meta = players[mm].getMetaData(); 
    title = meta.title();
  }
  text("" + title, width/2, height/10); // display the title
  fill(255);
}


boolean buttonOver (PVector pos1, PVector pos2, PVector siz) { // detect if PVector overlap
  if (abs(pos1.x-pos2.x)< siz.x/2 && abs(pos1.y-pos2.y)< siz.y/2) {
    return true;
  } else {
    return false;
  }
}


void cdButtons() {

  strokeWeight(3);
  for (int i = 0; i < 6; i++) { // create the locations for the cd buttons 
    if (i < 3) {
      cdButtonPos[i] = new PVector(i*cdButtonGap.x + width/1.25, height/2-cdButtonGap.y);
    } else {
      cdButtonPos[i] = new PVector(i*cdButtonGap.x+ width/1.25-cdButtonGap.x*3, height/2+ cdButtonGap.y);
    }

    rect(cdButtonPos[i].x, cdButtonPos[i].y, cdButtonSize.x, cdButtonSize.y); //draw buttons 
    fill(0);
    text(i+1, cdButtonPos[i].x, cdButtonPos[i].y);// draw numbers on buttons
    fill(255);
  }

  // Draws the box a title of cd buttons 
  fill(255);
  rect(cdButtonPos[1].x, cdButtonPos[1].y-50, 90, 25);
  fill(0);

  text("CD Selctor", cdButtonPos[1].x, cdButtonPos[1].y-50);   
  fill(255);
}





void display() {
  rect(width/2, height/2, screenSize.x, screenSize.y);  // create display box 

  for (int i =  int(screenSize.x/2); i < players[mm].bufferSize() - int(screenSize.x/2)-25; i++)// dont go past the buffer 
  {
    line(i, height/2 + players[mm].left.get(i)*75, i+1, height/2 + players[mm].left.get(i+1)*75); // display left channel on a line 
    float posx = map(players[mm].position(), 0, players[mm].length(), 0, screenSize.x); // map the postion of the song current time and total tome to screen
    line (posx + screenSize.x/2, screenSize.y/3, posx + screenSize.x/2, screenSize.y*1.33); // diplay the completion bar
  }
}





void conButtons() {
  for (int i = 0; i <3; i++) {
    conButtonPos[i] = new PVector(i*conButtonGap.x + width/2- conButtonGap.x, height/1.115);// create loction for control button (pause/play/skip/back)
    rect(conButtonPos[i].x, conButtonPos[i].y, conButtonSize.x, conButtonSize.y);// draw buttons
  }
  fill(0);

  //add text to buttons
  text("Previous CD", conButtonPos[0].x, conButtonPos[0].y);
  text("Pause/Play", conButtonPos[1].x, conButtonPos[1].y);
  text("Next CD", conButtonPos[2].x, conButtonPos[2].y);

  fill(255);
}

void stopPlaying() {// stop playing music function
  for (int i = 0; i< 6; i++) {
    players[i].pause();
    players[i].rewind();
  } 
  println("pause all" );
}


void startPlaying() {
  players[mm].play();
  println("playing " + mm);
}
void mousePressed() {
  for (int i = 0; i < 6; i++) {     // when the mouse is presed and over one of the cd buttons  
    if ( buttonOver(mouse, cdButtonPos[i], cdButtonSize)) { //set the current song to the button you have clicked
      mm = i;
      stopPlaying();
      startPlaying();
    }
  }

  if (buttonOver(mouse, conButtonPos[0], conButtonSize)) {//previous cd
    mm = constrain(mm-1, 0, 5);
    stopPlaying();
    startPlaying();
    ;
  }
  if (buttonOver(mouse, conButtonPos[1], conButtonSize)) { // pause/ play toggle 

    if (players[mm].isPlaying()) {
      players[mm].pause();
      println("pause " + mm);
    } else {
      players[mm].play();
      println("play " + mm);
    }
  }


  if (buttonOver(mouse, conButtonPos[2], conButtonSize)) { //next cd 
    mm = constrain(mm+1, 0, 5);
    stopPlaying();
    startPlaying();
  }
}

void volControl() { //volume control dial
  rect(width/8, height/2, 150, 150);
  mouse = new PVector(mouseX, mouseY);
  dial.update(mouse);
  volControl.update();
}


//the draw function
void draw() {
  image(background, 0, 0);
  info();  
  cdButtons();
  display();
  conButtons();
  volControl();
}
