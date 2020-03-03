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
  
  void move_constrained(float delx, float dely){
    if (delx > 1){ 
      delx = 1;
    }
    if (delx < -1){
      delx = -1;
    }
    if (dely > 1){ 
      dely = 1;
    }
    if (dely < -1){
      dely = -1;
    }
    x += delx;
    y += dely;
  }
  
  void move(float delx, float dely){
    x += delx;
    y += dely;
  }
  
 }
