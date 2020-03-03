import processing.svg.*;

//Site[] sitearray;
Site testsite;
Site secondsite;

import java.util.*;

String filename, extension;
//String satimage;
VectorField v;
ImageManipulator iM;
PImage image;
color backgroundColor;
PGraphics graphics;
//PImage satimg;
int state = 0;

public void settings(){
  
  filename = "LonePine";  //  -------------------------this (and next line) for topography input
  //filename = "RedHill";
  //filename = "EstacionDelta";
  //filename = "AlabamaHills";
  
  extension = "png";
  //satimage = "redhillsat.png";

  image = loadImage(filename+"."+extension);
  //satimg = loadImage(satimage);
  size(image.width,image.height);
}

public void setup() {
  
  
  beginRecord(SVG, "EstacionDelta.svg");
  
  graphics = g;
  iM = new ImageManipulator(image, color(255), 1); // Default is black, with no edge effect 
  //iM = new ImageManipulator(image, color(255), 0, 1); // Default is black, with no edge effect 
  v = new VectorField(iM);
  v.scale(0.02);  // how effective the vectorfield is (use small numbers, very small if the VectorField isn't normalized);
  //v.addForce(new PVector(0.0,0.02));   
  
  backgroundColor = color(0);
  background(backgroundColor);
  stroke(0);
  
  
  testsite = new Site(128,5,2,10);
  
  
  //testsite.build_central();
  testsite.display();
  

}

//float cdiameter = 2;
int itr = 0;

void draw(){
  if (state == 0){ //generate campsites and central, layout accordingly and nudge
    //testsite.move_away_from_mean();
    //testsite.move_towards_mean();
    testsite.move_away_repel();
    testsite.topo_nudge(v,15);
    //testsite.move_radial_central(100);
    //testsite.move_Lennard_Jones(.001);
    //testsite.build_central(); 
    //testsite.cc.display();
    testsite.display();
    //testsite.displaynobkgd();
    //print(".");
    //delay(200);
    //delay(10);
    println(itr++);
  }
  else if (state == 1){ //fix campsites and central, run clustering and generate other functions
    //testsite.cc.display();
    //testsite.display();
    
    KMeans kmeans = new KMeans(testsite);
    kmeans.init();
    kmeans.calculate();
    
    background(backgroundColor);
    
    secondsite = new Site(kmeans, testsite);
    //image(satimg,0,0);
    secondsite.displaynobkgd();
    
    state++;
    secondsite.print_campsites(); 
    save("AlabamaHillsSite.png");
    endRecord();
    noLoop();
    //delay(5000);
  }
  else if (state ==2){
    delay(2000);
    //set guest sites
    //secondsite.display();
    state++;
  }
}


void mousePressed(){
  state++;
}
 
