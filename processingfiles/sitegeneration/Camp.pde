class Camp{
  int number; //campsite number
  float x, y; //coordinates
  int guest; //0 if not guest, 1 if guest
  int numneighbors; //number of nearest neighbors to keep track of
  int[] neighbors; //list of nearest neighbors
  
  Camp(int n, float xcoord, float ycoord, int isguest, int numn){
    number = n;
    x = xcoord;
    y = ycoord;
    guest = isguest;
    numneighbors = numn;
    neighbors = new int[numn];
  }

  //get an array of the nearest 3 neighbors (ordered farthest to closest)
  int[] get_nearest_n_neighbors(int n, Camp[] campgrounds){
    float[] leastdist = new float[n];
    int[] neighbors = new int[n];
    float tempdist = 0;
    
    for (int s=0; s<n; s++){
      leastdist[s] = width*height;
    }
    
    //iterate through all camps except self
    for (Camp i: campgrounds){
      if (i.number != number){
        tempdist = distance(i.x,i.y,x,y);
        for (int s = 0; s < n; s++){
          if (tempdist < leastdist[s]){
            leastdist[s] = tempdist;
            neighbors[s] = i.number;
            //arrayCopy(reorder_least(leastdist),leastdist);
            reorder_least(leastdist, neighbors, n);
            break;
          }
        }        
      }
    }
    return neighbors;
  }
  
/*  float[] reorder_least(float[] leastdist){ //change to order greatest to least
    float tempdist = 0;
    print("reorder "+ leastdist[0] + " " + leastdist[1] + " " + leastdist[2] + "-> ");
    if (leastdist[0] < leastdist[1]){
      tempdist = leastdist[0];
      leastdist[0] = leastdist[1];
      leastdist[1] = tempdist;
    }
    if (leastdist[1] < leastdist[2]){
      tempdist = leastdist[1];
      leastdist[1] = leastdist[2];
      leastdist[2] = tempdist;
    }
    println(leastdist[0] + " " + leastdist[1] + " " + leastdist[2]);
    return leastdist;
  }*/
  
  void reorder_least(float[] leastdist, int[] neighborarray, int numneighbors){ //change to order greatest to least
    float tempdist = 0;
    int tempindex = 0;
    
    //print("reorder "+ leastdist[0] + " " + leastdist[1] + " " + leastdist[2] + "-> ");
    for (int i = 0; i < numneighbors-1; i++)
    {
      if (leastdist[i] < leastdist[i+1]){
        tempdist = leastdist[i];
        leastdist[i] = leastdist[i+1];
        leastdist[i+1] = tempdist;
        tempindex = neighborarray[i];
        neighborarray[i] = neighborarray[i+1];
        neighborarray[i+1] = tempindex;
      }
    }
    //println(leastdist[0] + " " + leastdist[1] + " " + leastdist[2]);
  }
  
  float distance(float x1, float y1, float x2, float y2){
    return sqrt(pow((x2-x1),2)+pow((y2-y1),2));
  }
   
   
  void display(){
    //ellipse(x,y,cdiameter, cdiameter);
    textSize(sqrt(width*height)/70);
    text(number, x, y); 
    fill(255, 255, 255);
  }
  
  void move(float delx, float dely){
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
  
  void move_unconstrained(float delx, float dely){
    x += delx;
    y += dely;
  }
  
 }
