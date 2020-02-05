class Central{
  float x, y; //coordinates
  
  Central(float xcoord, float ycoord){
    x = xcoord;
    y = ycoord;
  }
  
  Central(){
    x = 0;
    y = 0;
  }
  
  void display(){
    //ellipse(x,y,cdiameter, cdiameter);
    textSize(sqrt(width*height)/35);
    text("C", x, y); 
    fill(255, 255, 255);
  }
  
  void move(float delx, float dely){
    //move away from mean of nearest neighbors by distance inversely proportional to distance to mean
    if (delx > 1){ 
      delx = 1;
    }
    if (dely > 1){ 
      dely = 1;
    }
    x = x+delx;
    y = y+dely;
  }
 }
