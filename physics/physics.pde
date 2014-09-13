//****Compute Average Mouse Velocity****
void computeAvMouseVelocity()
{
  float[] speedTotal = new float[2];
  for (int i = 0; i < frameMemory; i++)
  {
    speedTotal[0] += vMouse[i][0];
    speedTotal[1] += vMouse[i][1];
  }
  vAvMouse[0] = speedTotal[0] / float(frameMemory);
  vAvMouse[1] = speedTotal[1] / float(frameMemory);
}

//********Update Line Transforms********
void updateLineTransforms()
{  
  float timeElapsed = 1.0 / float(fps);
  
  //Store the line's current centre position pcentre for next frame
  pcentre[0] = centre[0];
  pcentre[1] = centre[1];  
  
  float[] accLine = new float[2];
  float angAccLine;  
  accLine[0] = (vLine[0] - pvLine[0]) * float(fps);
  accLine[1] = (vLine[1] - pvLine[1]) * float(fps);  
  angAccLine = (wLine - pwLine) * float(fps);
  
  //Store the line's current frame velocity pvLine for next frame
  pvLine[0] = vLine[0];
  pvLine[1] = vLine[1];
  
  //Store the line's current frame angular velocity pwLine for next frame 
  pwLine = wLine;
  
  //Translate line
  centre[0] += (vLine[0] * timeElapsed);
  centre[1] += (vLine[1] * timeElapsed); 
  
  //Rotate Line
  theta += (wLine * timeElapsed); 
  if (theta < 0)
      theta += 360;
  if (int(theta) % 90 == 0)
    {
      //To get rid of flipping   
      theta += 0.5;
    }
  
  //De-accelerate linear & angular motion
  float[] linearDrag = {maxLinearDrag, maxLinearDrag};
  float[] linearDragDir = new float[2];
  
  float rotDrag = maxRotDrag;
  float rotDragDir;
  
  //Update Linear and Angular Velocities every frame    
  if (vLine[0] != 0.0 || vLine[1] != 0.0)
  {    
    if (abs(accLine[0]) < maxLinearDrag)
      linearDrag[0] = accLine[0];      
    if (abs(accLine[1]) < maxLinearDrag)
      linearDrag[1] = accLine[1];        
    
    linearDragDir[0] = -vLine[0] / abs(vLine[0]);
    linearDragDir[1] = -vLine[1] / abs(vLine[1]);
  
    vLine[0] = vLine[0] + linearDragDir[0] * linearDrag[0] * timeElapsed;
    vLine[1] = vLine[1] + linearDragDir[1] * linearDrag[1] * timeElapsed;
    
    if (pvLine[0] <= 0.0)
    {
      if (vLine[0] >= 0.0)
      {
        vLine[0] = 0.0;
        vLine[1] = 0.0;
        wLine = 0.0;
      }     
    }
    else if (vLine[0] <= 0.0)
    {
      vLine[0] = 0.0;
      vLine[1] = 0.0;
      wLine = 0.0;
    }    
    
    if (pvLine[1] <= 0.0)
    {
      if (vLine[1] >= 0.0)
      {
        vLine[0] = 0.0;
        vLine[1] = 0.0;
        wLine = 0.0;
      }     
    }
    else if (vLine[1] <= 0.0)
    {
      vLine[0] = 0.0;
      vLine[1] = 0.0;
      wLine = 0.0;
    }    
  }
  
  if (wLine != 0)
  {
    if (abs(angAccLine) < maxRotDrag)
      rotDrag = angAccLine;
    rotDragDir = -wLine / abs(wLine);    
    wLine = wLine + rotDragDir * rotDrag * timeElapsed;
    
    if (pwLine <= 0.0)
    {
      if (wLine >= 0.0)
      {
        vLine[0] = 0.0;
        vLine[1] = 0.0;
        wLine = 0.0;
      }
    }
    else if (wLine <= 0.0)
    {
      vLine[0] = 0.0;
      vLine[1] = 0.0;
      wLine = 0.0;
    }    
  }   
}

//**Check if lines AB and XY intersect**
boolean linesIntersect(float[] A, float[] B, float[] X, float[] Y)
{
  boolean intersect = false;  
  float xInt, yInt;  
  float slopeAB = (B[1] - A[1]) / (B[0] - A[0]);
  float slopeXY = (Y[1] - X[1]) / (Y[0] - X[0]);  
  float evalPos1 = X[1] - A[1] - slopeAB * (X[0] - A[0]);
  float evalPos2 = Y[1] - A[1] - slopeAB * (X[1] - A[0]);
  
  if (evalPos1 < 0)
  {
    if (evalPos2 < 0)
      return intersect;
  }
  else if (evalPos2 > 0)
    return intersect;
    
  if (slopeAB != slopeXY)
  {
    xInt = (X[1] - A[1]) + slopeAB * A[0] - slopeXY * X[0] / (slopeAB - slopeXY);
    yInt = (slopeAB * X[1] - slopeXY * A[1] - slopeAB * slopeXY * (A[0] - X[0])) / (slopeAB - slopeXY);
    if (X[0] == Y[0])
    {
      xInt = X[0];
      yInt = A[1] + slopeAB * (X[0] - A[0]);
    }
    if (((xInt - A[0]) * (xInt - B[0])) <= 0 && ((yInt - A[1]) * (yInt - B[1]) <= 0))
    {
      intersect = true;
      pHit[0] = xInt;
      pHit[1] = yInt;      
    }
  }
 return intersect; 
}

//*****Check if line pApB <-> AB crosses point X*****
boolean lineCrossesPoint(float[] pA, float[] pB, float[] A, float[] B, float[] X)
{
  boolean crossed = false;
  float evalPos1 = (B[0] - A[0]) * (X[1] - A[1]) - (B[1] -  A[1]) * (X[0] - A[0]);
  float evalPos2 = (pB[0] - pA[0]) * (X[1] - pA[1]) - (pB[1] - pA[1]) * (X[0] - pA[0]);
  
  boolean pointWithinBounds = false;
  if (X[0] < max(max(pA[0], A[0]), max(pB[0], B[0])) && X[0] > min(min(pA[0], A[0]), min(pB[0], B[0])) && 
      X[1] < max(max(pA[1], A[1]), max(pB[1], B[1])) && X[1] > min(min(pA[1], A[1]), min(pB[1], B[1])))
    pointWithinBounds = true;
  
  if (!pointWithinBounds)
    return crossed;
    
  if (evalPos1 > 0)
  {
    if (evalPos2 < 0)
      crossed = true;
  }
  else if (evalPos2 > 0)
    crossed = true;    
  return crossed;
}

//***Check if line AB crosses line (x1,y2)-(x2,y2)***
boolean isLineCrossed(int x1, int y1, int x2, int y2)
{    
  boolean crossed = false;
  float[] pointA0 = new float[2];
  float[] pointB0 = new float[2];
  
  float[] pointA1 = new float[2];
  float[] pointB1 = new float[2];
  
  float[] pointX = {x1, y1};
  float[] pointY = {x2, y2};
   
  pointA0[0] = centre[0] - (d / 2) * cos(radians(theta));
  pointA0[1] = centre[1] + (d / 2) * sin(radians(theta));  
  pointB0[0] = centre[0] + (d / 2) * cos(radians(theta));
  pointB0[1] = centre[1] - (d / 2) * sin(radians(theta));
  
  pointA1[0] = pcentre[0] - (d / 2) * cos(radians(ptheta));
  pointA1[1] = pcentre[1] + (d / 2) * sin(radians(ptheta));  
  pointB1[0] = pcentre[0] + (d / 2) * cos(radians(ptheta));
  pointB1[1] = pcentre[1] - (d / 2) * sin(radians(ptheta));
    
  if (vAvMouse[0] == 0.0 && vAvMouse[1] == 0.0)
    crossed = lineCrossesPoint(pointA0, pointB0, pointA1, pointB1, pointY);  
  else
    crossed = linesIntersect(pointA1, pointB1, pointX, pointY);  
  return crossed;  
}

//********Detect Collision between mouse and line********
void detectCollision()
{    
  boolean collision = isLineCrossed(pmouseX, pmouseY, mouseX, mouseY);  
  if (collision)
  {
    conserveSystemLinearMomentum();
    conserveSystemAngularMomentum();
    cheatLineRebound();    
  }
}

//********Determine Angular Velocity Direction********
int getAngularVelocityDir()
{
  int dir = 0;  
  if ((pHit[0] - centre[0]) * vAvMouse[1] < 0)
    dir = 1;
  else
    dir = -1;  
  return dir;
}

//********Conserve System Linear Momentum********
void conserveSystemLinearMomentum()
{
  /*  
  mLine * vLine<before> + mMouse * vMouse<before> = mLine * vLine<after> + mMouse * vMouse<after>
  Assumption: vMouse<after> = 0.0 (mouse comes to a stop after collision)  
  */
  //Conserve Momentum Along X--Axis-->
  vLine[0] = (mMouse * vAvMouse[0] + mLine * vLine[0]) / mLine;
  
  //Conserve Momentum Along Y--Axis-->
  vLine[1] = (mMouse * vAvMouse[1] + mLine * vLine[1]) / mLine;
}

//********Conserve System Angular Momentum********
void conserveSystemAngularMomentum()
{
  /*
  Iw = mvr + I'w'
  Assumption: No external torque acts during collision
  */
  float[] hitRadius = new float[2];  
  hitRadius[0] = pHit[0] - centre[0];
  hitRadius[1] = pHit[1] - centre[1];  
  float r = sqrt(pow(hitRadius[0], 2) + pow(hitRadius[1], 2));
  float v = sqrt(pow(vAvMouse[0], 2) + pow(vAvMouse[1], 2));  
  int dir = getAngularVelocityDir();  
  pwLine = wLine;
  wLine = dir * (20 * mMouse * v * r + wLine * ILine ) / ILine;   
}

void cheatLineRebound()
{
  /*
  Realism Cheat : If mouse hits the line opposite to direction of motion, then we want 
  the line to bounce back. But if this equation simply reduces the velocity, then 
  reverse the signs of velocity.
  */  
  boolean vxUnchanged = false;
  boolean vyUnchanged = false;
  if (abs(vLine[0]) <= abs(pvLine[0]))
  {
   if ((pvLine[0] > 0 && vLine[0] > 0) || (pvLine[0] < 0 && vLine[0] < 0))
     vxUnchanged = true;
  }
  if (abs(vLine[1]) <= abs(pvLine[1]))
  {
    if ((pvLine[1] > 0 && vLine[1] > 0) || (pvLine[1] < 0 && vLine[1] < 0))
      vyUnchanged = true;
  }  
  if (vxUnchanged && vyUnchanged)
  {
    vLine[0] = -vLine[0];
    vLine[1] = -vLine[1];    
  }  
}

//********Return Line to Origin********
void restoreLineTransforms()
{
  float[] destCentre = {width / 2, height / 2};
  float destTheta = 0.0;  
  int travelFrames = 2;  
  pvLine[0] = vLine[0];
  pvLine[1] = vLine[1];
  pwLine = wLine;
    
  vLine[0] = 10 * (destCentre[0] - centre[0]) / float(travelFrames);
  vLine[1] = 10 * (destCentre[1] - centre[1]) / float(travelFrames);      
  wLine = 10 * (destTheta - theta) / float(travelFrames); 
}
