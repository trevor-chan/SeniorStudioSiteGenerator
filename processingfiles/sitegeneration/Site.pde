class Site{
  int numcampgrounds;
  Camp[] campgrounds;
  int numnearestneighbors;
  int[][] adjacency;
  float mobility;
  Central cc;
  int numclusters;
  int sitespercluster = 10;
  
  
  Site(int numcamps, int numnearest, float mobil, int clustersize){ //add other amenities here as they are implemented
    //initialize campsites, place randomly
    numcampgrounds = numcamps;
    numnearestneighbors = numnearest;
    campgrounds = new Camp[numcamps];
    mobility = mobil;
    sitespercluster = clustersize;
    numclusters = numcampgrounds/sitespercluster; // Variable dependent on how many camps to a cluster ------------------
    
    
    for(int i = 0; i < numcamps; i++){
      //campgrounds[i] = new Camp(i, random(width*.1,width*.9), random 
      //(height*.1,height*.9), 0, numnearestneighbors);
      campgrounds[i] = new Camp(i, random(width*.2,width*.8), random (height*.2,height*.8),
      0, numnearestneighbors);

    }
    
    cc = new Central();
    build_central();
    build_nearest_neighbor();
    build_adjacency_list();
  }
  
  Site(KMeans km, Site oldsite){ //makes a new site from KMeans structure and the incomplete old site
    numcampgrounds = oldsite.numcampgrounds;
    numnearestneighbors = oldsite.numnearestneighbors;
    mobility = oldsite.mobility;
    numclusters = oldsite.numclusters;
    cc = oldsite.cc;
    campgrounds = new Camp[numcampgrounds];
    
    //make campgrounds
    int iter = 0;
    //int iter2 = 0; // if display numbers should cound 1->n for each cluster, make a separate number for display number and campsite number
    for (int i = 0; i < km.numclusters; i++){
      for (int j = 0; j < km.clusters.get(i).points.size(); j++){
      
      campgrounds[iter] = new Camp(iter, (float)km.clusters.get(i).points.get(j).x, 
      (float) km.clusters.get(i).points.get(j).y, 0, numnearestneighbors, i);
      iter++;
      }
    }
    
    place_guests();
    place_bathrooms(km);
    
    //make adjacency
    build_nearest_neighbor();
    build_adjacency_list();
  }
  
  
  void display(){
    background(backgroundColor);
    //v.drawVFraster(graphics); //-----------------------------------------------
    for(Camp s: campgrounds){
      s.display();
    }
    plotlines();
    cc.display();
    v.drawVFlines(graphics, 1);
    
  }
  
  void displaynobkgd(){
    //background(backgroundColor);
    //v.drawVFraster(graphics); //-----------------------------------------------
    for(Camp s: campgrounds){
      s.display();
    }
    
    //cc.display();
    v.drawVFlines(graphics, 1);
    plotlines();
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
  
  void plotlines(){
    stroke(255,255,255,50);//-----------------------------------------
    for(int i = 0; i < numcampgrounds; i++){
      for(int j = 0; j < numcampgrounds; j++){
        if (adjacency[i][j] == 1){
          line(campgrounds[i].x, campgrounds[i].y, campgrounds[j].x, campgrounds[j].y);
        }
      }
    }
  }
  
  void place_guests(){  // replaces a random node in each cluster with a guest campsite
    println("numclusters = " + numclusters);
    final int numgestspercluster = 2;
    int temp = 0;
    for (int i = 0; i < numclusters; i++){
      for (int j = 0; j < numcampgrounds; j++){
        if (campgrounds[j].clusterid == i)
        {
          campgrounds[j].type = 1;
          temp++;
          //println("GUESTS: break when cluster number = " + i);
          if (temp == numgestspercluster){break;}
        }
      }
      temp = 0;
    }
  }
  
  void place_bathrooms(KMeans km){  // replaces node of site nearest to each cluster's centroid with a bathroom
    float mindist = width*height;
    float tempdist = 0;
    int tempindex = 0;
    for (int i = 0; i < numclusters; i++){
      for (int j = 0; j < numcampgrounds; j++){
        //find node closest to centroid
        if (campgrounds[j].clusterid == i){ 
          tempdist = sqrt(pow(campgrounds[j].x-(float)km.clusters.get(i).centroid.x,2)
          +pow(campgrounds[j].y-(float)km.clusters.get(i).centroid.y,2));
          if (tempdist < mindist){
            mindist = tempdist;
            tempindex = j;
          }
        }
        
      }
      mindist = width*height;
      println("build rstrm for cluster " + i + " from " + tempindex + " of cluster " + campgrounds[tempindex].clusterid);
      campgrounds[tempindex].type = 2;
      km.clusters.get(i).plotCentroids();
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
      campgrounds[i].move_constrained(dirx[i],diry[i]);
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
        dirr = lennard_jones(pveclist[i][j].dr, distconst, mobility, 10);
        //dirr = quartic(pveclist[i][j].dr, 1000000, 200);
        tempp.dr = dirr;
        tempp.dtheta = pveclist[i][j].dtheta;
        tempc = ptoc(tempp);
        
        dirx[i] += tempc.dx;
        diry[i] += tempc.dy;
      }
    }
    
    for (int i = 0; i < numcampgrounds; i++){
      //campgrounds[i].move(dirx[i],diry[i]);
      campgrounds[i].move(dirx[i],diry[i]);
      
      //println(dirx[i] + " " + diry[i]); //-------------------------------------------------
      
    }
    //rebuild adjacencies
    build_nearest_neighbor();
    build_adjacency_list();
  }
  
  void move_radial_central(float distconst){ 
    //move all sites to a distance relative to central
    
    float delx;
    float dely;
    //calculate vector difference between two points as cartesian and polar vectors for each neighbor
    cvec[] cveclist = new cvec[numcampgrounds];
    pvec[] pveclist = new pvec[numcampgrounds];
    for (int i = 0; i < numcampgrounds; i++){
      delx = campgrounds[i].x-cc.x;
      dely = campgrounds[i].y-cc.y;
      cveclist[i] = new cvec(delx,dely);
      pveclist[i] = ctop(cveclist[i]);
    }

    //calculate resultant move coordinates as an x and y component for each neighbor and sum
    float dirr;
    pvec tempp = new pvec(0,0);
    cvec tempc = new cvec(0,0);
    float[] dirx = new float[numcampgrounds];
    float[] diry = new float[numcampgrounds];
    for (int i = 0; i < numcampgrounds; i++){   
        dirr = quartic(pveclist[i].dr, 1000000, 200);
        tempp.dr = dirr;
        tempp.dtheta = pveclist[i].dtheta;
        tempc = ptoc(tempp);
        
        dirx[i] += tempc.dx;
        diry[i] += tempc.dy;
    }
    
    for (int i = 0; i < numcampgrounds; i++){
      campgrounds[i].move(dirx[i],diry[i]);
    }
    //rebuild adjacencies
    build_nearest_neighbor();
    build_adjacency_list();
  }
  
  
  
  void topo_nudge(VectorField v, float influence){
    //for each camp, push along vector field
    
    PVector movevector = new PVector();
    for (int i = 0; i < numcampgrounds; i++){
      movevector = v.getValue(campgrounds[i].x,campgrounds[i].y);
      campgrounds[i].move(influence*-1*movevector.x, influence*-1*movevector.y);
    }
    
    //move central
    movevector = v.getValue(cc.x,cc.y);
    cc.move(influence*-1*movevector.x, influence*-1*movevector.y);
    
    //rebuild adjacencies
    build_nearest_neighbor();
    build_adjacency_list();
  }
  
  void print_campsites(){
    for (int i = 0; i < numcampgrounds; i++){
      println(campgrounds[i].x + "," + campgrounds[i].y);
    }
  }
  
  
  
  
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
  
  float lennard_jones(float r, float a, float b, float c){
    //return 10*m*((pow(c/r,3))-(pow(c/r,1)))/(c*c);
    return a*r*r - b*r - c;
  }
  
  float quartic(float r, float magnitude, float dist){
    //println(r);
    //return magnitude * pow((r-dist),3);
    return magnitude * (pow(r, -4) - (1/dist)*pow(r, -2));
  }
  
}
