import ddf.minim.analysis.*;
import ddf.minim.*;
 
Minim minim;
AudioPlayer jingle;
AudioInput input;
FFT fft;

int size = 512;
int npts = 100;

int ir = 0;
int ic = 0;
int cx = 0;
int cy = 0;
int sample = 0;

float[] x1 = new float[npts];
float[] y1 = new float[npts];
float[] x2 = new float[npts];
float[] y2 = new float[npts];
float[] sw = new float[npts];
float[] co = new float[npts];

float[] dx1 = new float[npts];
float[] dy1 = new float[npts];
float[] dx2 = new float[npts];
float[] dy2 = new float[npts];
float[] dsw = new float[npts];
float[] dco = new float[npts];


float[] cx1 = new float[npts];
float[] cy1 = new float[npts];
float[] cx2 = new float[npts];
float[] cy2 = new float[npts];
float[] csw = new float[npts];
float[] cco = new float[npts];

float[] cdx1 = new float[npts];
float[] cdy1 = new float[npts];
float[] cdx2 = new float[npts];
float[] cdy2 = new float[npts];
float[] cdsw = new float[npts];
float[] cdco = new float[npts];


float theta = 0;
float theta2 = 0;

float ampmod = 20;
float ampmodcoeff = 2.5;
float lagtime = 10;
int circrad = 50;
float mincol = 0;

int ssize = 1;




void setup()
{
  size(500,500);
   //fullScreen();
 
 
  minim = new Minim(this);
  input = minim.getLineIn();
  fft = new FFT(input.bufferSize(), input.sampleRate());

  background(225);
  stroke(150);
  strokeWeight(3);
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
        //background(255-mincol);
        ir = 0;
        ic = 0;
      }
      
    }
    cx = (2*ir+1)*4*circrad+50;
    cy = (2*ic+1)*4*circrad+50;
    fft.forward(input.mix);
    theta = theta + 2*PI/npts;
    float params[] = getParams(fft, theta);
    x1[sample] = params[0];
    y1[sample] = params[1];
    x2[sample] = params[2];
    y2[sample] = params[3];
    dx1[sample] = 0;
    dy1[sample] = 0;
    dx2[sample] = 0;
    dy2[sample] = 0;
    co[sample] = params[4];
    sw[sample] = params[5];
    
    int c = 0;
    
    int vw = 2000;
    background(mincol);
    drawtick(vw);
    drawtick2(vw);
    
    
    
    theta2 = theta2 - 2*PI/npts;
    float params2[] = getParams(fft, theta2);
    cx1[sample] = params2[0];
    cy1[sample] = params2[1];
    cx2[sample] = params2[2];
    cy2[sample] = params2[3];
    cdx1[sample] = 0;
    cdy1[sample] = 0;
    cdx2[sample] = 0;
    cdy2[sample] = 0;
    cco[sample] = params2[4];
    csw[sample] = params2[5];
    
    
    
    
    
/*    for(int i = sample; i < npts; i++) {
      strokeWeight(sw[i]);
      float cl = 255.0*(npts-c) + (c)*co[i];
      stroke(255-cl/npts);
      line(x1[i]-dx1[i],y1[i]-dy1[i],x2[i]-dx2[i],y2[i]-dy2[i]);
      line(x1[i]+dx1[i],y1[i]+dy1[i],x2[i]+dx2[i],y2[i]+dy2[i]);
      dx1[i] = x1[i] - (sw[i]*cx + (vw-sw[i])*(x1[i]-dx1[i]))/vw;
      dx2[i] = x2[i] - (sw[i]*cx + (vw-sw[i])*(x2[i]-dx2[i]))/vw;
      dy1[i] = y1[i] - (sw[i]*cy + (vw-sw[i])*(y1[i]-dy1[i]))/vw;
      dy2[i] = y2[i] - (sw[i]*cy + (vw-sw[i])*(y2[i]-dy2[i]))/vw;
      c++;
    }
    
    for(int i = 0; i < sample; i++) {
      strokeWeight(sw[i]);
      float cl = 255.0*(npts-c) + (c)*co[i];
      stroke(255-cl/npts);
      line(x1[i]-dx1[i],y1[i]-dy1[i],x2[i]-dx2[i],y2[i]-dy2[i]);
      line(x1[i]+dx1[i],y1[i]+dy1[i],x2[i]+dx2[i],y2[i]+dy2[i]);
      dx1[i] = x1[i] - (sw[i]*cx + (vw-sw[i])*(x1[i]-dx1[i]))/vw;
      dx2[i] = x2[i] - (sw[i]*cx + (vw-sw[i])*(x2[i]-dx2[i]))/vw;
      dy1[i] = y1[i] - (sw[i]*cy + (vw-sw[i])*(y1[i]-dy1[i]))/vw;
      dy2[i] = y2[i] - (sw[i]*cy + (vw-sw[i])*(y2[i]-dy2[i]))/vw;
      c++;
    }*/
    
    
    sample++;
    filter(BLUR, 8);
    filter(ERODE);
    filter(POSTERIZE, 2);
    filter(DILATE);
    filter(DILATE);
    //saveFrame();
}


void drawtick(int vw) {
  int c = 0;
  for(int i = sample; i < npts; i++) {
    strokeWeight(sw[i]);
    float cl = 255.0*(npts-c) + (c)*co[i];
    stroke(255-cl/npts);
    line(x1[i]-dx1[i],y1[i]-dy1[i],x2[i]-dx2[i],y2[i]-dy2[i]);
    line(x1[i]+dx1[i],y1[i]+dy1[i],x2[i]+dx2[i],y2[i]+dy2[i]);
    dx1[i] = x1[i] - (sw[i]*cx + (vw-sw[i])*(x1[i]-dx1[i]))/vw;
    dx2[i] = x2[i] - (sw[i]*cx + (vw-sw[i])*(x2[i]-dx2[i]))/vw;
    dy1[i] = y1[i] - (sw[i]*cy + (vw-sw[i])*(y1[i]-dy1[i]))/vw;
    dy2[i] = y2[i] - (sw[i]*cy + (vw-sw[i])*(y2[i]-dy2[i]))/vw;
    c++;
  }
  
  for(int i = 0; i < sample; i++) {
    strokeWeight(sw[i]);
    float cl = 255.0*(npts-c) + (c)*co[i];
    stroke(255-cl/npts);
    line(x1[i]-dx1[i],y1[i]-dy1[i],x2[i]-dx2[i],y2[i]-dy2[i]);
    line(x1[i]+dx1[i],y1[i]+dy1[i],x2[i]+dx2[i],y2[i]+dy2[i]);
    dx1[i] = x1[i] - (sw[i]*cx + (vw-sw[i])*(x1[i]-dx1[i]))/vw;
    dx2[i] = x2[i] - (sw[i]*cx + (vw-sw[i])*(x2[i]-dx2[i]))/vw;
    dy1[i] = y1[i] - (sw[i]*cy + (vw-sw[i])*(y1[i]-dy1[i]))/vw;
    dy2[i] = y2[i] - (sw[i]*cy + (vw-sw[i])*(y2[i]-dy2[i]))/vw;
    c++;
  }
}

void drawtick2(int vw) {
  int c = 0;
  for(int i = sample; i < npts; i++) {
    strokeWeight(csw[i]);
    float cl = 255.0*(npts-c) + (c)*cco[i];
    stroke(255-cl/npts);
    line(cx1[i]-cdx1[i],cy1[i]-cdy1[i],cx2[i]-cdx2[i],cy2[i]-cdy2[i]);
    line(cx1[i]+cdx1[i],cy1[i]+cdy1[i],cx2[i]+cdx2[i],cy2[i]+cdy2[i]);
    cdx1[i] = cx1[i] - (csw[i]*cx + (vw-csw[i])*(cx1[i]-cdx1[i]))/vw;
    cdx2[i] = cx2[i] - (csw[i]*cx + (vw-csw[i])*(cx2[i]-cdx2[i]))/vw;
    cdy1[i] = cy1[i] - (csw[i]*cy + (vw-csw[i])*(cy1[i]-cdy1[i]))/vw;
    cdy2[i] = cy2[i] - (csw[i]*cy + (vw-csw[i])*(cy2[i]-cdy2[i]))/vw;
    c++;
  }
  
  for(int i = 0; i < sample; i++) {
    strokeWeight(sw[i]);
    float cl = 255.0*(npts-c) + (c)*co[i];
    stroke(255-cl/npts);
    line(cx1[i]-cdx1[i],cy1[i]-cdy1[i],cx2[i]-cdx2[i],cy2[i]-cdy2[i]);
    line(cx1[i]+cdx1[i],cy1[i]+cdy1[i],cx2[i]+cdx2[i],cy2[i]+cdy2[i]);
    cdx1[i] = cx1[i] - (csw[i]*cx + (vw-csw[i])*(cx1[i]-cdx1[i]))/vw;
    cdx2[i] = cx2[i] - (csw[i]*cx + (vw-csw[i])*(cx2[i]-cdx2[i]))/vw;
    cdy1[i] = cy1[i] - (csw[i]*cy + (vw-csw[i])*(cy1[i]-cdy1[i]))/vw;
    cdy2[i] = cy2[i] - (csw[i]*cy + (vw-csw[i])*(cy2[i]-cdy2[i]))/vw;
    c++;
  }
}




float[] getParams(FFT fft, float theta) {
  
  float[] ret = new float[6];
  
  //x1,x2,y1,y2,color,weight
  int size_s = size/4;
  float[] samps = new float[size];
  float[] sampslo = new float[size/4];
  float[] sampshi = new float[size/4];
  for(int i = 0; i < size; i++) {
    samps[i] = fft.getBand(i)+.001;
    if (i < size_s) {
      sampslo[i] = fft.getBand(i)+.001;
    }
    else if (i >= 3*size_s){
      sampshi[i-3*size_s] = fft.getBand(i)+.001;
    }
  }
  
  float mean = avmean(samps, size);
  float pitch = wtmean(samps, size);
  float varc = variance(samps, size, mean);
  float meanlo = avmean_r(samps, 0, size/4);
  float pitchlo = wtmean_r(samps, 0, size/4);
  float varclo = variance_r(samps, 0, size/4, meanlo);
  float meanhi = avmean_r(samps, size/4*3, size);
  float pitchhi = wtmean_r(samps, size/4*3, size);
  float varchi = variance_r(samps, size/4*3, size, meanhi);
  
  float logmean = 1.2*(log(mean)+6);
  float logvarc = log(varc)+2;
  
  float amplag = ampmod + log(pitch)*5;
  lagtime = 7-log(pitch);
  float twt = 1.5*lagtime-1;
  if (twt <= 0.01) {twt = 0.01;}
  ret[5] = 4*twt;
  
  
  float thetalag = theta - lagtime*2*PI/npts;
  float amp = circrad-30+5*logvarc;
  float amplo = circrad-40+5*log(varclo);
  float amphi = circrad-40+5*log(varchi);
  if (amp <0-circrad/2) {
    amp = (float)(0-circrad/2);
    println("*");
  }
  //println(amplag + "--" + lagtime + "--" + amp + "--" + (float)circrad*1.3);
  float linecolor = logmean * 25;
  if (linecolor < mincol) {
    linecolor = mincol;
  }
  ret[4] = 255-linecolor;
  
  ret[0] = cx - 4*amplag * cos(thetalag);
  ret[1] = cy + 4*amplag*sin(thetalag);
  ret[2] = cx - 4*amp * cos(theta);
  ret[3] = cy + 4*amp*sin(theta);
  
  return ret;
}


float avmean(float a[], int n) {
  float sum = 0;
  for (int i = 0; i < n; i++)
    sum += a[i];
  float mean = sum / n;
  return mean;
}

float avmean_r(float a[], int n, int m) {
  float sum = 0;
  for (int i = n; i < m; i++)
    sum += a[i];
  return sum / (n-m);
}

float wtmean_r(float a[], int n, int m) {
  float sum = 0;
  for (int i = n; i < m; i++)
    sum += i*a[i];
  return sum / (n-m);
}

float variance_r(float a[], int n, int m, float mean)
{
    float sqDiff = 0;
    for (int i = n; i < m; i++) 
        sqDiff += (a[i] - mean) * 
                  (a[i] - mean);
    return sqDiff / (n-m);
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
