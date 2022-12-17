# Trend Line



```
// This work is licensed under a Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) https://creativecommons.org/licenses/by-nc-sa/4.0/
// © LuxAlgo

//@version=5
indicator("Trendlines with Breaks [LuxAlgo]",overlay=true)
length = input.int(14)
k      = input.float(1.,'Slope',minval=0,step=.1)
method = input.string('Atr','Slope Calculation Method',
  options=['Atr','Stdev','Linreg'])
show   = input(false,'Show Only Confirmed Breakouts')
//----
upper = 0.,lower = 0.
slope_ph = 0.,slope_pl = 0.
src = close
n = bar_index
//----
ph = ta.pivothigh(length,length)
pl = ta.pivotlow(length,length)
slope = switch method
    'Atr'      => ta.atr(length)/length*k
    'Stdev'    => ta.stdev(src,length)/length*k
    'Linreg'   => math.abs(ta.sma(src*bar_index,length)-ta.sma(src,length)*ta.sma(bar_index,length))/ta.variance(n,length)/2*k

slope_ph := ph ? slope : slope_ph[1]
slope_pl := pl ? slope : slope_pl[1]

upper := ph ? ph : upper[1] - slope_ph
lower := pl ? pl : lower[1] + slope_pl
//----
single_upper = 0
single_lower = 0
single_upper := src[length] > upper ? 0 : ph ? 1 : single_upper[1]
single_lower := src[length] < lower ? 0 : pl ? 1 : single_lower[1]
upper_breakout = single_upper[1] and src[length] > upper and (show ? src > src[length] : 1)
lower_breakout = single_lower[1] and src[length] < lower and (show ? src < src[length] : 1)
plotshape(upper_breakout ? low[length] : na,"Upper Break",shape.labelup,location.absolute,#26a69a,-length,text="B",textcolor=color.white,size=size.tiny)
plotshape(lower_breakout ? high[length] : na,"Lower Break",shape.labeldown,location.absolute,#ef5350,-length,text="B",textcolor=color.white,size=size.tiny)
//----
var line up_l = na
var line dn_l = na
var label recent_up_break = na
var label recent_dn_break = na

if ph[1]
    line.delete(up_l[1])
    label.delete(recent_up_break[1])
    
    up_l := line.new(n-length-1,ph[1],n-length,upper,color=#26a69a,
      extend=extend.right,style=line.style_dashed)
if pl[1]
    line.delete(dn_l[1])
    label.delete(recent_dn_break[1])
    
    dn_l := line.new(n-length-1,pl[1],n-length,lower,color=#ef5350,
      extend=extend.right,style=line.style_dashed)

if ta.crossover(src,upper-slope_ph*length)
    label.delete(recent_up_break[1])
    recent_up_break := label.new(n,low,'B',color=#26a69a,
      textcolor=color.white,style=label.style_label_up,size=size.small)

if ta.crossunder(src,lower+slope_pl*length)
    label.delete(recent_dn_break[1])
    recent_dn_break := label.new(n,high,'B',color=#ef5350,
      textcolor=color.white,style=label.style_label_down,size=size.small)
    
//----
plot(upper,'Upper',color = ph ? na : #26a69a,offset=-length)
plot(lower,'Lower',color = pl ? na : #ef5350,offset=-length)

alertcondition(ta.crossover(src,upper-slope_ph*length),'Upper Breakout','Price broke upper trendline')
alertcondition(ta.crossunder(src,lower+slope_pl*length),'Lower Breakout','Price broke lower trendline')
```
# MT5 Version
```
#property copyright "LuxAlgo"
#property link      "https://creativecommons.org/licenses/by-nc-sa/4.0/"
#property version   "1.0"

#include <Arrays\ArrayDouble.h>
#include <Indicators\Pivot.h>
#include <Indicators\ATR.h>
#include <Indicators\StdDev.h>
#include <Math\SMA.h>
#include <Math\Variance.h>

input int       length=14;          // Length of the trendline
input double    k=1;                // Slope of the trendline
input string    method="Atr";       // Method for calculating slope
                                    // Options: "Atr", "Stdev", "Linreg"
input bool      show_only_confirmed=false; // Show only confirmed breakouts

// Arrays for storing upper and lower bounds of the trendline
ArrayDouble upper, lower;

// Variables for storing slope and previous pivot points
double slope_ph, slope_pl;
double prev_ph, prev_pl;

// Variables for storing single upper and lower breakouts
int single_upper, single_lower;

// Variables for storing labels for recent breakouts
int recent_up_break, recent_dn_break;

// Function for calculating the slope of the trendline
double CalculateSlope()
{
    double slope;

    // Calculate slope based on selected method
    if(method=="Atr")
    {
        slope=iATR(NULL,0,length)/length*k;
    }
    else if(method=="Stdev")
    {
        slope=iStdDev(NULL,0,length,PRICE_CLOSE)/length*k;
    }
    else if(method=="Linreg")
    {
        slope=Abs(iSMA(NULL,0,length,PRICE_CLOSE*ArrayDouble(length+1))-
            iSMA(NULL,0,length,PRICE_CLOSE)*iSMA(NULL,0,length,ArrayDouble(length+1)))/
            Variance(ArrayDouble(length+1),length)/2*k;
    }

    return slope;
}

// Initialize the arrays and variables
void OnInit()
{
    upper.Resize(length+1);
    lower.Resize(length+1);
    slope_ph=0;
    slope_pl=0;
    prev_ph=0;
    prev_pl=0;
    single_upper=0;
    single_lower=0;
    recent_up_break=-1;
    recent_dn_break=-1;
}

// Calculate and plot the trendline breakout indicator
void OnCalculate(const int rates_total,
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
    // Calculate pivot points
    ArrayDouble ph, pl;
    PivotHighLow(length,length,high,low,close,ph,pl);

    // Calculate the slope of the trendline
    double slope=CalculateSlope();

    // Update slope and pivot points
    if(ph[1])
    {
        slope_ph=slope;
        prev_ph=ph[1];
    }
    if(pl[1])
    {
        slope_pl=slope;
        prev_pl=pl[1];
    }

    // Calculate upper and lower bounds of the trendline
    for(int i=0; i<=length; i++)
    {
        if(ph[i])
        {
            upper[i]=ph[i];
        }
        else
        {
            upper[i]=prev_ph-slope_ph*(length-i);
        }

        if(pl[i])
        {
            lower[i]=pl[i];
        }
        else
        {
            lower[i]=prev_pl+slope_pl*(length-i);
        }
    }

    // Update single upper and lower breakouts
    single_upper=0;
    single_lower=0;
    if(close[length]>upper[length])
    {
        single_upper=0;
    }
    else if(ph[1])
    {
        single_upper=1;
    }
    else
    {
        single_upper=single_upper[1];
    }

    if(close[length]<lower[length])
    {
        single_lower=0;
    }
    else if(pl[1])
    {
        single_lower=1;
    }
    else
    {
        single_lower=single_lower[1];
    }
    // Plot upper and lower breakout shapes
    if(single_upper[1] && close[length]>upper[length] && (!show_only_confirmed || close>close[length]))
    {
        ObjectCreate("Upper Break",OBJ_ARROW_UP,0,time[length],low[length]-length*Point);
        ObjectSetText("Upper Break","B",10,"Verdana",White);
        ObjectSet("Upper Break",OBJPROP_ARROWCODE,SYMBOL_ARROWUP);
    }
    if(single_lower[1] && close[length]<lower[length] && (!show_only_confirmed || close<close[length]))
    {
        ObjectCreate("Lower Break",OBJ_ARROW_DOWN,0,time[length],high[length]-length*Point);
        ObjectSetText("Lower Break","B",10,"Verdana",White);
        ObjectSet("Lower Break",OBJPROP_ARROWCODE,SYMBOL_ARROWDOWN);
    }
    // Update labels for recent breakouts
    if(prev_ph[1])
    {
        ObjectDelete("Upper Trendline");
        label.delete(recent_up_break);
        ObjectCreate("Upper Trendline",OBJ_TREND,0,time[length-1],prev_ph[1],time[length],upper[0]);
        ObjectSet("Upper Trendline",OBJPROP_STYLE,STYLE_DASH);
        ObjectSet("Upper Trendline",OBJPROP_COLOR,Green);
    }
    if(prev_pl[1])
    {
        ObjectDelete("Lower Trendline");
        label.delete(recent_dn_break);
        ObjectCreate("Lower Trendline",OBJ_TREND,0,time[length-1],prev_pl[1],time[length],lower[0]);
        ObjectSet("Lower Trendline",OBJPROP_STYLE,STYLE_DASH);
        ObjectSet("Lower Trendline",OBJPROP_COLOR,Red);
    }
    // Plot labels for recent breakouts
    if(Crosses(close,upper[0]-slope_ph*length,0))
    {
        label.delete(recent_up_break);
        recent_up_break=LabelCreate(time[0],low[0],"B",Green,
            DT_LEFT|DT_VCENTER|DT_NO_LABEL_BACKGROUND,10);
    }
    if(Crosses(close,lower[0]+slope_pl*length,0))
    {
        label.delete(recent_dn_break);
        recent_dn_break=LabelCreate(time[0],high[0],"B",Red,
            DT_LEFT|DT_VCENTER|DT_NO_LABEL_BACKGROUND,10);
    }

    if(single_upper[1] && close[length]>upper[length] && (!show_only_confirmed || close>close[length]))
    {
        Alert("Upper trendline breakout detected!");
    }
    if(single_lower[1] && close[length]<lower[length] && (!show_only_confirmed || close<close[length]))
    {
        Alert("Lower trendline breakout detected!");
    }

}

void OnDeinit(const int reason)
{
    label.delete(recent_up_break);
    label.delete(recent_dn_break);
}

```
