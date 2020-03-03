class Camp{
  int number; //campsite number
  float x, y; //coordinates
  int type; //0 if camp, 1 if guest, 2 if bathroom, 3 if art hollow
  
  int numneighbors; //number of nearest neighbors to keep track of
  int[] neighbors; //list of nearest neighbors
  int clusterid;
  
  Camp(int n, float xcoord, float ycoord, int intype, int numn){
    number = n;
    x = xcoord;
    y = ycoord;
    type = intype;
    numneighbors = numn;
    neighbors = new int[numn];
    clusterid = 127;
  }
  
  Camp(int n, float xcoord, float ycoord, int intype, int numn, int cluster){
    number = n;
    x = xcoord;
    y = ycoord;
    type = intype;
    numneighbors = numn;
    neighbors = new int[numn];
    clusterid = cluster;
  }
  
    private String[] indexcolors = new String[]{
        "FFFF00", "1CE6FF", "FF34FF", "FF4A46", "008941", "006FA6", "A30059",
        "FFDBE5", "7A4900", "0000A6", "63FFAC", "B79762", "004D43", "8FB0FF", "997D87",
        "5A0007", "809693", "FEFFE6", "1B4400", "4FC601", "3B5DFF", "4A3B53", "FF2F80",
        "61615A", "BA0900", "6B7900", "00C2A0", "FFAA92", "FF90C9", "B903AA", "D16100",
        "DDEFFF", "000035", "7B4F4B", "A1C299", "300018", "0AA6D8", "013349", "00846F",
        "372101", "FFB500", "C2FFED", "A079BF", "CC0744", "C0B9B2", "C2FF99", "001E09",
        "00489C", "6F0062", "0CBD66", "EEC3FF", "456D75", "B77B68", "7A87A1", "788D66",
        "885578", "FAD09F", "FF8A9A", "D157A0", "BEC459", "456648", "0086ED", "886F4C",

        "34362D", "B4A8BD", "00A6AA", "452C2C", "636375", "A3C8C9", "FF913F", "938A81",
        "575329", "00FECF", "B05B6F", "8CD0FF", "3B9700", "04F757", "C8A1A1", "1E6E00",
        "7900D7", "A77500", "6367A9", "A05837", "6B002C", "772600", "D790FF", "9B9700",
        "549E79", "FFF69F", "201625", "72418F", "BC23FF", "99ADC0", "3A2465", "922329",
        "5B4534", "FDE8DC", "404E55", "0089A3", "CB7E98", "A4E804", "324E72", "6A3A4C",
        "83AB58", "001C1E", "D1F7CE", "004B28", "C8D0F6", "A3A489", "806C66", "222800",
        "BF5650", "E83000", "66796D", "DA007C", "FF1A59", "8ADBB4", "1E0200", "5B4E51",
        "C895C5", "320033", "FF6832", "66E1D3", "CFCDAC", "D0AC94", "7ED379", "012C58",
        "000000"
  };

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
    
    //set color to cluster color
    int co = unhex(indexcolors[clusterid%128]) | 0xff000000;
    stroke(co);
    fill(co);
    textSize(sqrt(width*height)/100);
    char c = char(clusterid + 65);
    
    if (type == 0){ //reg camp
      text(c+""+number, x, y); 
    }
    else if (type == 1){ //guest camp
      //textSize(sqrt(width*height)/50);
      text(c+""+number+":G", x, y);
    }
    else if (type == 2) { //bathroom
      //textSize(sqrt(width*height)/50);
      text(c+":B",x,y);
      //rect(x-4,y-4,8,8);
    }
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
