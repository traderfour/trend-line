//+------------------------------------------------------------------+
//|                               TrendLinesWithBreaks-Indicator.mq5 |
//|                                       Trader4.net, Just A Trader |
//|                                              https://trader4.net |
//+------------------------------------------------------------------+
#property copyright "Trader4.net, Just A Trader"
#property link      "https://trader4.net"
#property version   "1.10"

#property indicator_chart_window
#property indicator_buffers 17
#property indicator_plots   4

#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrLimeGreen
#property indicator_width1  3

#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_width2  3

input int length = 14;
input double k = 1.; //Slope
enum ENUM_Method
{
   Atr,
   Stdev,
   Linreg
};
input ENUM_Method method = Atr; //Slope Calculation Method

 //bool show = true; //Show Only Confirmed Breakouts

double ph[], pl[], slope[], slope_ph[], slope_pl[], upper[], lower[], AlreadyBrokeout_upper[], AlreadyBrokeout_lower[], Breakout_Buy[], Breakout_Sell[], SL_Buy[], SL_Sell[], TempSL_Buy[], TempSL_Sell[];
double Last_ph_time[], Last_pl_time[];
const string ObjPref = "TLB-";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//--- indicator buffers mapping
   if (!CreateIndicatorsHandles()) return(INIT_FAILED);
   
   SetIndexBuffer(0,Breakout_Buy); ArrayInitialize(Breakout_Buy, 0);
   SetIndexBuffer(1,Breakout_Sell); ArrayInitialize(Breakout_Sell, 0);
   PlotIndexSetInteger(0, PLOT_ARROW, 233);
   PlotIndexSetInteger(1, PLOT_ARROW, 234);
   SetIndexBuffer(2,SL_Buy); ArrayInitialize(SL_Buy, 0);
   SetIndexBuffer(3,SL_Sell); ArrayInitialize(SL_Sell, 0);
   PlotIndexSetInteger(2, PLOT_DRAW_TYPE, DRAW_NONE);
   PlotIndexSetInteger(3, PLOT_DRAW_TYPE, DRAW_NONE);
   
   SetIndexBuffer(4,upper, INDICATOR_CALCULATIONS); ArrayInitialize(upper, 0);
   SetIndexBuffer(5,lower, INDICATOR_CALCULATIONS); ArrayInitialize(lower, 0);
   SetIndexBuffer(6,ph, INDICATOR_CALCULATIONS); ArrayInitialize(ph, 0);
   SetIndexBuffer(7,pl, INDICATOR_CALCULATIONS); ArrayInitialize(pl, 0);
   SetIndexBuffer(8,slope, INDICATOR_CALCULATIONS); ArrayInitialize(slope, 0);
   SetIndexBuffer(9,slope_ph, INDICATOR_CALCULATIONS); ArrayInitialize(slope_ph, 0);
   SetIndexBuffer(10,slope_pl, INDICATOR_CALCULATIONS); ArrayInitialize(slope_pl, 0);
   SetIndexBuffer(11,AlreadyBrokeout_upper, INDICATOR_CALCULATIONS); ArrayInitialize(AlreadyBrokeout_upper, 0);
   SetIndexBuffer(12,AlreadyBrokeout_lower, INDICATOR_CALCULATIONS); ArrayInitialize(AlreadyBrokeout_lower, 0);
   SetIndexBuffer(13,TempSL_Buy); ArrayInitialize(TempSL_Buy, 0);
   SetIndexBuffer(14,TempSL_Sell); ArrayInitialize(TempSL_Sell, 0);
   SetIndexBuffer(15,Last_ph_time); ArrayInitialize(Last_ph_time, 0);
   SetIndexBuffer(16,Last_pl_time); ArrayInitialize(Last_pl_time, 0);
   
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0); PlotIndexSetString(0,PLOT_LABEL,"Buy Breakout");
   PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, 0); PlotIndexSetString(1,PLOT_LABEL,"Sell Breakout");
   PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, 0); PlotIndexSetString(2,PLOT_LABEL,"Buy SL");
   PlotIndexSetDouble(3, PLOT_EMPTY_VALUE, 0); PlotIndexSetString(3,PLOT_LABEL,"Sell SL");
   
   string short_name=StringFormat("TrendLinesWithBreaks(%d)",length);
   IndicatorSetString(INDICATOR_SHORTNAME,short_name);
  
   ObjectsDeleteAll(0, ObjPref);
//---
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0, ObjPref);
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
   if (rates_total < 2*length+1) return(0);
   
   int start;
   if (prev_calculated < length+1) start = length+1;
   else start = prev_calculated-(length+1);
   
   for (int i = start; i < rates_total; i++)
   {
      ph[i] = PivotHigh(length, length, rates_total, i);
      pl[i] = PivotLow(length, length, rates_total, i);
      
      //Calculate slop
      {
      if (method == Atr) 
      {
         double ATR = GetBufferValue(ATR_Handle, 0, rates_total-1-i);
         if (ATR == 0 || ATR == EMPTY_VALUE) slope[i] = 0;
         else slope[i] = ATR/(length*k);
      }
      else if (method == Stdev) 
      {
         double StdDev = GetBufferValue(StdDev_Handle, 0, rates_total-1-i);
         if (StdDev == 0 || StdDev == EMPTY_VALUE) slope[i] = 0;
         else slope[i] = StdDev/(length*k);
      }
      else if (method == Linreg) 
      {
         {               
            double SMA_src = 0, SMA_BarIndex = 0, SMA_src_BarIndexl = 0;
            for(int j = i; j > i-length; j--)
            {
               SMA_src += close[j];
               SMA_BarIndex += j;
               SMA_src_BarIndexl += close[j]*j;
            }
            SMA_src /= length;
            SMA_BarIndex /= length;
            SMA_src_BarIndexl /= length;
            
            double var = 0;
            for(int j = i; j > i-length; j--)
            {
               var+=MathPow(j-ma_index(j, length),2.0);
            }
            var=(var/length);
            
            slope[i] = MathAbs(SMA_src_BarIndexl - SMA_src*SMA_BarIndex)/var/(2*k);
         }
      }
         
      }
      
      slope_ph[i] = ph[i] != 0 ? slope[i] : slope_ph[i-1];
      slope_pl[i] = pl[i] != 0 ? slope[i] : slope_pl[i-1];
      
      Last_ph_time[i] = ph[i] != 0 ? time[i] : Last_ph_time[i-1];
      Last_pl_time[i] = pl[i] != 0 ? time[i] : Last_pl_time[i-1];
      
      upper[i] = ph[i] != 0 ? ph[i] : upper[i-1] - slope_ph[i];
      lower[i] = pl[i] != 0 ? pl[i] : lower[i-1] + slope_pl[i];
      
      if (ph[i] != 0)
      {
         //--- Create TrendLine
         {
         const long            chart_ID=0;        // chart's ID 
         const string          name=ObjPref+"Upper-"+TimeToString((datetime)Last_ph_time[i]);  // line name 
         const int             sub_window=0;      // subwindow index 
         datetime              time1=(datetime)Last_ph_time[i];           // first point time 
         double                price1=ph[i];          // first point price 
         datetime              time2=time1;           // second point time 
         double                price2=price1;          // second point price 
         const color           clr=clrLimeGreen;        // line color 
         const ENUM_LINE_STYLE style=STYLE_SOLID; // line style 
         const int             width=1;           // line width 
         const bool            back=false;        // in the background 
         const bool            selectable=false;    // selectable
         const bool            selected=false;    // highlight to move 
         const bool            ray_left=false;    // line's continuation to the left 
         const bool            ray_right=false;   // line's continuation to the right 
         const bool            hidden=true;       // hidden in the object list 
         const long            z_order=0;         // priority for mouse click 
         const string          Description=NULL;  // Description
         const string          ToolTip=NULL;
         
         TrendCreate(chart_ID, name, sub_window, time1, price1, time2, price2, clr, style, width, back, selectable, selected, ray_left, ray_right, hidden, z_order, Description, ToolTip);
         }
      }
      else
      {
         string name=ObjPref+"Upper-"+TimeToString((datetime)Last_ph_time[i]);
         ObjectSetInteger(0, name, OBJPROP_TIME, 1, time[i]);
         ObjectSetDouble(0, name, OBJPROP_PRICE, 1, upper[i]);
      }
      
      if (pl[i] != 0)
      {
         //--- Create TrendLine
         {
         const long            chart_ID=0;        // chart's ID 
         const string          name=ObjPref+"Lower-"+TimeToString((datetime)Last_pl_time[i]);  // line name 
         const int             sub_window=0;      // subwindow index 
         datetime              time1=(datetime)Last_pl_time[i];           // first point time 
         double                price1=pl[i];          // first point price 
         datetime              time2=time1;           // second point time 
         double                price2=price1;          // second point price 
         const color           clr=clrRed;        // line color 
         const ENUM_LINE_STYLE style=STYLE_SOLID; // line style 
         const int             width=1;           // line width 
         const bool            back=false;        // in the background 
         const bool            selectable=false;    // selectable
         const bool            selected=false;    // highlight to move 
         const bool            ray_left=false;    // line's continuation to the left 
         const bool            ray_right=false;   // line's continuation to the right 
         const bool            hidden=true;       // hidden in the object list 
         const long            z_order=0;         // priority for mouse click 
         const string          Description=NULL;  // Description
         const string          ToolTip=NULL;
         
         TrendCreate(chart_ID, name, sub_window, time1, price1, time2, price2, clr, style, width, back, selectable, selected, ray_left, ray_right, hidden, z_order, Description, ToolTip);
         }
      }
      else
      {
         string name=ObjPref+"Lower-"+TimeToString((datetime)Last_pl_time[i]);
         ObjectSetInteger(0, name, OBJPROP_TIME, 1, time[i]);
         ObjectSetDouble(0, name, OBJPROP_PRICE, 1, lower[i]);
      }
            
      AlreadyBrokeout_upper[i] = ph[i] != 0 ? 0 : AlreadyBrokeout_upper[i-1];
      AlreadyBrokeout_lower[i] = pl[i] != 0 ? 0 : AlreadyBrokeout_lower[i-1];
      
      TempSL_Buy[i] = ph[i] != 0 ? low[i] : MathMin(low[i], TempSL_Buy[i-1]);
      TempSL_Sell[i] = pl[i] != 0 ? high[i] : MathMax(high[i], TempSL_Sell[i-1]);
      
      if (AlreadyBrokeout_upper[i] == 0 && close[i] > upper[i])
      {
         Breakout_Buy[i] = low[i];
         SL_Buy[i] = TempSL_Buy[i];
         AlreadyBrokeout_upper[i] = 1;
         //AlreadyBrokeout_lower[i] = 0;
      }
      else Breakout_Buy[i] = 0;
      
      if (AlreadyBrokeout_lower[i] == 0 && close[i] < lower[i])
      {
         Breakout_Sell[i] = high[i];
         SL_Sell[i] = TempSL_Sell[i];
         AlreadyBrokeout_lower[i] = 1;
         //AlreadyBrokeout_upper[i] = 0;
      }
      else Breakout_Sell[i] = 0;
     /*
      single_upper[i] = close[i-length] > upper[i] ? 0 : ph[i] != 0 ? 1 : single_upper[i-1];
      single_lower[i] = close[i-length] < lower[i] ? 0 : pl[i] != 0 ? 1 : single_lower[i-1];
     
      upper_breakout[i] = (single_upper[i-1] > 0 && close[i-length] > upper[i] && (show ? close[i] > close[i-length] : true) ? low[i-length] : 0);
      lower_breakout[i] = (single_lower[i-1] > 0 && close[i-length] < lower[i] && (show ? close[i] < close[i-length] : true) ? high[i-length] : 0);
      */
    //  upper_breakout[i] = (close[i] > upper[i]-slope_ph[i]*length && close[i-1] <= upper[i-1]-slope_ph[i-1]*length ? low[i] : 0);
    //  lower_breakout[i] = (close[i] < lower[i]+slope_pl[i]*length && close[i-1] >= lower[i-1]+slope_pl[i-1]*length ? high[i] : 0);
   }
   
//--- return value of prev_calculated for next call
   return(rates_total);
}

double ma_index(int i, int period)
{
   double ma = 0;
   for (int j = i; j > i-period; j--)
   {
      ma += j;
   }
   ma /= period;
   
   return(ma);
}

double PivotHigh(int LeftBars, int RightBars, int rates_total, int i)
{
   if (i >= rates_total-length) return(false);

   double LeftMax = iHigh(NULL,0,iHighest(NULL,0,MODE_HIGH,length,rates_total-1-(i-1)));
   double RightMax = iHigh(NULL,0,iHighest(NULL,0,MODE_HIGH,length,rates_total-1-(i+length)));
   double CurPrice = iHigh(NULL,0,rates_total-1-i);
   if (CurPrice > MathMax(LeftMax, RightMax)) return(CurPrice);
   return(0);
}

double PivotLow(int LeftBars, int RightBars, int rates_total, int i)
{
   if (i >= rates_total-length) return(false);
   
   double LeftMin = iLow(NULL,0,iLowest(NULL,0,MODE_LOW,length,rates_total-1-(i-1)));
   double RightMin = iLow(NULL,0,iLowest(NULL,0,MODE_LOW,length,rates_total-1-(i+length)));
   double CurPrice = iLow(NULL,0,rates_total-1-i);
   if (CurPrice < MathMin(LeftMin, RightMin)) return(CurPrice);
   return(0);
}

double GetBufferValue(int handle, int Buffer, int shift)
{
   double buffer[];
   CopyBuffer(handle, Buffer, shift, 1, buffer);
   if(ArraySize(buffer) != 1) 
   {
      return(EMPTY_VALUE); 
   }
   
   return (buffer[0]);
}

int ATR_Handle, StdDev_Handle;
bool CreateIndicatorsHandles()
{      
   if (method == Atr)
   {
      ATR_Handle 
         = iATR(_Symbol, 0, length);
       
      if(ATR_Handle==INVALID_HANDLE) 
      {
         //--- tell about the failure and output the error code 
         PrintFormat("Failed to create handle of the %s indicator for the symbol %s/%s, error code %d", 
                     "ATR",
                     _Symbol, 
                     EnumToString(_Period), 
                     GetLastError()); 
         //--- the indicator is stopped early 
         return(false); 
      }  
   }
   else if (method == Stdev)
   {
      StdDev_Handle 
         = iStdDev(_Symbol, 0, length, 0, MODE_SMA, PRICE_CLOSE);
       
      if(StdDev_Handle==INVALID_HANDLE) 
      {
         //--- tell about the failure and output the error code 
         PrintFormat("Failed to create handle of the %s indicator for the symbol %s/%s, error code %d", 
                     "StdDev",
                     _Symbol, 
                     EnumToString(_Period), 
                     GetLastError()); 
         //--- the indicator is stopped early 
         return(false); 
      }  
   }
   return(true);
}

//+------------------------------------------------------------------+ 
//| Create a trend line by the given coordinates                     | 
//+------------------------------------------------------------------+ 
void TrendCreate(const long            chart_ID=0,        // chart's ID 
                 const string          name="TrendLine",  // line name 
                 const int             sub_window=0,      // subwindow index 
                 datetime              time1=0,           // first point time 
                 double                price1=0,          // first point price 
                 datetime              time2=0,           // second point time 
                 double                price2=0,          // second point price 
                 const color           clr=clrRed,        // line color 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style 
                 const int             width=1,           // line width 
                 const bool            back=false,        // in the background 
                 const bool            selectable=true,    // selectable
                 const bool            selected=true,    // highlight to move 
                 const bool            ray_left=false,    // line's continuation to the left 
                 const bool            ray_right=false,   // line's continuation to the right 
                 const bool            hidden=true,       // hidden in the object list 
                 const long            z_order=0,         // priority for mouse click 
                 const string          Description=NULL,  // Description
                 const string          ToolTip=NULL)      // ToolTip

{ 
//--- create a trend line by the given coordinates 
   ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2);
   ObjectSetInteger(chart_ID,name,OBJPROP_TIME,0,time1);
   ObjectSetInteger(chart_ID,name,OBJPROP_TIME,1,time2);
   ObjectSetDouble(chart_ID,name,OBJPROP_PRICE,0,price1);
   ObjectSetDouble(chart_ID,name,OBJPROP_PRICE,1,price2);
   
//--- set line color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- set line display style 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- set line width 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- enable (true) or disable (false) the mode of moving the line by mouse 
//--- when creating a graphical object using ObjectCreate function, the object cannot be 
//--- highlighted and moved by default. Inside this method, selection parameter 
//--- is true by default making it possible to highlight and move the object 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selectable); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selected); 
//--- enable (true) or disable (false) the mode of continuation of the line's display to the left 
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_LEFT,ray_left); 
//--- enable (true) or disable (false) the mode of continuation of the line's display to the right 
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right); 
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 

   if (Description != NULL) ObjectSetString(chart_ID,name,OBJPROP_TEXT,Description);
   if (ToolTip != NULL) ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,ToolTip);
   
//--- successful execution 
} 

//+------------------------------------------------------------------+
