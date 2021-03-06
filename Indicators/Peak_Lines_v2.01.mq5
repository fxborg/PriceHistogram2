//+------------------------------------------------------------------+
//|                                                   Peak_Lines.mq5 |
//|                                           Copyright 2015, fxborg |
//|                                  http://blog.livedoor.jp/fxborg/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, fxborg"
#property link      "http://blog.livedoor.jp/fxborg/"
#property version   "2.01"

#property indicator_chart_window
#property indicator_buffers 23
#property indicator_plots   10
#define PIP      ((_Digits <= 3) ? 0.01 : 0.0001)
#define DATA_SIZE 1000

#property indicator_chart_window
#property indicator_type1 DRAW_FILLING
#property indicator_type2 DRAW_FILLING
#property indicator_type3 DRAW_FILLING
#property indicator_type4 DRAW_FILLING
#property indicator_type5 DRAW_FILLING
#property indicator_type6 DRAW_FILLING
#property indicator_type7 DRAW_FILLING
#property indicator_type8 DRAW_FILLING
#property indicator_type9 DRAW_FILLING
#property indicator_type10 DRAW_FILLING

#property indicator_color1 Indigo,Indigo
#property indicator_color2 Indigo,Indigo
#property indicator_color3 Indigo,Indigo
#property indicator_color4 Indigo,Indigo
#property indicator_color5 Indigo,Indigo
#property indicator_color6 Indigo,Indigo
#property indicator_color7 Indigo,Indigo
#property indicator_color8 Indigo,Indigo
#property indicator_color9 Indigo,Indigo
#property indicator_color10 Indigo,Indigo
//---
input ENUM_TIMEFRAMES HistogramTF=PERIOD_M5;     // Histogram Time Frame
input  int PeakPeriod=24;    // HistogramPeriod(hour)
input  int BinRange=5;         // BinRange
input  int Expiration=20;      //Expiration(day)
input  int CalcInterval=15;    // CalcInterval(min)
//---

int Interval=CalcInterval*60;
//---
int expire=3600*24*60*Expiration;
//---
int HistogramPeriod=(int)MathRound(PeriodSeconds(PERIOD_CURRENT)/PeriodSeconds(HistogramTF)*PeakPeriod);
//---

//---
double P1aBuffer[];
double P1bBuffer[];
double P2aBuffer[];
double P2bBuffer[];
double P3aBuffer[];
double P3bBuffer[];
double P4aBuffer[];
double P4bBuffer[];
double P5aBuffer[];
double P5bBuffer[];
double P6aBuffer[];
double P6bBuffer[];
double P7aBuffer[];
double P7bBuffer[];
double P8aBuffer[];
double P8bBuffer[];
double P9aBuffer[];
double P9bBuffer[];
double P10aBuffer[];
double P10bBuffer[];
//---

//---
double LastPos[];
double DataTimeBuffer[];
double DataBuffer[];
//---

//---
int min_rates_total;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   int err=0;
   while(!(bool)SeriesInfoInteger(Symbol(),0,SERIES_SYNCHRONIZED) && err<10)
     {
      Sleep(500);
      err++;
     }
//---

//---
   min_rates_total=DATA_SIZE*2;
//---

//--- indicator buffers mapping
   SetIndexBuffer(0,P1aBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,P1bBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,P2aBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,P2bBuffer,INDICATOR_DATA);
   SetIndexBuffer(4,P3aBuffer,INDICATOR_DATA);
   SetIndexBuffer(5,P3bBuffer,INDICATOR_DATA);
   SetIndexBuffer(6,P4aBuffer,INDICATOR_DATA);
   SetIndexBuffer(7,P4bBuffer,INDICATOR_DATA);
   SetIndexBuffer(8,P5aBuffer,INDICATOR_DATA);
   SetIndexBuffer(9,P5bBuffer,INDICATOR_DATA);
   SetIndexBuffer(10,P6aBuffer,INDICATOR_DATA);
   SetIndexBuffer(11,P6bBuffer,INDICATOR_DATA);
   SetIndexBuffer(12,P7aBuffer,INDICATOR_DATA);
   SetIndexBuffer(13,P7bBuffer,INDICATOR_DATA);
   SetIndexBuffer(14,P8aBuffer,INDICATOR_DATA);
   SetIndexBuffer(15,P8bBuffer,INDICATOR_DATA);
   SetIndexBuffer(16,P9aBuffer,INDICATOR_DATA);
   SetIndexBuffer(17,P9bBuffer,INDICATOR_DATA);
   SetIndexBuffer(18,P10aBuffer,INDICATOR_DATA);
   SetIndexBuffer(19,P10bBuffer,INDICATOR_DATA);
   SetIndexBuffer(20,DataBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(21,DataTimeBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(22,LastPos,INDICATOR_CALCULATIONS);

   for(int i=0;i<=19;i++)
     {
      PlotIndexSetDouble(i,PLOT_EMPTY_VALUE,EMPTY_VALUE);
      PlotIndexSetInteger(i,PLOT_DRAW_BEGIN,min_rates_total);
     }
   PlotIndexSetDouble(20,PLOT_EMPTY_VALUE,EMPTY_VALUE);
   PlotIndexSetDouble(21,PLOT_EMPTY_VALUE,0);
   PlotIndexSetDouble(22,PLOT_EMPTY_VALUE,0);

   string short_name="PeakLines v2.01";
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

   first=min_rates_total;
   if(first+1<prev_calculated && P1aBuffer[prev_calculated-3]!=0)
      first=prev_calculated-2;
//---
   for(i=first; i<rates_total && !IsStopped(); i++)
     {
      bool is_update=false;
      if(time[i-1]-30<time[i]-Interval)
        {
         is_update=true;
         calc_peaks(HistogramTF,BinRange,HistogramPeriod,i,time[i],1);

        }

      double ma=(close[i]);
      double res=getPeaks(close[i],BinRange*3,i,time[i]);

      if(res>0.0)
        {
         append_peaks(i,res-BinRange*PIP*0.75,res+BinRange*PIP*0.75);
        }
      else
        {

         P1aBuffer[i] = P1aBuffer[i-1];
         P2aBuffer[i] = P2aBuffer[i-1];
         P3aBuffer[i] = P3aBuffer[i-1];
         P4aBuffer[i] = P4aBuffer[i-1];
         P5aBuffer[i] = P5aBuffer[i-1];
         P6aBuffer[i] = P6aBuffer[i-1];
         P7aBuffer[i] = P7aBuffer[i-1];
         P8aBuffer[i] = P8aBuffer[i-1];
         P9aBuffer[i] = P9aBuffer[i-1];
         P10aBuffer[i]= P10aBuffer[i-1];

         P1bBuffer[i] = P1bBuffer[i-1];
         P2bBuffer[i] = P2bBuffer[i-1];
         P3bBuffer[i] = P3bBuffer[i-1];
         P4bBuffer[i] = P4bBuffer[i-1];
         P5bBuffer[i] = P5bBuffer[i-1];
         P6bBuffer[i] = P6bBuffer[i-1];
         P7bBuffer[i] = P7bBuffer[i-1];
         P8bBuffer[i] = P8bBuffer[i-1];
         P9bBuffer[i] = P9bBuffer[i-1];
         P10bBuffer[i]= P10bBuffer[i-1];
        }

     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
void calc_peaks(ENUM_TIMEFRAMES tf,int binRange,int period,int i,datetime t,int limit)
  {
   int  peaks[];
   int  hist[];
   int  offset;
   if(generate_histogram(offset,peaks,hist,t,tf,binRange,period))
     {
      int peak_cnt=ArraySize(peaks);
      if(peak_cnt>0)
        {
         int line_cnt=0;
         for(int j=0;j<MathMin(limit,peak_cnt);j++)
           {
            double peak=(offset+peaks[j]*binRange+binRange/2) *PIP;
            append_data(peak,t);

           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool generate_histogram(
                        int  &offset,
                        int  &tf_peaks[],
                        int  &tf_hist[],
                        datetime t,

                        ENUM_TIMEFRAMES tf,
                        int binRange,
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

   return calc_histogram(tf_peaks,tf_hist,tf_high,tf_low,tf_vol,offset,limit,binRange,histPeriod);

  }
//+------------------------------------------------------------------+
//| calc histogram                                                    |
//+------------------------------------------------------------------+
bool calc_histogram(int &peaks[],
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
//--- histogram bin steps
   int steps=(int)MathRound((limit-offset)/binRange)+1;
//--- init
   ArrayResize(hist,steps);
   ArrayInitialize(hist,0);
//--- histogram loop
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

   return (cnt>0);
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
   if(count==0)
     {
      ArrayResize(peaks,1);
      peaks[0][1] = ArrayMaximum(hist);
      peaks[0][0] =hist[peaks[0][1]];
     }
//---
   return(count);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void append_data(double v,datetime t)
  {

//---
   int lastpos=(int)LastPos[0];
   DataBuffer[lastpos]=v;
   DataTimeBuffer[lastpos]=(double)t;
   LastPos[0]=(lastpos+1)%DATA_SIZE;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double data_at(const int index,datetime t)
  {
   if(index < 0 && index >= DATA_SIZE) return EMPTY_VALUE;

   int lastpos=(int)LastPos[0];
   int pos=lastpos-index-1;
   pos=((DATA_SIZE+pos)%DATA_SIZE);
   if((t-expire)>DataTimeBuffer[pos])return EMPTY_VALUE;
   return DataBuffer[pos];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void append_peaks(int i,double a,double b)
  {

   P1aBuffer[i]=a;
   P2aBuffer[i]=P1aBuffer[i-1];
   P3aBuffer[i]=P2aBuffer[i-1];
   P4aBuffer[i]=P3aBuffer[i-1];
   P5aBuffer[i]=P4aBuffer[i-1];
   P6aBuffer[i]=P5aBuffer[i-1];
   P7aBuffer[i]=P6aBuffer[i-1];
   P8aBuffer[i]=P7aBuffer[i-1];
   P9aBuffer[i]=P8aBuffer[i-1];
   P10aBuffer[i]=P9aBuffer[i-1];

   P1bBuffer[i]=b;
   P2bBuffer[i]=P1bBuffer[i-1];
   P3bBuffer[i]=P2bBuffer[i-1];
   P4bBuffer[i]=P3bBuffer[i-1];
   P5bBuffer[i]=P4bBuffer[i-1];
   P6bBuffer[i]=P5bBuffer[i-1];
   P7bBuffer[i]=P6bBuffer[i-1];
   P8bBuffer[i]=P7bBuffer[i-1];
   P9bBuffer[i]=P8bBuffer[i-1];
   P10bBuffer[i]=P9bBuffer[i-1];

   P1aBuffer[i-1]=0.0;
   P2aBuffer[i-1]=0.0;
   P3aBuffer[i-1]=0.0;
   P4aBuffer[i-1]=0.0;
   P5aBuffer[i-1]=0.0;
   P6aBuffer[i-1]=0.0;
   P7aBuffer[i-1]=0.0;
   P8aBuffer[i-1]=0.0;
   P9aBuffer[i-1]=0.0;
   P10aBuffer[i-1]=0.0;

   P1bBuffer[i-1]=0.0;
   P2bBuffer[i-1]=0.0;
   P3bBuffer[i-1]=0.0;
   P4bBuffer[i-1]=0.0;
   P5bBuffer[i-1]=0.0;
   P6bBuffer[i-1]=0.0;
   P7bBuffer[i-1]=0.0;
   P8bBuffer[i-1]=0.0;
   P9bBuffer[i-1]=0.0;
   P10bBuffer[i-1]=0.0;

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void calc_range(int  &under,int &upper,const int &hist[],int top,double rate)
  {
   double limit_value=hist[top]*rate;

   under =top;
   upper =top;

   int len=ArraySize(hist);

   int h=top;
   int l=top;
   int i;
   for(i=0;i<len;i++)
     {
      if(hist[i]>=limit_value)break;
      l=i;
     }

//---
   for(i=len-1;i>=0;i--)
     {
      if(hist[i]>=limit_value)break;
      h=i;
     }
   under=l;
   upper=h;

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getPeaks(double v,int binRange,int i,datetime t)
  {
   double min=v-binRange*PIP*1.5;
   double max=v+binRange*PIP*1.5;
   double p1=(P1aBuffer[i-1]+P1bBuffer[i-1])/2;
   double p2=(P2aBuffer[i-1]+P2bBuffer[i-1])/2;
   double p3=(P3aBuffer[i-1]+P3bBuffer[i-1])/2;
   double p4=(P4aBuffer[i-1]+P4bBuffer[i-1])/2;
   double p5=(P5aBuffer[i-1]+P5bBuffer[i-1])/2;
   double p6=(P6aBuffer[i-1]+P6bBuffer[i-1])/2;
   double p7=(P7aBuffer[i-1]+P7bBuffer[i-1])/2;
   double p8=(P8aBuffer[i-1]+P8bBuffer[i-1])/2;
   double p9=(P9aBuffer[i-1]+P9bBuffer[i-1])/2;
   double p10=(P10aBuffer[i-1]+P10bBuffer[i-1])/2;

   if(min <= p1 && p1 <= max) return 0.0;
   if(min <= p2 && p2 <= max) return 0.0;
   if(min <= p3 && p3 <= max) return 0.0;
   if(min <= p4 && p4 <= max) return 0.0;
   if(min <= p5 && p5 <= max) return 0.0;
   if(min <= p6 && p6 <= max) return 0.0;
   if(min <= p7 && p7 <= max) return 0.0;
   if(min <= p8 && p8 <= max) return 0.0;
   if(min <= p9 && p8 <= max) return 0.0;
   if(min <= p10 && p10 <= max) return 0.0;

   min=v-binRange*PIP;
   max=v+binRange*PIP;

   for(int j=0;j<DATA_SIZE;j++)
     {
      double peek=data_at(j,t);
      if(peek==EMPTY_VALUE)continue;
      if(min <= peek && peek <= max) return peek;
     }
   return 0.0;
  }
//+------------------------------------------------------------------+
