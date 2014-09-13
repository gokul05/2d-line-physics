//************Color Palette*************
color white = #FFFFFF, red=#FF0000, 
green=#00FF01, cyan=#00FDFF, blue=#0300FF;

//**********Viewer Parameters***********
int windowLength = 800;
int windowWidth = 800;
int frameMemory = 3;                          //Number of frames for which to store mouse position, velocity and acceleration
int fps = 120;

//***********Global Flags***************
boolean enableInteraction = false;
boolean restoreTransforms = false;

//**********Line Parameters*************
float d = 200.0;                                     //Line Length
float mLine = 1.5;                                   //Line Mass
float ILine = (1.0 / 12.0) * mLine * d * d;          //Line Moment of Inertia about centre (1/12 * Mass * d ^ 2) 
float[] centre = new float[2];                       //Line Centres for current & previous Frames
float[] pcentre = new float[2];          
float theta;                                         //Line Angle with Horizontal (in degrees) for current & previous frames
float ptheta;
float[] pHit = new float[2];                         //Contact Point of Mouse with Line
float[] vLine = new float[2];                        //Line Linear Velocity for current and previous frames
float[] pvLine = new float[2];
float wLine;                                         //Line Angular Velocity for current and previous frames
float pwLine;

//*********Mouse Parameters*************
float mMouse = 0.25;                                 //Mouse Mass
int[][] posMouse = new int[frameMemory][2];          //Mouse Position, Velocity and Acceleration Arrays
float[][] vMouse = new float[frameMemory][2];
float[][] accMouse = new float[frameMemory][2];
float[] vAvMouse = new float[2];                     //Mouse Average Velocities in 2 Consecutive Frames
float[] pvAvMouse = new float[2];

//*********Other Properties*************
float maxLinearDrag = 100.0;
float maxRotDrag = 100.0;

//*******Initialize Variables***********
void initializeDynamics()
{
  vAvMouse[0] = 0.0;
  vAvMouse[1] = 0.0;
  pvAvMouse[0] = 0.0;
  pvAvMouse[1] = 0.0;
  
  centre[0] = width / 2;
  centre[1] = height / 2;
  pcentre[0] = centre[0];
  pcentre[1] = centre[1];
    
  vLine[0] = 0.0;
  vLine[1] = 0.0;
  pvLine[0] = 0.0;
  pvLine[1] = 0.0;
  
  wLine = 0.0;
  pwLine = 0.0;
  
  theta = 0.0;
  ptheta = 0.0;
  
  pHit[0] = 0.0;
  pHit[1] = 0.0;   
}

//*******Register Mouse Position********
void registerMousePos()
{
  for (int i = 0; i < frameMemory - 1; i++)
  {
    posMouse[i][0] = posMouse[i + 1][0];
    posMouse[i][1] = posMouse[i + 1][1];    
  }
  posMouse[frameMemory -1][0] = mouseX;
  posMouse[frameMemory -1][1] = mouseY; 
}

//*******Register Mouse Velocity********
void registerMouseVelocity()
{
  for (int i = 0; i < frameMemory - 1; i++)
  {
    vMouse[i][0] = vMouse[i + 1][0];
    vMouse[i][1] = vMouse[i + 1][1];
  }
  vMouse[frameMemory - 1][0] = (mouseX - pmouseX) * float(fps);
  vMouse[frameMemory - 1][1] = (mouseY - pmouseY) * float(fps);  
}

//*******Draw the Line on Screen********
void drawLine(boolean enableInteraction)
{
  if (enableInteraction)
    stroke(green);
  else
    stroke(red);
  strokeWeight(6);
  int Ax = int(centre[0] - (d / 2) * cos(radians(theta)));
  int Ay = int(centre[1] + (d / 2) * sin(radians(theta)));  
  int Bx = int(centre[0] + (d / 2) * cos(radians(theta)));
  int By = int(centre[1] - (d / 2) * sin(radians(theta)));  
    
  line(Ax, Ay, Bx, By); 
  stroke(blue);
  strokeWeight(10);
  point(Ax, Ay);
  point(Bx, By);
}

//******Draw Mouse Path on Screen*******
void drawMousePath()
{
  if (!enableInteraction)
    return;
  
  stroke(cyan);
  strokeWeight(4);
  for (int i = 1; i < frameMemory; i++)
    line(posMouse[i - 1][0], posMouse[i - 1][1], posMouse[i][0], posMouse[i][1]);
}
