//+------------------------------------------------------------------+
//|                                 Price_Hestgram_channel_v1.00.mq5 |
//| Price Histgram Chanel                     Copyright 2015, fxborg |
//|                                  http://blog.livedoor.jp/fxborg/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, fxborg"
#property link      "http://blog.livedoor.jp/fxborg/"
#property version   "1.00"
#property indicator_chart_window
#define PIP      ((_Digits <= 3) ? 0.01 : 0.0001)
#property indicator_buffers 10
#property indicator_plots   4

#property indicator_chart_window
#property indicator_label1 "1"
#property indicator_label2 "2"
#property indicator_label3 "3"
#property indicator_label4 "4"

#property indicator_type1 DRAW_FILLING
#property indicator_type2 DRAW_FILLING
#property indicator_type3 DRAW_FILLING
#property indicator_type4 DRAW_FILLING


#property indicator_color1 C'0,0,0',C'60,60,60'
#property indicator_color2 C'0,0,0',C'90,80,90'
#property indicator_color3 C'0,0,0',C'130,30,30'
#property indicator_color4 C'0,0,0',C'140,60,60'



#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1

input ENUM_TIMEFRAMES InpHistogramTF=PERIOD_M5;     // Histgram Time Frame
input int InpPeriod=180;    // HistGramPeriod
input double InpBinRange=5.0;  //BinRange
input bool InpShowBars=false;   // ShowBars
input int InpColorPattern=2;   // 1:Green  2:Blue 
input int InpColorFrom=10;   // Color From : 0-25 

int AvgVolPeriod=100;

double Hst1aL_Buf[];
double Hst1aH_Buf[];
double Hst1bL_Buf[];
double Hst1bH_Buf[];

double Hst2L_Buf[];
double Hst2H_Buf[];
double Hst3L_Buf[];
double Hst3H_Buf[];
double CheckBuf[];
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
   min_rates_total=(int)MathRound(PeriodSeconds(InpHistogramTF)/PeriodSeconds(PERIOD_CURRENT)*InpPeriod)+AvgVolPeriod+1;
//--- indicator buffers mapping
   int i=0;

   PlotIndexSetInteger(i,PLOT_ARROW,160);//110//158 //167
   PlotIndexSetDouble(i,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetInteger(i,PLOT_DRAW_BEGIN,min_rates_total);

   SetIndexBuffer(0,Hst3L_Buf,INDICATOR_DATA);
   SetIndexBuffer(1,Hst3H_Buf,INDICATOR_DATA);
   SetIndexBuffer(2,Hst2L_Buf,INDICATOR_DATA);
   SetIndexBuffer(3,Hst2H_Buf,INDICATOR_DATA);
   SetIndexBuffer(4,Hst1bL_Buf,INDICATOR_DATA);
   SetIndexBuffer(5,Hst1bH_Buf,INDICATOR_DATA);
   SetIndexBuffer(6,Hst1aL_Buf,INDICATOR_DATA);
   SetIndexBuffer(7,Hst1aH_Buf,INDICATOR_DATA);
   SetIndexBuffer(8,VolBuf,INDICATOR_CALCULATIONS);
   SetIndexBuffer(9,CheckBuf,INDICATOR_CALCULATIONS);
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(2,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(3,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(4,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(5,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(6,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(7,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(8,PLOT_EMPTY_VALUE,0);
   PlotIndexSetDouble(9,PLOT_EMPTY_VALUE,0);
   string short_name="Price Histgram Channel v1.00";
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
   if(first+1<prev_calculated && CheckBuf[prev_calculated-3]==1.0)
      first=prev_calculated-2;
//---
   for(i=first; i<rates_total && !IsStopped(); i++)
     {
      Hst1aL_Buf[i]=0.0;
      Hst1aH_Buf[i]=0.0;
      Hst1bL_Buf[i]=0.0;
      Hst1bH_Buf[i]=0.0;
      Hst2L_Buf[i]=0.0;
      Hst2H_Buf[i]=0.0;
      Hst3L_Buf[i]=0.0;
      Hst3H_Buf[i]=0.0;


      //---
      int  peaks[];
      int  hist[];
      int  offset;
      //---

      if(!generate_histgram(offset,peaks,hist,time[i],InpHistogramTF,InpBinRange,InpPeriod))
         continue;
      //---
      CheckBuf[i]=1.0;

      int sz=ArraySize(hist);
      int imax=sz-1;
      double max_hist=1;

      int peak_cnt=ArraySize(peaks);
      int peak_j=0;
      //---
      if(peak_cnt>0)
        {
         peak_j=peaks[0];
         max_hist=hist[peak_j];
        }
      //---
      VolBuf[i]=(double)tick_volume[i];
      //---
      if(min_rates_total+AvgVolPeriod>=i) continue;
      long avg=0;
      //---
      for(int k=0;k<AvgVolPeriod;k++) avg+=(long)VolBuf[i-k];
      //---

      //---
      avg=(long)MathRound(avg/AvgVolPeriod);
      double histogram_bars=(PeriodSeconds(InpHistogramTF)/PeriodSeconds(PERIOD_CURRENT)*InpPeriod)+1;
      double cur_vol=0;
      //---
      for(int k=0;k<histogram_bars;k++)
        {
         cur_vol+=(double)tick_volume[i];
        }
      //---
      cur_vol/=histogram_bars;
      //---
      if(cur_vol<avg*0.8)
         max_hist=MathRound(max_hist*1.5);
      //---

      int dn,up;
      calc_range(dn,up,hist,peak_j,0.95);
      Hst3L_Buf[i]=(offset+dn*InpBinRange) *PIP;
      Hst3H_Buf[i]=(offset+up*InpBinRange+InpBinRange) *PIP;

      //---
      calc_range(dn,up,hist,peak_j,0.65);
      Hst2L_Buf[i]=(offset+dn*InpBinRange)*PIP;
      Hst2H_Buf[i]=(offset+up*InpBinRange+InpBinRange)*PIP;

      //---
      calc_hotspot(dn,up,hist,peak_j,max_hist,0.7);
      if(dn!=-1)
        {
         Hst1aL_Buf[i]=(offset+dn*InpBinRange) *PIP;
         Hst1aH_Buf[i]=(offset+up*InpBinRange+InpBinRange) *PIP;
         if(Hst1aL_Buf[i-1]==0)
           {
           Hst1aL_Buf[i-1]=Hst1aL_Buf[i];
           Hst1aH_Buf[i-1]=Hst1aH_Buf[i];
           }

        }
      else
        {
         calc_hotspot(dn,up,hist,peak_j,max_hist,0.6);
         if(dn!=-1)calc_range(dn,up,hist,peak_j,0.25);
         Hst1bL_Buf[i]=(offset+dn*InpBinRange) *PIP;
         Hst1bH_Buf[i]=(offset+up*InpBinRange+InpBinRange) *PIP;
         if(Hst1bL_Buf[i-1]==0)
           {
           Hst1bL_Buf[i-1]=Hst1bL_Buf[i];
           Hst1bH_Buf[i-1]=Hst1bH_Buf[i];
           }
        }

      //---

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
void calc_range(int  &under,int &upper,const int &hist[],int top,double rangeRate)
  {
   int h=top;
   int l=top;
   long h_total = 0;
   long l_total = 0;
   int len=ArraySize(hist);
   long higher=0;
   long lower=0;
   int i;
   for(i=top;i<len;i++) h_total+=hist[i];
   for(i=top;i>=0;i--)l_total+=hist[i];
   for(i=top;i<len;i++)
     {
      if(rangeRate*h_total<higher)break;
      higher+=hist[i];
      h=i;
     }
   for(i=top;i>=0;i--)
     {
      if(rangeRate*l_total<lower)break;
      lower+=hist[i];
      l=i;
     }
   upper= h;
   under= l;
  }
//+------------------------------------------------------------------+
void calc_hotspot(int  &under,int &upper,const int &hist[],int top,double top_value,double rate)
  {
   if(top_value*rate>hist[top])
     {
      under =-1;
      upper =-1;
      return;
     }

   int len=ArraySize(hist);

   int h=top;
   int l=top;
   int i;
   for(i=top;i>=0;i--)
     {
      if(hist[i]<top_value*rate)break;
      l=i;
     }
//---
   for(i=top;i<len;i++)
     {
      if(hist[i]<top_value*rate)break;
      h=i;
     }
   under=l;
   upper=h;

  }
//+------------------------------------------------------------------+
