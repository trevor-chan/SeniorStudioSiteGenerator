class Site{
  int numcampgrounds;
  Camp[] campgrounds;
  int numnearestneighbors;
  int[][] adjacency;
  float mobility;
  Central cc;
  
  
  Site(int numcamps, int numnearest, float mobil){ //add other amenities here as they are implemented
    //initialize campsites, place randomly
    numcampgrounds = numcamps;
    numnearestneighbors = numnearest;
    campgrounds = new Camp[numcamps];
    mobility = mobil;
    
    for(int i = 0; i < numcamps; i++){
      //campgrounds[i] = new Camp(i, random(width*.1,width*.9), random 
      //(height*.1,height*.9), 0, numnearestneighbors);
      campgrounds[i] = new Camp(i, random(width*.2,width*.8), random (height*.2,height*.8),
      0, numnearestneighbors);

    }
    
    cc = new Central();
    
    build_nearest_neighbor();
    build_adjacency_list();
  }
  
  void build_nearest_neighbor(){    //create nearestneighbor lists for all camps
    for(Camp s: campgrounds){
      //s.get_nearest_n_neighbors(numnearestneighbors, campgrounds);
      arrayCopy(s.get_nearest_n_neighbors(numnearestneighbors, campgrounds),s.neighbors);
      //println("%d: [%d %d %d]",s.number, s.neighbors[0], s.neighbors[1], s.neighbors[2]);
    }
  }
  
  void build_adjacency_list(){ //construct adjacency list
    adjacency = new int[numcampgrounds][numcampgrounds];
    int tempadj = 0;
    for(int i=0; i<numcampgrounds; i++){
      for(int j=0; j<numcampgrounds; j++){
        //set adjacency[i][j] to 0 if not adjacent, to 1 if so
        for (int k = 0; k < numnearestneighbors; k++){
          if (campgrounds[i].number==campgrounds[j].neighbors[k]){
            tempadj = 1;
          }
          adjacency[i][j] = tempadj;
        }
        //print(tempadj+" ");
        tempadj = 0;
      }
      //println();
    }
  }
  
  void build_central(){
    float xmean = 0;
    float ymean = 0;
    for(int i = 0; i < numcampgrounds; i++){
      xmean += campgrounds[i].x;
      ymean += campgrounds[i].y;
    }
    xmean = xmean/numcampgrounds;
    ymean = ymean/numcampgrounds;
    //cc = new Central(xmean,ymean);
    cc.x = xmean;
    cc.y = ymean;
  }
  
  void display(){
    background(0,0,0);
    for(Camp s: campgrounds){
      s.display();
    }
    plotlines();
    cc.display();
  }
  
  void plotlines(){
    stroke(255,255,255,30);
    for(int i = 0; i < numcampgrounds; i++){
      for(int j = 0; j < numcampgrounds; j++){
        if (adjacency[i][j] == 1){
          line(campgrounds[i].x, campgrounds[i].y, campgrounds[j].x, campgrounds[j].y);
        }
      }
    }
  }
  
  void move_towards_mean(){
    float[] meanx = new float[numcampgrounds];
    float[] meany = new float[numcampgrounds];
    for (int i = 0; i < numcampgrounds; i++){
      for (int j = 0; j < numnearestneighbors; j++){
        meanx[i] += campgrounds[campgrounds[i].neighbors[j]].x;
        meany[i] += campgrounds[campgrounds[i].neighbors[j]].y;
        
        /*
        meanx[i] += campgrounds[campgrounds[i].neighbors[j]].x;
        meany[i] += campgrounds[campgrounds[i].neighbors[j]].y;
        */
      }
      meanx[i] = meanx[i]/numnearestneighbors;
      meany[i] = meany[i]/numnearestneighbors;
    }
    
    float dirx = 0;
    float diry = 0;
    for (int i = 0; i < numcampgrounds; i++){
      dirx = .5*mobility/(meanx[i]-campgrounds[i].x);
      diry = .5*mobility/(meany[i]-campgrounds[i].y);
      campgrounds[i].move(dirx,diry);
    }
    
    //rebuild adjacencies
    build_nearest_neighbor();
    build_adjacency_list();
    
  }
  
  void move_away_from_mean(){
    float[] meanx = new float[numcampgrounds];
    float[] meany = new float[numcampgrounds];
    for (int i = 0; i < numcampgrounds; i++){
      for (int j = 0; j < numnearestneighbors; j++){
        meanx[i] += campgrounds[campgrounds[i].neighbors[j]].x;
        meany[i] += campgrounds[campgrounds[i].neighbors[j]].y;
        
        /*
        meanx[i] += campgrounds[campgrounds[i].neighbors[j]].x;
        meany[i] += campgrounds[campgrounds[i].neighbors[j]].y;
        */
      }
      meanx[i] = meanx[i]/numnearestneighbors;
      meany[i] = meany[i]/numnearestneighbors;
    }
    
    float dirx = 0;
    float diry = 0;
    for (int i = 0; i < numcampgrounds; i++){
      dirx = .5*mobility/(meanx[i]-campgrounds[i].x);
      diry = .5*mobility/(meany[i]-campgrounds[i].y);
      campgrounds[i].move(-dirx,-diry);
    } 
    //rebuild adjacencies
    build_nearest_neighbor();
    build_adjacency_list();  
  }
  
  void move_away_repel(){
      //for each nearest neighbor, calculate a repel force based on component deltas
    
    float[][] delx = new float[numcampgrounds][numnearestneighbors];
    float[][] dely = new float[numcampgrounds][numnearestneighbors];    
    for (int i = 0; i < numcampgrounds; i++){
      for (int j = 0; j < numnearestneighbors; j++){
        delx[i][j] = campgrounds[i].x-campgrounds[campgrounds[i].neighbors[j]].x;
        dely[i][j] = campgrounds[i].y-campgrounds[campgrounds[i].neighbors[j]].y;
      }
    }   
    float[] dirx = new float[numcampgrounds];
    float[] diry = new float[numcampgrounds];   
    for (int i = 0; i < numcampgrounds; i++){
      for (int j = 0; j < numnearestneighbors; j++){    
        dirx[i] += 10*mobility/(delx[i][j]*abs(delx[i][j]));
        diry[i] += 10*mobility/(dely[i][j]*abs(dely[i][j]));      
      }
    }
    for (int i = 0; i < numcampgrounds; i++){
      campgrounds[i].move(dirx[i],diry[i]);
    }
    //rebuild adjacencies
    build_nearest_neighbor();
    build_adjacency_list();
  }
  
  void move_Lennard_Jones(float distconst){   
    //for each nearest neighbor, calculate a repel force based on component deltas
    //float distconst = .1;
    
    /*float[][] delx = new float[numcampgrounds][numnearestneighbors];
    float[][] dely = new float[numcampgrounds][numnearestneighbors];*/
    
    float delx;
    float dely;
    //calculate vector difference between two points as cartesian and polar vectors for each neighbor
    cvec[][] cveclist = new cvec[numcampgrounds][numnearestneighbors];
    pvec[][] pveclist = new pvec[numcampgrounds][numnearestneighbors];
    for (int i = 0; i < numcampgrounds; i++){
      for (int j = 0; j < numnearestneighbors; j++){
        delx = campgrounds[i].x-campgrounds[campgrounds[i].neighbors[j]].x;
        dely = campgrounds[i].y-campgrounds[campgrounds[i].neighbors[j]].y;
        
        //println(delx + " " + dely);//------------------------------------------------------
        
        cveclist[i][j] = new cvec(delx,dely);
        pveclist[i][j] = ctop(cveclist[i][j]);
        
        //println(pveclist[i][j].dtheta);//----------------------------------------------------
      }
    }
    
    //calculate resultant move coordinates as an x and y component for each neighbor and sum
    float dirr;
    pvec tempp = new pvec(0,0);
    cvec tempc = new cvec(0,0);
    float[] dirx = new float[numcampgrounds];
    float[] diry = new float[numcampgrounds];
    for (int i = 0; i < numcampgrounds; i++){
      for (int j = 0; j < numnearestneighbors; j++){    
        dirr = lennard_jones(pveclist[i][j].dr, distconst, mobility);
        tempp.dr = dirr;
        tempp.dtheta = pveclist[i][j].dtheta;
        tempc = ptoc(tempp);
        
        dirx[i] += tempc.dx;
        diry[i] += tempc.dy;
      }
    }
    
    for (int i = 0; i < numcampgrounds; i++){
      //campgrounds[i].move(dirx[i],diry[i]);
      campgrounds[i].move_unconstrained(dirx[i],diry[i]);
      
      println(dirx[i] + " " + diry[i]); //-------------------------------------------------
      
    }
    //rebuild adjacencies
    build_nearest_neighbor();
    build_adjacency_list();
  }
  
  void move_radial_central(){ 
    float distconst = 5;
    //for each nearest neighbor, calculate a repel force based on component deltas
    float[] delx = new float[numcampgrounds];
    float[] dely = new float[numcampgrounds];    
    for (int i = 0; i < numcampgrounds; i++){
      delx[i] = campgrounds[i].x-cc.x;
      dely[i] = campgrounds[i].y-cc.y;
    }
    float[] dirx = new float[numcampgrounds];
    float[] diry = new float[numcampgrounds];   
    for (int i = 0; i < numcampgrounds; i++){   
      dirx[i] = 30*mobility*(((distconst*pow(delx[i],-3))-(distconst*pow(delx[i],-1))));
      diry[i] = 30*mobility*(((distconst*pow(dely[i],-3))-(distconst*pow(dely[i],-1))));
    }
    for (int i = 0; i < numcampgrounds; i++){
      campgrounds[i].move(dirx[i],diry[i]);
    }
    //rebuild adjacencies
    build_nearest_neighbor();
    build_adjacency_list();
  }
  
  /*float distance(Camp camp1, Camp camp2){
    return sqrt(pow((camp1.x-camp2.x),2)+pow((camp1.y-camp2.y),2));
  }*/
  
  pvec ctop(cvec c){
    float dr = sqrt(pow(c.dx,2)+pow(c.dy,2));
    float dtheta = atan(c.dy/c.dx);
    if (c.dx < 0){
      dtheta *= 2;
    }
    pvec p = new pvec(dr,dtheta);
    return p;
  }
  
  cvec ptoc(pvec p){
    float dx = p.dr * cos(p.dtheta);
    float dy = p.dr * sin(p.dtheta);
    cvec c = new cvec(dx,dy);
    return c;
  }
  
  float lennard_jones(float r, float c, float m){
    return 10*m*((pow(c/r,3))-(pow(c/r,1)))/(c*c);
  }
  
}
