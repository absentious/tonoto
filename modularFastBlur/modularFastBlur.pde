import ddf.minim.analysis.*;
import ddf.minim.*;
 
Minim minim;
AudioPlayer jingle;
AudioInput input;
FFT fft;

int size = 512;
int npts = 200;

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

int[] screenBuf;
int numPixels;

float fadeFactor = 1;
float coronaLevel = 150;


void setup()
{
  size(600,600);
   //fullScreen();
 
 
  minim = new Minim(this);
  input = minim.getLineIn();
  fft = new FFT(input.bufferSize(), input.sampleRate());

  background(225);
  stroke(150);
  strokeWeight(3);
  
  numPixels = width*height;
  screenBuf = new int[numPixels];
  loadPixels();
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
    cx = (2*ir+1)*4*circrad+100;
    cy = (2*ic+1)*4*circrad+100;
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
    theta2 = 1*theta + PI;
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
    //filter(BLUR, 2);
    loadPixels();

    //filter(DILATE);
    fastblur(pixels, 25);

    updatePixels();
    
    filter(DILATE);
    filter(POSTERIZE, 2);
    filter(ERODE);
    filter(ERODE);
    //filter(ERODE);
    //filter(ERODE);
    
    loadPixels();
    //for(int i=0;i<600*600;i++) {
    //  println(pixels[i]);
    //}
    
    //saveFrame();
}


void drawtick(int vw) {
  int c = 0;
  for(int i = sample; i < npts; i++) {
    strokeWeight(sw[i]);
    float cl = 255.0*(npts-c) + (c)*co[i];
    float cl_shift = 255-cl/npts/fadeFactor; 
    stroke(color(cl_shift, cl_shift, 255));
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
    float cl_shift = 255-cl/npts/fadeFactor; 
    stroke(color(cl_shift, cl_shift, 255));
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
    float cl_shift = 255-cl/npts/fadeFactor; 
    stroke(color(cl_shift, cl_shift, cl_shift));
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
    float cl_shift = 255-cl/npts/fadeFactor; 
    stroke(color(cl_shift, cl_shift, cl_shift));
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

void fastblur(int[] pix,int radius){

  if (radius<1){
    return;
  }
  int w=600;
  int h=600;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;

  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum,gsum,bsum,x,y,i,p,yp,yi,yw;
  int vmin[] = new int[max(w,h)];

  int divsum=(div+1)>>1;
  divsum*=divsum;
  int dv[]=new int[256*divsum];
  for (i=0;i<256*divsum;i++){
    dv[i]=(i/divsum);
  }

  yw=yi=0;

  int[][] stack=new int[div][3];
  int stackpointer;
  int stackstart;
  int[] sir;
  int rbs;
  int r1=radius+1;
  int routsum,goutsum,boutsum;
  int rinsum,ginsum,binsum;

  for (y=0;y<h;y++){
    rinsum=ginsum=binsum=routsum=goutsum=boutsum=rsum=gsum=bsum=0;
    for(i=-radius;i<=radius;i++){
      p=pix[yi+min(wm,max(i,0))];
      sir=stack[i+radius];
      sir[0]=(p & 0xff0000)>>16;
      sir[1]=(p & 0x00ff00)>>8;
      sir[2]=(p & 0x0000ff);
      rbs=r1-abs(i);
      rsum+=sir[0]*rbs;
      gsum+=sir[1]*rbs;
      bsum+=sir[2]*rbs;
      if (i>0){
        rinsum+=sir[0];
        ginsum+=sir[1];
        binsum+=sir[2];
      } else {
        routsum+=sir[0];
        goutsum+=sir[1];
        boutsum+=sir[2];
      }
    }
    stackpointer=radius;

    for (x=0;x<w;x++){

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];
      
      rsum-=routsum;
      gsum-=goutsum;
      bsum-=boutsum;

      stackstart=stackpointer-radius+div;
      sir=stack[stackstart%div];
      
      routsum-=sir[0];
      goutsum-=sir[1];
      boutsum-=sir[2];
      
      if(y==0){
        vmin[x]=min(x+radius+1,wm);
      }
      p=pix[yw+vmin[x]];
      
      sir[0]=(p & 0xff0000)>>16;
      sir[1]=(p & 0x00ff00)>>8;
      sir[2]=(p & 0x0000ff);

      rinsum+=sir[0];
      ginsum+=sir[1];
      binsum+=sir[2];

      rsum+=rinsum;
      gsum+=ginsum;
      bsum+=binsum;
      
      stackpointer=(stackpointer+1)%div;
      sir=stack[(stackpointer)%div];
     
      routsum+=sir[0];
      goutsum+=sir[1];
      boutsum+=sir[2];
     
       rinsum-=sir[0];
      ginsum-=sir[1];
      binsum-=sir[2];
     
       yi++;
    }
    yw+=w;
  }
  for (x=0;x<w;x++){
    rinsum=ginsum=binsum=routsum=goutsum=boutsum=rsum=gsum=bsum=0;
    yp=-radius*w;
    for(i=-radius;i<=radius;i++){
      yi=max(0,yp)+x;
     
       sir=stack[i+radius];
      
      sir[0]=r[yi];
      sir[1]=g[yi];
      sir[2]=b[yi];
     
      rbs=r1-abs(i);
      
      rsum+=r[yi]*rbs;
      gsum+=g[yi]*rbs;
      bsum+=b[yi]*rbs;
     
      if (i>0){
        rinsum+=sir[0];
        ginsum+=sir[1];
        binsum+=sir[2];
      } else {
        routsum+=sir[0];
        goutsum+=sir[1];
        boutsum+=sir[2];
      }
      
      if(i<hm){
        yp+=w;
      }
    }
    yi=x;
    stackpointer=radius;
    for (y=0;y<h;y++){
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];

      rsum-=routsum;
      gsum-=goutsum;
      bsum-=boutsum;

      stackstart=stackpointer-radius+div;
      sir=stack[stackstart%div];
     
      routsum-=sir[0];
      goutsum-=sir[1];
      boutsum-=sir[2];
     
       if(x==0){
        vmin[y]=min(y+r1,hm)*w;
      }
      p=x+vmin[y];
      
      sir[0]=r[p];
      sir[1]=g[p];
      sir[2]=b[p];
      
      rinsum+=sir[0];
      ginsum+=sir[1];
      binsum+=sir[2];

      rsum+=rinsum;
      gsum+=ginsum;
      bsum+=binsum;

      stackpointer=(stackpointer+1)%div;
      sir=stack[stackpointer];
     
      routsum+=sir[0];
      goutsum+=sir[1];
      boutsum+=sir[2];
      
      rinsum-=sir[0];
      ginsum-=sir[1];
      binsum-=sir[2];

      yi+=w;
    }
  }
  
  //img.updatePixels();
}
