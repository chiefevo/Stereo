/* 
DialV1_1 
 Rowbottom 
 Basic class to provide a dial-like experience 
 Issues: 
 Currently manipulatable from 0 to 180 
 Larger numbers do not behave nice around the dial ==> maybe make a setter method to provide functionality to change font size and type 
 Notes: 
 If you want to turn off the color change when interacting with the dial, then make the active color the same as the inactive color 
  
 */ 
 
 
class Dial { 
  PVector pos, settingVec;
 
  float radius = 50, setting = 5, max = 10, min = 0; //setting is the current setting
  float numDivisions;
  boolean active = false, rounded = true, displayTitle = true, displayValue = true, display3D = false;
 
  color fillCol, activeCol = color(0, 180, 200), inactiveCol = color(0, 0, 200);
 
  String title = "";
 
  Dial(float min, float max, float num, boolean rounded) {
    this.min = min;
    this.max = max;
    this.numDivisions = num; 
 
    pos = new PVector(width/8, height/1.9);
    settingVec = new PVector();
    this.rounded = rounded;
 
    fillCol = inactiveCol;
  } 
 
  void setPos(PVector p) {
    pos = p.copy();
  } 
 
  void setTitle(String t) {
    title = t;
  } 
 
  boolean detectDial(PVector mousePos) {
    return (PVector.dist(mousePos, pos) < radius);
  } 
 
  void toggleValueDisplay() { 
    displayValue = !displayValue;
  } 
 
  void toggle3D() { 
    display3D = !display3D;
  } 
 
  void toggleTitleDisplay() { 
    displayTitle = !displayTitle;
  } 
 
  void dialInteraction() { 
    //we only update is the dial is being dragged 
    if (mousePressed) { 
      fillCol = inactiveCol;
      settingVec  = new PVector();
      settingVec.x = mouse.x - pos.x;
      settingVec.y = abs(mouse.y  - pos.y);
      settingVec.normalize();
      settingVec.mult(radius);           
      //get the value between left side and the setting 
      float tempAngle = PVector.angleBetween(new PVector( -1, 0 ), settingVec);
 
      tempAngle = (tempAngle/PI);//makes the scale between 0 and 1 
 
      if (rounded) {
        setting = round(tempAngle * (max-min));
        tempAngle = setting / (max-min);
        settingVec.set(radius*cos(PI*(1f+tempAngle)), radius*sin(PI*(1f+tempAngle))) ;
      } else { 
        setting =  round((tempAngle * (max-min))*10)/10f;
      } 
    } else { 
      fill(0, 0, 200); 
    } 
  } 
 
  void update(PVector mouse) {
    //check whether the user is interacting with this or not 
    active = detectDial(mouse);
    fillCol = inactiveCol;
    if (active) {
      dialInteraction(); 
    } 
    drawDial(); 
  } 
 
  float getSetting(boolean rounded) {
    if (rounded) {
      return round(setting);
    } 
 
    return setting;
  } 
 
  int getSetting() { 
    return (int)setting;
  } 
 
  void drawTitle() { 
   // textSize(radius /2.9);
    text(title, pos.x, pos.y-radius*(1 + 0.5));
  } 
 
  void drawDial() { 
   // strokeWeight(4); 
    textAlign(CENTER, CENTER); 
    //textSize(radius/6);
    if (display3D) {
      fill(225); 
      ellipse(pos.x, pos.y+radius*0.18, radius*2f, radius*2f);
    } 
    fill(200);
    ellipse(pos.x, pos.y, radius*2f, radius*2f);
    /* fill(activeCol, 100); 
     noStroke(); 
     println(settingVec.heading()); 
     arc(pos.x, pos.y, radius*1.6, radius*1.6,  PI, 2*PI+settingVec.heading());  
     */ 
    stroke(0); 
    line(pos.x, pos.y, pos.x + settingVec.x, pos.y + settingVec.y);
 
    float range = max - min;
    int values = 0;
    for (float i = - PI; i <= 0.1; i += PI / numDivisions) {
      // print(values); 
      PVector temp = new PVector((radius*(1 + 0.22))*cos(i), (radius*(1 + 0.22))*sin(i));
 
      int tempVal = (int)(min + range * values /numDivisions  );
 
    fill(0); 
      text(""+(int)(tempVal), temp.x+pos.x, temp.y+pos.y);
      values ++;
    } 
 
    if (displayTitle) {
      drawTitle(); 
    } 
    if (displayValue) {   
      text(setting+"", pos.x, 100);
    } 
  } 
} 
