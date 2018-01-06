import processing.sound.*;

FFT fft;
AudioIn in;

int rows, cols;
int scl = 20;
int w;
int h;
float[][] heights;
float[] spectrum;
int speed = 1;
int band_scl = 2000;
int colors = 100;
color black;
float color_current = 0;
float color_inc = 0.02;
float movement = 0;
float ambient_hue = 56;
float ambient_saturation = 40;
float ambient_brightness = 40;
float depth = -200;
int count1;
int count2;
float light_scale = 2.8;
int fontSize = 240;
PFont times;
  
void setup() {
  fullScreen(P3D);
  colorMode(HSB, colors);
  black = color(0,0,0);
  background(black);
  
  PFont times = createFont("Times New Roman", fontSize);
  textFont(times);
  textAlign(CENTER, CENTER);
  
  w = 1280;
  h = floor(height * 1.5);
  cols = w/scl;
  rows = h/scl;
  heights = new float [cols][rows*speed];
  for (int y = 0; y < rows*speed; y++) {
    for (int x = 0; x < cols; x++) {
      heights[x][y] = 0;
    }
  }
  
  spectrum = new float[cols*2];
  fft = new FFT(this, 2*cols);
  in = new AudioIn(this, 0);
  in.start();
  fft.input(in);
  
  count1 = 0;
  count2 = 0;
}

void draw() {  
  fft.analyze(spectrum);
  movement -= 0.05;
  
  if (movement < -1000) {
    movement = 0;
  }
  
  float amp = 0;
  for (int i = 0; i < cols*2; i++) {
    amp += spectrum[i];
  }
  
  float yOff = movement;
  for (int y = (rows*speed)-1; y > 0; y--) {
    float xOff = 0;
    for (int x = 0; x < cols; x++) {
      heights[x][y] = heights[x][y-1] + map(noise(xOff,yOff), 0, 1 , -7, 7) - map(noise(xOff,yOff + 0.1), 0, 1, -7, 7);
      xOff += 0.1;
    }
    yOff -= 0.1;
  }
  
  for (int x = 0; x < cols/2; x++) {
    if (x < cols/4){
      spectrum[x] *= 0.5 ;
    } else {
      spectrum[x] *= 1.5;
    }
    spectrum[(cols-x)-1] = spectrum[x];
  }
  
  for (int x = 0; x < cols; x++) {
    heights[x][0] = spectrum[x]*band_scl;
  }
  
  background(black);
  
  color_current = (color_inc + color_current) % colors;
  
  count1++;
  count2++;
  /*
  if (count < 60*5) {
    stroke(0,0,colors);
  } else if (count < 60*10) {
    stroke(black);
  } else if (count < 60*15) {
    stroke(color_current, colors, colors);
  } else if (count < 60*20) {
    stroke(ambient_hue, ambient_saturation, ambient_brightness);
  } else if (count < 60*25) {
    noStroke();
  } else {
    count = 0;
  }
  */
  if (count1 < 60*15) {
    stroke(black);
  } else if (count1 < 60*30) {
    noStroke();
  } else {
    count1 = 0;
  }
  fill(0,0,colors);
  
  translate(width/2, height/2 + 75);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  pointLight(color_current, colors, colors, w, h, 200);
  ambientLight(ambient_hue, ambient_saturation, ambient_brightness);
  pointLight(0, 0, colors*amp*light_scale, 0, h, 100);
      
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x*scl, y*scl, heights[x][y*speed]);
      vertex(x*scl, (y+1)*scl, heights[x][(y+1)*speed]);
    }
    endShape();
  }
  
  float unit = (w/3)/200;
  
  if (count2 < 5*60*60) {
    noStroke();
    
    //pi
    beginShape();
    vertex(w/3+10*unit,depth,30*unit);
    vertex(w/3+10*unit,depth,37*unit);
    vertex(w/3-10*unit,depth,37*unit);
    vertex(w/3-10*unit,depth,152*unit);
    vertex(w/3+10*unit,depth,152*unit);
    vertex(w/3+10*unit,depth,159*unit);
    vertex(w/3-130*unit,depth,159*unit);
    vertex(w/3-130*unit,depth,152*unit);
    vertex(w/3-110*unit,depth,152*unit);
    vertex(w/3-110*unit,depth,37*unit);
    vertex(w/3-130*unit,depth,37*unit);
    vertex(w/3-130*unit,depth,30*unit);
    vertex(w/3-70*unit,depth,30*unit);
    vertex(w/3-70*unit,depth,37*unit);
    vertex(w/3-90*unit,depth,37*unit);
    vertex(w/3-90*unit,depth,152*unit);
    vertex(w/3-30*unit,depth,152*unit);
    vertex(w/3-30*unit,depth,37*unit);
    vertex(w/3-50*unit,depth,37*unit);
    vertex(w/3-50*unit,depth,30*unit);
    endShape(CLOSE);
  
    //kappa
    beginShape();
    vertex(w/3,depth,0);
    vertex(w/3,depth,10*unit);
    vertex(w/3+30*unit,depth,10*unit);
    vertex(w/3+30*unit,depth,185*unit);
    vertex(w/3,depth,185*unit);
    vertex(w/3,depth,195*unit);
    vertex(w/3+90*unit,depth,195*unit);
    vertex(w/3+90*unit,depth,185*unit);
    vertex(w/3+60*unit,depth,185*unit);
    vertex(w/3+60*unit,depth,95*unit);
    vertex(w/3+150*unit,depth,185*unit);
    vertex(w/3+120*unit,depth,185*unit);
    vertex(w/3+120*unit,depth,195*unit);
    vertex(w/3+195*unit,depth,195*unit);
    vertex(w/3+195*unit,depth,185*unit);
    vertex(w/3+165*unit,depth,185*unit);
    vertex(w/3+100*unit,depth,120*unit);
    vertex(w/3+170*unit,depth,10*unit);
    vertex(w/3+200*unit,depth,10*unit);
    vertex(w/3+200*unit,depth,0);
    vertex(w/3+110*unit,depth,0);
    vertex(w/3+110*unit,depth,10*unit);
    vertex(w/3+140*unit,depth,10*unit);
    vertex(w/3+80*unit,depth,100*unit);
    vertex(w/3+60*unit,depth,80*unit);
    vertex(w/3+60*unit,depth,10*unit);
    vertex(w/3+80*unit,depth,10*unit);
    vertex(w/3+80*unit,depth,0);
    endShape(CLOSE);

    //alpha
    beginShape();
    vertex(2*w/3-30*unit,depth,30*unit);
    vertex(2*w/3-30*unit,depth,37*unit);
    vertex(2*w/3-20*unit,depth,37*unit);
    vertex(2*w/3+25*unit,depth,157*unit);
    vertex(2*w/3+40*unit,depth,157*unit);
    vertex(2*w/3+85*unit,depth,37*unit);
    vertex(2*w/3+100*unit,depth,37*unit);
    vertex(2*w/3+100*unit,depth,30*unit);
    vertex(2*w/3+45*unit,depth,30*unit);
    vertex(2*w/3+45*unit,depth,37*unit);
    vertex(2*w/3+65*unit,depth,37*unit);
    vertex(2*w/3+27.5*unit,depth,137*unit);
    vertex(2*w/3+8.75*unit,depth,87*unit);
    vertex(2*w/3+46.25*unit,depth,87*unit);
    vertex(2*w/3+50*unit,depth,77*unit);
    vertex(2*w/3+5*unit,depth,77*unit);
    vertex(2*w/3-10*unit,depth,37*unit);
    vertex(2*w/3+5*unit,depth,37*unit);
    vertex(2*w/3+5*unit,depth,30*unit);
    endShape(CLOSE);
  } else {
    
    rotateX(-1.4*PI/3);
    text("PIKADELIC", w/2, depth*1.2, 30*unit);
    rotateX(1.4*PI/3);
    
    if (count2 > 10*60*60) {
      count2 = 0;
    }
  
  }
}