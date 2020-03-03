static class Point {
 
    public double x = 0;
    public double y = 0;
    public int cluster_number = 0;
 
    private Point(){
    }
    
    public void setX(double x) {
        this.x = x;
    }
    
    public double getX()  {
        return this.x;
    }
    
    public void setY(double y) {
        this.y = y;
    }
    
    public double getY() {
        return this.y;
    }
    
    public void setCluster(int n) {
        this.cluster_number = n;
    }
    
    public int getCluster() {
        return this.cluster_number;
    }
    
    //Calculates the distance between two points.
    public static double distance(Point p, Point centroid) {
        return Math.sqrt(Math.pow((centroid.getY() - p.getY()), 2) + Math.pow((centroid.getX() - p.getX()), 2));
    }
    
    //Creates random point
    protected static Point createRandomPoint(int min, int max) {
      double r = Math.random();
      double x = min + (max - min) * r;
      r = Math.random();
      double y = min + (max - min) * r;
      return new Point(x,y);
    }
    
    protected static Point pointFromCamp(Camp c){
      return new Point(c.x, c.y);
    }
    
    protected static ArrayList<Point> addAllPoints(int number, Site s){
      ArrayList points = new ArrayList<Point>(number);
      for(int i = 0; i < number; i++){
        points.add(pointFromCamp(s.campgrounds[i]));
      }
      return points; 
    }
    
    protected static ArrayList<Point> createRandomPoints(int min, int max, int number) {
      ArrayList points = new ArrayList<Point>(number);
      for(int i = 0; i < number; i++) {
        points.add(createRandomPoint(min,max));
      }
      return points;
    }
    
    public String toString() {
      return "("+x+","+y+")";
    }
    
    public Point(double x, double y)
    {
        this.setX(x);
        this.setY(y);
    }
}
