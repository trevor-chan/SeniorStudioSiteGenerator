/*
KMeans clustering algorithm adapted from code provided by
https://www.dataonfocus.com/k-means-clustering-java-code/
*/

class KMeans {
 
  //Number of Clusters. This metric should be related to the number of points
    //private int NUM_CLUSTERS = 5; 
    public int numclusters;
    //Number of Points
    //private int NUM_POINTS = 50;
    //Min and Max X and Y
    private int MIN_COORDINATE = (int) (sqrt(width*height)*.2);
    private int MAX_COORDINATE = (int) (sqrt(width*height)*.8);
    public Site s;
    
    public ArrayList<Point> points;
    public ArrayList<Cluster> clusters;
    
    public KMeans(Site inputsite) {
      this.points = new ArrayList<Point>();
      this.clusters = new ArrayList<Cluster>(); 
      s = inputsite;
      numclusters = s.numclusters;
      
    }
    
    /*public void main(String[] args) {
      
      KMeans kmeans = new KMeans();
      kmeans.init();
      kmeans.calculate();
    }*/
    
    //Initializes the process
    public void init() {
      //Create Points
      //points = Point.createRandomPoints(MIN_COORDINATE,MAX_COORDINATE,NUM_POINTS);
      points = Point.addAllPoints(s.numcampgrounds, s);
      
      //Create Clusters
      //Set Random Centroids
      for (int i = 0; i < numclusters; i++) {
        Cluster cluster = new Cluster(i);
        Point centroid = Point.createRandomPoint(MIN_COORDINATE,MAX_COORDINATE);
        cluster.setCentroid(centroid);
        clusters.add(cluster);
      }
      
      //Print Initial state
      plotClusters();
    }
 
    private void plotClusters() {
      for (int i = 0; i < numclusters; i++) {
        Cluster c = clusters.get(i);
        c.plotCluster();
        //c.plotCentroids();
      }
    }
    
    private void plotCentroids(){
      for (int i = 0; i < numclusters; i++) {
      Cluster c = clusters.get(i);
      c.plotCentroids();
      }
    }
    
  //The process to calculate the K Means, with iterating method.
    public void calculate() {
        boolean finish = false;
        int iteration = 0;
        
        // Add in new data, one at a time, recalculating centroids with each new one. 
        while(!finish) {
          //Clear cluster state
          clearClusters();
          
          ArrayList<Point> lastCentroids = getCentroids();
          
          //Assign points to the closer cluster
          assignCluster();
            
            //Calculate new centroids.
          calculateCentroids();
          
          iteration++;
          
          ArrayList<Point> currentCentroids = getCentroids();
          
          //Calculates total distance between new and old Centroids
          double distance = 0;
          for(int i = 0; i < lastCentroids.size(); i++) {
            distance += Point.distance(lastCentroids.get(i),currentCentroids.get(i));
          }
          //System.out.println("#################");
          //System.out.println("Iteration: " + iteration);
          //System.out.println("Centroid distances: " + distance);
          plotClusters();
                    
          if(distance == 0) {
            finish = true;
          }
        }
        plotCentroids();
    }
    
    private void clearClusters() {
      for(Cluster cluster : clusters) {
        cluster.clear();
      }
    }
    
    private ArrayList<Point> getCentroids() {
      ArrayList<Point> centroids = new ArrayList(numclusters);
      for(Cluster cluster : clusters) {
        Point aux = cluster.getCentroid();
        Point point = new Point(aux.getX(),aux.getY());
        centroids.add(point);
      }
      return centroids;
    }
    
    private void assignCluster() {
        double max = Double.MAX_VALUE;
        double min = max; 
        int cluster = 0;                 
        double distance = 0.0; 
        
        for(Point point : points) {
          min = max;
            for(int i = 0; i < numclusters; i++) {
              Cluster c = clusters.get(i);
                distance = Point.distance(point, c.getCentroid());
                if(distance < min){
                    min = distance;
                    cluster = i;
                }
            }
            point.setCluster(cluster);
            clusters.get(cluster).addPoint(point);
        }
    }
    
    private void calculateCentroids() {
        for(Cluster cluster : clusters) {
            double sumX = 0;
            double sumY = 0;
            ArrayList<Point> list = cluster.getPoints();
            int n_points = list.size();
            
            for(Point point : list) {
              sumX += point.getX();
                sumY += point.getY();
            }
            
            Point centroid = cluster.getCentroid();
            if(n_points > 0) {
              double newX = sumX / n_points;
              double newY = sumY / n_points;
                centroid.setX(newX);
                centroid.setY(newY);
            }
        }
    }
}
