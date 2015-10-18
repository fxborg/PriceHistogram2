//+------------------------------------------------------------------+
//|                                                HistogramTest.mq5 |
//|                                           Copyright 2015, fxborg |
//|                                  http://blog.livedoor.jp/fxborg/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, fxborg"
#property link      "http://blog.livedoor.jp/fxborg/"
#property version   "1.00"
#property indicator_chart_window

#property indicator_buffers 8
#property indicator_plots   8

#property indicator_chart_window
#property indicator_type1 DRAW_ARROW
#property indicator_type2 DRAW_ARROW
#property indicator_type3 DRAW_ARROW
#property indicator_type4 DRAW_ARROW
#property indicator_type5 DRAW_ARROW
#property indicator_type6 DRAW_ARROW
#property indicator_type7 DRAW_ARROW
#property indicator_type8 DRAW_ARROW
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 1
#property indicator_width7 1
#property indicator_width8 1

#property indicator_color1 C'255,0,0'
#property indicator_color2 C'240,0,64'
#property indicator_color3 C'224,0,80'
#property indicator_color4 C'196,0,102'
#property indicator_color5 C'128,0,128'
#property indicator_color6 C'102,0,224'
#property indicator_color7 C'80,0 ,240'
#property indicator_color8 C'64,0,255'

input int FastPeriod=48;
int BinRangeScale=2;
double BinRange=5;
double LtBinRange=BinRange*BinRangeScale;

double Peak1Buffer[];
double Peak2Buffer[];
double Peak3Buffer[];
double Peak4Buffer[];
double Peak5Buffer[];
double Peak6Buffer[];
double Peak7Buffer[];
double Peak8Buffer[];

int min_rates_total;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   min_rates_total=10;
//--- indicator buffers mapping
   SetIndexBuffer(0,Peak1Buffer,INDICATOR_DATA);
   SetIndexBuffer(1,Peak2Buffer,INDICATOR_DATA);
   SetIndexBuffer(2,Peak3Buffer,INDICATOR_DATA);
   SetIndexBuffer(3,Peak4Buffer,INDICATOR_DATA);
   SetIndexBuffer(4,Peak5Buffer,INDICATOR_DATA);
   SetIndexBuffer(5,Peak6Buffer,INDICATOR_DATA);
   SetIndexBuffer(6,Peak7Buffer,INDICATOR_DATA);
   SetIndexBuffer(7,Peak8Buffer,INDICATOR_DATA);
   for(int i=0;i<8;i++)
     {
//      PlotIndexSetInteger(i,PLOT_ARROW,158);
      PlotIndexSetDouble(i,PLOT_EMPTY_VALUE,EMPTY_VALUE);
      PlotIndexSetInteger(i,PLOT_DRAW_BEGIN,min_rates_total);
     }
   string short_name="Histogram Test";
   IndicatorSetString(INDICATOR_SHORTNAME,short_name);
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


   first=10;
   if(first+1<prev_calculated)
      first=prev_calculated-2;
//---
   for(i=first; i<rates_total && !IsStopped(); i++)
     {
      int offset,limit;
      int hist[];
      int peaks[];

      if(generate_histgram(offset,limit,peaks,hist,time[i]))
        {
         int peak_cnt= ArraySize(peaks);
         int line_cnt=0;
         double peak;
         for(int j=0;j<peak_cnt;j++)
           {
            peak=(offset+peaks[j]*BinRange+BinRange/2) *_Point;
            line_cnt++;
            if(line_cnt>8) break;
            if(line_cnt==1) Peak1Buffer[i] = peak;
            if(line_cnt==2) Peak2Buffer[i] = peak;
            if(line_cnt==3) Peak3Buffer[i] = peak;
            if(line_cnt==4) Peak4Buffer[i] = peak;
            if(line_cnt==5) Peak5Buffer[i] = peak;
            if(line_cnt==6) Peak6Buffer[i] = peak;
            if(line_cnt==7) Peak7Buffer[i] = peak;
            if(line_cnt==8) Peak8Buffer[i] = peak;
           }

        }

     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool generate_histgram(
                       int  &offset,
                       int  &limit,
                       int  &m5peaks[],
                       int  &m5hist[],
                       datetime t)
  {
   double m5high[];
   double m5low[];
   long m5vol[];
   ArraySetAsSeries(m5high,true);
   ArraySetAsSeries(m5low,true);
   ArraySetAsSeries(m5vol,true);
   int m5_len1=CopyTickVolume(Symbol(),PERIOD_M15,t,FastPeriod,m5vol);
   int m5_len2=CopyHigh(Symbol(),PERIOD_M15,t,FastPeriod,m5high);
   int m5_len3=CopyLow (Symbol(),PERIOD_M15,t,FastPeriod,m5low);
//--- check copy count
   bool m5_ok=(FastPeriod==m5_len1 && m5_len1==m5_len2 && m5_len2==m5_len3);
   if(!m5_ok)return (false);
//---
   int st_offset=(int)MathRound(m5low[ArrayMinimum(m5low)]/_Point);
   int st_limit=(int)MathRound(m5high[ArrayMaximum(m5high)]/_Point);
//---
   offset = st_offset;
   limit  = st_limit;

   calc_histgram(m5peaks,m5hist,m5high,m5low,m5vol,offset,limit,BinRange,FastPeriod);

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
                   int m5count)
  {
//---
   int j,k;
//--- histgram bin steps
   int steps=(int)MathRound((limit-offset)/binRange)+1;
//--- init
   ArrayResize(hist,steps);
   ArrayInitialize(hist,0);
//--- histgram loop
   for(j=m5count-1;j>=0;j--)
     {
      int l =(int)MathRound(lo[j]/_Point);
      int h =(int)MathRound(hi[j]/_Point);
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
