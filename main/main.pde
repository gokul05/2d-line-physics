/**************************** HEADER ****************************
 Author: Gokul Raghuraman
 Class: CS6491 Fall 2014
 Project number: 1
 Project title: Controlling motion of a 2-D line using the mouse
 Date of submission: 08/28/2014
*****************************************************************/

void setup()
{
  size(windowLength, windowWidth);
  frameRate(fps);
  smooth();
  myFace = loadImage("data/pic.jpg");
  initializeDynamics();
}

void mousePressed()
{
  if (mouseButton == LEFT) 
   enableInteraction = true; 
   
  if (mouseButton == RIGHT)
    restoreTransforms = true;    
}

void mouseReleased()
{
  if (mouseButton == LEFT) 
   enableInteraction = false;
   
  if (mouseButton == RIGHT) 
   restoreTransforms = false;
}

void keyPressed()
{
  if(key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if(key=='~') { filming=!filming; } // filming on/off capture frames into folder FRAMES  
}

void draw()
{
  background(white);
  displayOverlay();
  checkIfFilming();
  
  registerMousePos();
  registerMouseVelocity();
  computeAvMouseVelocity();
  drawMousePath();
  if (enableInteraction)
    detectCollision();
  
  if(restoreTransforms)
    restoreLineTransforms();
 
  updateLineTransforms();
  drawLine(enableInteraction);
  stroke(cyan);
  strokeWeight(6);
  
}
