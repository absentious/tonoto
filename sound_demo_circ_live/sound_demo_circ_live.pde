import ddf.minim.analysis.*;
import ddf.minim.*;
 
Minim minim;
AudioPlayer jingle;
AudioInput input;
FFT fft;

int mode = 3;
int invmode = 1;
int ssize = 12;
int dim = 1200;

int[][] colo=new int[300][3];
int row = 0;
float size = 0;
float szint = 0;
float dispsize = 0;

int npts = 500;
int wait = 1000/npts;
int circrad = 50;
int ir = 0;
int ic = 0;
int cx = 0;
int cy = 0;

float logmean = 0;
float logvarc = 0;

int snum = 512;
int sample = 0;
float[] samps = new float[snum];
float theta = 0;
float thetalag = 0;
float lagtime = 10;
float ampmod = 20;
float ampmodcoeff = 2.5;
float amplag = 0;

float linecolor = 0;
int spc = 5;

float ccol;

float maxsize = 5;
float minsize = 2;
float mincol = 30;
//AudioIn in;
 
void setup()
{
  size(1200,1200);
   //fullScreen();
 
 
  minim = new Minim(this);
 
 
  input = minim.getLineIn();
 
  fft = new FFT(input.bufferSize(), input.sampleRate());
 
 // textFont(createFont("Arial", 16));
 
 // windowName = "None";
   background(mincol);
   if (invmode == 1) {
     background(255-mincol);
   }
  stroke(150);
  strokeWeight(3);
  wait = 0;
}
 
void draw()
{

  if(sample >= npts) {
    ir++;
    theta = 0;
    sample = 0;
    if (ir >= ssize) {
      ir = 0;
      ic++;
    }
    if(ic >= ssize) {
      background(mincol);
      if (invmode == 1) {
        background(255-mincol);
      }
      ir = 0;
      ic = 0;
    }
      
  }
  cx = (2*ir+1)*circrad;
  cy = (2*ic+1)*circrad;
  
  fft.forward(input.mix);
  for(int i = 0; i < snum; i++) {
    samps[i] = fft.getBand(i)+.001;
  }
  float mean = avmean(samps, snum);
  float pitch = wtmean(samps, snum);
  float varc = variance(samps, snum, mean);
  logmean = 1.2*(log(mean)+6);
  logvarc = log(varc)+2;
  
  
  theta = theta + 2*PI/npts;
  lagtime = 0;
  
  if (mode == 0) {
    amplag = 0;
    lagtime = 0;
  }
  else if (mode == 1) {
    amplag = 0;
    lagtime = 0;
  }
  else if (mode == 2) {
    amplag = ampmod + ampmodcoeff*logmean;
    lagtime = spc;
  }
  else if (mode == 3) {
    amplag = ampmod + log(pitch)*5;
    lagtime = 7-log(pitch);
    float twt = 1.5*lagtime-1;
    if (twt <= 0.01) {twt = 0.01;}
    strokeWeight(twt);
  }
  thetalag = theta - lagtime*2*PI/npts;
  float amp = circrad-30+5*logvarc;
  if (amp <0-circrad/2) {
    amp = (float)(0-circrad/2);
    println("*");
  }
  //println(amplag + "--" + lagtime + "--" + amp + "--" + (float)circrad*1.3);
  linecolor = logmean * 25;
  if (linecolor < mincol) {
    linecolor = mincol;
  }
  if (invmode == 1) {
    linecolor = 255-linecolor;
  }
  fill(linecolor);
  stroke(linecolor);
  //ellipse(cx - amp * cos(theta),cy + amp*sin(theta),5,5);
  if (mode == 0) {
    line(cx,cy,cx - amp * cos(theta),cy + amp*sin(theta)); //nice flowers
  }
  else if (mode >= 2) {
    line(cx- amplag * cos(thetalag),cy + amplag*sin(thetalag),cx - amp * cos(theta),cy + amp*sin(theta)); //fukk
  }
  delay(wait);

  sample++;
}

float avmean(float a[], int n) {
  float sum = 0;
  for (int i = 0; i < n; i++)
    sum += a[i];
  float mean = sum / n;
  return mean;
}

float wtmean(float a[], int n) {
  float sum = 0;
  for (int i = 0; i < n; i++)
    sum += i*a[i];
  float mean = sum / n;
  return mean;
}

float variance(float a[], int n, float mean)
{
    // Compute sum squared 
    // differences with mean.
    float sqDiff = 0;
    for (int i = 0; i < n; i++) 
        sqDiff += (a[i] - mean) * 
                  (a[i] - mean);
    return sqDiff / n;
}
