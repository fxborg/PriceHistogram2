//+------------------------------------------------------------------+
//|                                                Price_HeatMap.mq5 |
//| Price Heat Map                            Copyright 2015, fxborg |
//|                                  http://blog.livedoor.jp/fxborg/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, fxborg"
#property link      "http://blog.livedoor.jp/fxborg/"
#property version   "1.00"
#property indicator_chart_window
#define PIP      ((_Digits <= 3) ? 0.01 : 0.0001)
#property indicator_buffers 81
#property indicator_plots   60

#property indicator_chart_window
#property indicator_type1 DRAW_COLOR_ARROW
#property indicator_type4 DRAW_COLOR_ARROW
#property indicator_type7 DRAW_COLOR_ARROW
#property indicator_type10 DRAW_COLOR_ARROW
#property indicator_type13 DRAW_COLOR_ARROW
#property indicator_type16 DRAW_COLOR_ARROW
#property indicator_type19 DRAW_COLOR_ARROW
#property indicator_type22 DRAW_COLOR_ARROW
#property indicator_type25 DRAW_COLOR_ARROW
#property indicator_type28 DRAW_COLOR_ARROW
#property indicator_type31 DRAW_COLOR_ARROW
#property indicator_type34 DRAW_COLOR_ARROW
#property indicator_type37 DRAW_COLOR_ARROW
#property indicator_type40 DRAW_COLOR_ARROW
#property indicator_type43 DRAW_COLOR_ARROW
#property indicator_type46 DRAW_COLOR_ARROW
#property indicator_type49 DRAW_COLOR_ARROW
#property indicator_type52 DRAW_COLOR_ARROW
#property indicator_type55 DRAW_COLOR_ARROW
#property indicator_type58 DRAW_COLOR_ARROW


#property indicator_width1 4
#property indicator_width4 4
#property indicator_width7 4
#property indicator_width10 4
#property indicator_width13 4
#property indicator_width16 4
#property indicator_width19 4
#property indicator_width22 4
#property indicator_width25 4
#property indicator_width28 4
#property indicator_width31 4
#property indicator_width34 4
#property indicator_width37 4
#property indicator_width40 4
#property indicator_width43 4
#property indicator_width46 4
#property indicator_width49 4
#property indicator_width52 4
#property indicator_width55 4
#property indicator_width58 4

input ENUM_TIMEFRAMES InpHistogramTF=PERIOD_M5;     // Histgram Time Frame
input int InpPeriod=180;    // HistGramPeriod
input double InpBinRange=5.0;
int AvgVolPeriod=100;
double Dmy1Buf[];

double Hst1Buf[];
double Hst2Buf[];
double Hst3Buf[];
double Hst4Buf[];
double Hst5Buf[];
double Hst6Buf[];
double Hst7Buf[];
double Hst8Buf[];
double Hst9Buf[];
double Hst10Buf[];
double Hst11Buf[];
double Hst12Buf[];
double Hst13Buf[];
double Hst14Buf[];
double Hst15Buf[];
double Hst16Buf[];
double Hst17Buf[];
double Hst18Buf[];
double Hst19Buf[];
double Hst20Buf[];

double Col1Buf[];
double Col2Buf[];
double Col3Buf[];
double Col4Buf[];
double Col5Buf[];
double Col6Buf[];
double Col7Buf[];
double Col8Buf[];
double Col9Buf[];
double Col10Buf[];
double Col11Buf[];
double Col12Buf[];
double Col13Buf[];
double Col14Buf[];
double Col15Buf[];
double Col16Buf[];
double Col17Buf[];
double Col18Buf[];
double Col19Buf[];
double Col20Buf[];
double VolBuf[];
int min_rates_total;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(PeriodSeconds(PERIOD_CURRENT)<PeriodSeconds(InpHistogramTF))
     {
      Alert("Histogram Time Frame is too Large");
      return(INIT_FAILED);
     }
   min_rates_total=(int)MathRound(PeriodSeconds(InpHistogramTF)/PeriodSeconds(PERIOD_CURRENT)*InpPeriod)+1;
//--- indicator buffers mapping
   int i=0;
   SetIndexBuffer(i,Hst1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col1Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst2Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col2Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst3Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col3Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst4Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col4Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst5Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col5Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst6Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col6Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst7Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col7Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst8Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col8Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst9Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col9Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst10Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col10Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst11Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col11Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst12Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col12Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst13Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col13Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst14Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col14Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst15Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col15Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst16Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col16Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst17Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col17Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst18Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col18Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst19Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col19Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   SetIndexBuffer(++i,Hst20Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Col20Buf,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_DATA);
   SetIndexBuffer(++i,Dmy1Buf,INDICATOR_COLOR_INDEX);

   i=0;
   while(i<80)
     {
      PlotIndexSetInteger(i,PLOT_ARROW,110);//158 //167
      PlotIndexSetDouble(i,PLOT_EMPTY_VALUE,EMPTY_VALUE);
      PlotIndexSetInteger(i,PLOT_DRAW_BEGIN,min_rates_total);
      setPlotColor(i);

      i+=3;
     }
   i=1;
   while(i<80)
     {
      PlotIndexSetDouble(i,PLOT_EMPTY_VALUE,0);
      i+=3;
     }

   SetIndexBuffer(80,VolBuf,INDICATOR_CALCULATIONS);

   string short_name="Histogram Test";
   IndicatorSetString(INDICATOR_SHORTNAME,short_name);
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits+1);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
//---
   int i,first;
//--- check for bars count
   if(rates_total<=min_rates_total)
      return(0);


   first=min_rates_total;
   if(first+1<prev_calculated)
      first=prev_calculated-2;
//---
   for(i=first; i<rates_total && !IsStopped(); i++)
     {
      int  peaks[];
      int  hist[];
      int  offset;

      Hst1Buf[i]=EMPTY_VALUE;
      Hst2Buf[i]=EMPTY_VALUE;
      Hst3Buf[i]=EMPTY_VALUE;
      Hst4Buf[i]=EMPTY_VALUE;
      Hst5Buf[i]=EMPTY_VALUE;
      Hst6Buf[i]=EMPTY_VALUE;
      Hst7Buf[i]=EMPTY_VALUE;
      Hst8Buf[i]=EMPTY_VALUE;
      Hst9Buf[i]=EMPTY_VALUE;
      Hst10Buf[i]=EMPTY_VALUE;
      Hst11Buf[i]=EMPTY_VALUE;
      Hst12Buf[i]=EMPTY_VALUE;
      Hst13Buf[i]=EMPTY_VALUE;
      Hst14Buf[i]=EMPTY_VALUE;
      Hst15Buf[i]=EMPTY_VALUE;
      Hst16Buf[i]=EMPTY_VALUE;
      Hst17Buf[i]=EMPTY_VALUE;
      Hst18Buf[i]=EMPTY_VALUE;
      Hst19Buf[i]=EMPTY_VALUE;
      Hst20Buf[i]=EMPTY_VALUE;


      Col1Buf[i]=0;
      Col2Buf[i]=0;
      Col3Buf[i]=0;
      Col4Buf[i]=0;
      Col5Buf[i]=0;
      Col6Buf[i]=0;
      Col7Buf[i]=0;
      Col8Buf[i]=0;
      Col9Buf[i]=0;
      Col10Buf[i]=0;
      Col11Buf[i]=0;
      Col12Buf[i]=0;
      Col13Buf[i]=0;
      Col14Buf[i]=0;
      Col15Buf[i]=0;
      Col16Buf[i]=0;
      Col17Buf[i]=0;
      Col18Buf[i]=0;
      Col19Buf[i]=0;
      Col20Buf[i]=0;

      if(!generate_histgram(offset,peaks,hist,time[i],InpHistogramTF,InpBinRange,InpPeriod))
         continue;

      int sz=ArraySize(hist);
      int imax=sz-1;
      double max_hist=1;

      int peak_cnt=ArraySize(peaks);
      int peak_j=0;
      if(peak_cnt>0)
        {
         peak_j=peaks[0];
         max_hist=hist[peak_j];
        }
      VolBuf[i]=(double)tick_volume[i];
      if(min_rates_total+AvgVolPeriod>=i) continue;
      long avg=0;
      int c=MathMax(1,peak_j);

      for(int k=0;k<AvgVolPeriod;k++) avg+=(long)VolBuf[i-k];

      avg=(long)MathRound(avg/AvgVolPeriod);
      double histogram_bars=(PeriodSeconds(InpHistogramTF)/PeriodSeconds(PERIOD_CURRENT)*InpPeriod)+1;
      double cur_vol=0;
      for(int k=0;k<histogram_bars;k++)
         {
         cur_vol+=tick_volume[i];
         }
      cur_vol/=histogram_bars;
      if(cur_vol<avg)
         max_hist=max_hist*2;

      int pos=0;
      if(imax>20)
        {

         if(peak_j>-1)
            pos=(int)MathMax(0,peak_j-5);
         else
            pos=(int)MathRound((imax-20)/2);
        }
      for(int j=1;j<=20;j++)
        {
         int col=0;

         double peak=EMPTY_VALUE;
         if(pos<sz)
           {

            peak=(offset+pos*InpBinRange+InpBinRange/2) *PIP;

            col=MathMin(25,(int)MathRound((hist[pos]/max_hist)*25));

            if(j==1)  {Hst1Buf[i]= peak;   Col1Buf[i]= col;}
            if(j==2)  {Hst2Buf[i]= peak;   Col2Buf[i]= col;}
            if(j==3)  {Hst3Buf[i]= peak;   Col3Buf[i]= col;}
            if(j==4)  {Hst4Buf[i]= peak;   Col4Buf[i]= col;}
            if(j==5)  {Hst5Buf[i]= peak;   Col5Buf[i]= col;}
            if(j==6)  {Hst6Buf[i]= peak;   Col6Buf[i]= col;}
            if(j==7)  {Hst7Buf[i]= peak;   Col7Buf[i]= col;}
            if(j==8)  {Hst8Buf[i]= peak;   Col8Buf[i]= col;}
            if(j==9)  {Hst9Buf[i]= peak;   Col9Buf[i]= col;}
            if(j==10) {Hst10Buf[i]= peak;  Col10Buf[i]= col;}
            if(j==11) {Hst11Buf[i]= peak;  Col11Buf[i]= col;}
            if(j==12) {Hst12Buf[i]= peak;  Col12Buf[i]= col;}
            if(j==13) {Hst13Buf[i]= peak;  Col13Buf[i]= col;}
            if(j==14) {Hst14Buf[i]= peak;  Col14Buf[i]= col;}
            if(j==15) {Hst15Buf[i]= peak;  Col15Buf[i]= col;}
            if(j==16) {Hst16Buf[i]= peak;  Col16Buf[i]= col;}
            if(j==17) {Hst17Buf[i]= peak;  Col17Buf[i]= col;}
            if(j==18) {Hst18Buf[i]= peak;  Col18Buf[i]= col;}
            if(j==19) {Hst19Buf[i]= peak;  Col19Buf[i]= col;}
            if(j==20) {Hst20Buf[i]= peak;  Col20Buf[i]= col;}

           }

         pos++;
        }

     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool generate_histgram(
                       int  &offset,
                       int  &tf_peaks[],
                       int  &tf_hist[],
                       datetime t,

                       ENUM_TIMEFRAMES tf,
                       double binRange,
                       int histPeriod
                       )
  {
   double tf_high[];
   double tf_low[];
   long tf_vol[];
   ArraySetAsSeries(tf_high,true);
   ArraySetAsSeries(tf_low,true);
   ArraySetAsSeries(tf_vol,true);
   int tf_len1=CopyTickVolume(Symbol(),tf,t,histPeriod,tf_vol);
   int tf_len2=CopyHigh(Symbol(),tf,t,histPeriod,tf_high);
   int tf_len3=CopyLow (Symbol(),tf,t,histPeriod,tf_low);
//--- check copy count
   bool tf_ok=(histPeriod==tf_len1 && tf_len1==tf_len2 && tf_len2==tf_len3);
   if(!tf_ok)return (false);
//---
   offset=(int)MathRound(tf_low[ArrayMinimum(tf_low)]/PIP);
   int limit=(int)MathRound(tf_high[ArrayMaximum(tf_high)]/PIP);
//---

   calc_histgram(tf_peaks,tf_hist,tf_high,tf_low,tf_vol,offset,limit,binRange,histPeriod);

//---
   return (true);
  }
//+------------------------------------------------------------------+
//| calc histgram                                                    |
//+------------------------------------------------------------------+
bool calc_histgram(int &peaks[],
                   int &hist[],
                   const double  &hi[],
                   const double  &lo[],
                   const long  &vol[],
                   int offset,
                   int limit,
                   double binRange,
                   int histPeriod
                   )
  {
//---
   int j,k;
//--- histgram bin steps
   int steps=(int)MathRound((limit-offset)/binRange)+1;
//--- init
   ArrayResize(hist,steps);
   ArrayInitialize(hist,0);
//--- histgram loop
   for(j=histPeriod-1;j>=0;j--)
     {
      int l =(int)MathRound(lo[j]/PIP);
      int h =(int)MathRound(hi[j]/PIP);
      int v=(int)MathRound(MathSqrt(MathMin(vol[j],1)));
      int min = (int)MathRound((l-offset)/binRange);
      int max = (int)MathRound((h-offset)/binRange);
      //--- for normal
      for(k=min;k<=max;k++)hist[k]+=v;
     }
//--- find peaks
   int work[][2];
//--- find peaks
   int peak_count=find_peaks(work,hist,steps,binRange);
   ArrayResize(peaks,0,peak_count);
   int top=0;
   int cnt=0;
   for(j=peak_count-1;j>=0;j--)
     {
      if(j==(peak_count-1))top=work[j][0];
      if(work[j][0]>top*0.1)
        {
         cnt++;
         ArrayResize(peaks,cnt,peak_count);
         peaks[cnt-1]=work[j][1];
        }
     }

   return (true);
  }
//+------------------------------------------------------------------+
//|  Find peaks                                                      |
//+------------------------------------------------------------------+
int find_peaks(int &peaks[][2],const int  &hist[],int steps,double binrange)
  {
   if(steps<=10)
     {
      ArrayResize(peaks,1);
      peaks[0][1] = ArrayMaximum(hist);
      peaks[0][0] =hist[peaks[0][1]];
      return 1;
     }
   int count=0;
   for(int i=2;i<steps-2;i++)
     {
      int max=MathMax(MathMax(MathMax(MathMax(
                      hist[i-2],hist[i-1]),hist[i]),hist[i+1]),hist[i+2]);
      if(hist[i]==max)
        {
         count++;
         ArrayResize(peaks,count);
         int total=hist[i-2]+hist[i-1]+hist[i]+hist[i+1]+hist[i+2];
         peaks[count-1][0] = total;
         peaks[count-1][1] = i;
        }
     }
   if(count>1)
     {
      ArraySort(peaks);
     }
//---
   return(count);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setPlotColor(int plot)
  {
   PlotIndexSetInteger(plot,PLOT_COLOR_INDEXES,26); //Set number of colors                                                    //Specify colors in loop
   int n=0;
   for(int i=0;i<=12;i++)
     {
      PlotIndexSetInteger(plot,PLOT_LINE_COLOR,n++,toRGB(100+i*13,153+int(MathRound(i*8.5)),0));
     }
   for(int i=1;i<=13;i++)
     {
      PlotIndexSetInteger(plot,PLOT_LINE_COLOR,n++,toRGB(255,255-i*20,0));

     }

  }
//+------------------------------------------------------------------+
color toRGB(int r,int g,int b)
  {
   r=MathMin(255,MathMax(0,r));
   g=MathMin(255,MathMax(0,g));
   b=MathMin(255,MathMax(0,b));
   return StringToColor(IntegerToString(r)+","+IntegerToString(g)+","+IntegerToString(b));
  }
//+------------------------------------------------------------------+
