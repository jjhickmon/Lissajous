import java.util.*;
int r = 30;
int point_r = 10;
float trail_length = 120;

float t = 0;
float fps = 30;

ArrayList<ACurve> alist = new ArrayList<>();
ArrayList<BCurve> blist = new ArrayList<>();
ArrayList<Lissajous> llist = new ArrayList<>();
  
void setup(){
  size(800,600);
  smooth();
  frameRate(fps);
  strokeWeight(2);
  
  for(int i = 1; i <= 5; i++){
    int[] pos = {i*100 - 300, -150};
    ACurve a = new ACurve(i, 100, pos);
    alist.add(a);
  }
  for(int i = 1; i <= 5; i++){
    int[] pos = {-200, i*100 - 250};
    BCurve b = new BCurve(i, 100, pos);
    blist.add(b);
  }
  for(ACurve a : alist){
    for(BCurve b : blist){
      Lissajous l = new Lissajous(a, b);
      llist.add(l);
    }
  }
}

void draw(){
  background(0);
  translate(400, 300);
  //trail_length = map(mouseX, 0, width, 0, 100);
  for(ACurve a : alist){
    a.draw();
  }
  for(BCurve b : blist){
    b.draw();
  }
  for(Lissajous l : llist){
    l.draw();
  }
  t+=2;
}

class ACurve{
  int[] pos;
  int coeff;
  int offset;
  float x;
  float y;
  color c = color(255);
  ACurve(int c, int o, int[] p){
    coeff = c;
    pos = p;
    offset = o;
  }
  
  void draw(){
    float theta = (t/fps)*coeff;
    x = r*cos(theta) + pos[0];
    y = r*sin(theta) - offset + pos[1];
    noFill();
    circle(pos[0], pos[1] - offset, r*2);
    fill(c);
    circle(x, y, point_r);
    noFill();
  }
}

class BCurve{
  int[] pos;
  int coeff;
  int offset;
  float x;
  float y;
  color c = color(255);
  
  BCurve(int c, int o, int[] p){
    coeff = c;
    pos = p;
    offset = o;
  }
  
  void draw(){
    float theta = (t/fps)*coeff;
    x = r*cos(theta) - offset + pos[0];
    y = r*sin(theta) + pos[1];
    circle(pos[0] - offset, pos[1], r*2);
    fill(255);
    circle(x, y, point_r);
    noFill();
  }
}

class Lissajous{
  ACurve a;
  BCurve b;
  LinkedList<float[]> trail = new LinkedList<float[]>();

  Lissajous(ACurve ac, BCurve bc){
    a = ac;
    b = bc;
  }
  void draw(){
    fill(a.c);
    
    float x = a.x;
    float y = b.y;
    
    trail.add(new float[]{x, y});
    float p0 = 0;
    float p1 = 0;
    for(int i = 0; i < trail.size(); i++){
      float j = map(i, 0, trail.size(), 255, 0);
      float[] p = trail.get(i);
      stroke(190 - j, 190 - j, 255 - j);
      if(p0 != 0 && p1 !=0){
        line(p0, p1, p[0], p[1]);
      } else {
        point(p[0], p[1]);
      }
      p0 = p[0];
      p1 = p[1];
    }
    while(trail.size() > trail_length){
      trail.remove();
    }
    
    stroke(b.c);
    circle(x, y, point_r);
    stroke(255);
  }
}
