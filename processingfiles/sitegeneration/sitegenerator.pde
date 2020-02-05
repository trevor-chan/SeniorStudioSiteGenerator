import processing.svg.*;

//Site[] sitearray;
Site testsite;

float cdiameter = 2;

void setup(){
  size(1000,1000);
  background(0,0,0);
  stroke(255);
  
  //Site testsite = new Site(120,3,5);
  testsite = new Site(120,5,2);
  testsite.display();
}

void draw(){
  //testsite.move_away_from_mean();
  //testsite.move_towards_mean();
  //testsite.move_away_repel();
  //testsite.move_Lennard_Jones(100);
  testsite.build_central();
  testsite.display();
  //print(".");
  //delay(200);
  delay(10);
}
 
 
