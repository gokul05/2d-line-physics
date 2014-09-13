boolean scribeText=true;
int pictureCounter=0;
PImage myFace; 
String title ="CS6491, Fall 2014, Assignment 1: Controlling motion of a 2-D line using the mouse", name ="Gokul Raghuraman",
       menu="?: (show/hide) help      ~: (start/stop) recording frames for movie",
       guide1 = "Press and hold Left Mouse Button to enable mouse interaction with line.",
       guide2 = "Then swipe mouse against line to intuitively move and rotate line in the desired way.", 
       guide3 = "Press and hold Right Mouse Button to return the line back to initial position.",
       guide = guide1 + '\n' + guide2 + '\n' + guide3;

//*****Capturing Frames for a Movie*****
boolean filming=false;  // when true frames are captured in FRAMES for a movie
int frameCounter=0;     // count of frames captured (used for naming the image files)

void checkIfFilming()
{
 if(filming)
  {
    saveFrame("FRAMES/"+nf(frameCounter++,4)+".png");
    fill(red);
    stroke(red);
    ellipse(width - 20, height - 20, 5, 5);
  }  
}

//********Display Header/Footer*********
void displayOverlay()
{
 displayHeader();
 if(scribeText && !filming) 
   displayFooter();
}

void displayHeader()
{
  fill(0); 
  text(title, 10, 20); 
  text(name, width - 8.0 * name.length(), 20);
  noFill();
  image(myFace, width-myFace.width/2 - 10,25,myFace.width/2,myFace.height/2);  
}

void displayFooter()
{  
  scribeFooter(guide, 3);
  scribeFooter(menu, 0);
}

void scribeFooter(String s, int i)  
{
  fill(0); 
  text(s, 10, height - 10 - i * 20); 
  noFill();
}
