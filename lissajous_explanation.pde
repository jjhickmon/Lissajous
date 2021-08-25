import java.util.*;
int r = 50;
int point_r = 20;
float trail_length = 100;

float t = 0;
float fps = 30;

int[] pos = {0, 0};
ACurve a = new ACurve(2, 150, pos);
BCurve b = new BCurve(1, 150, pos);
Lissajous l = new Lissajous(a, b);
  
void setup(){
  size(800,600);
  smooth();
  frameRate(fps);
  strokeWeight(2);
  
  textFont(createFont("Arial", 40, true));
  textAlign(CENTER);
}

void draw(){
  background(0);
  translate(400, 300);
  
  float c1 = map(mouseY, 0, height, 1, 5);
  float c2 = map(mouseX, 0, width, 1, 5);
  a.coeff = (int)c1;
  b.coeff = (int)c2;
  a.draw();
  b.draw();
  l.draw();
  line(a.x, a.y, l.x, l.y);
  line(b.x, b.y, l.x, l.y);
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
    text(String.valueOf(coeff), pos[0], pos[1] - offset + 13);
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
    text(String.valueOf(coeff), pos[0] - offset, pos[1] + 13);
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
  float x;
  float y;
  LinkedList<float[]> trail = new LinkedList<float[]>();

  Lissajous(ACurve ac, BCurve bc){
    a = ac;
    b = bc;
  }
  void draw(){
    fill(a.c);
    x = a.x;
    y = b.y;
    
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
