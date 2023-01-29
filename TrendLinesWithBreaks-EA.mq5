//+------------------------------------------------------------------+
//|                                      TrendLinesWithBreaks-EA.mq5 |
//|                                       Trader4.net, Just A Trader |
//|                                              https://trader4.net |
//+------------------------------------------------------------------+
#property copyright "Trader4.net, Just A Trader"
#property link      "https://trader4.net"
#property version   "1.10"

#include <TradingFramework\\trading-framework\\TradingFramework.mqh>
//#include <TradingFramework\\TradingFramework-Copy(3).mqh>

#import "TradingFramework.ex5"
//class ITrade
   bool CTrade_ClosePosition(ulong ticket, double Volume=0);
   ulong CTrade_OpenPosition(bool InpUseVirtualPrice, const string symbol, const ENUM_ORDER_TYPE type, const double lot, double &price, const double sl, const double tp, const string comment, int InpMagicNumber, int InpMaxSlippage);
   bool CTrade_ModifySL(bool InpUseVirtualPrice, ulong ticket, double fNewSL, bool ForceHard=false);
   bool CTrade_ModifyTP(bool InpUseVirtualPrice, ulong ticket, double fNewTP, bool ForceHard=false);
   bool CTrade_ClosePositions(int InpMagicNumber, string symbol, int pos_type=-1, string comment=NULL);
   bool CTrade_DeleteOrders(int InpMagicNumber, string symbol, int pos_type=-1, string comment=NULL);
   bool CTrade_DeleteOrder(ulong ticket);
   bool CTrade_PositionExist(int InpMagicNumber, string symbol, int pos_type=-1, string comment=NULL);
   double CTrade_OrderCommission(ulong InpTicket);
   double CTrade_CalcLot(string f_symbol, double f_LotSize);
//class IAlert
   void CAlert_SendAlert(bool InpSendAlertViaAlertWindow, bool InpSendAlertViaNotification, bool InpSendAlertViaEmail, string Inp_Message);
//class IGrid
   int CGrid_Set(bool CanEnterNewTrade, bool InpUseVirtualPrice, int InpMagicNumber, int InpMaxSlippage, int BuySell, double StartPrice, int Distance_Points, int MaxLevel, int Mode, double Lot, int TP_Point, MqlParam &AllSets[][13]);
   bool CGrid_UnSet(int ID, MqlParam &AllSets[][13], bool RemoveOpenPending);
   void CGrid_GetSets(MqlParam &AllSets[][13]);
//class IHedge
   bool CHedge_Set(bool CanEnterNewTrade, int InpMagicNumber, int InpMaxSlippage, ulong ticket, int Distance_Points, double LotPercent);
   bool CHedge_UnSet(ulong ticket);
//class IIndicator  
   double CIndicator_GetBufferValue(int handle, int Buffer, int shift);
//class IReversePositioning
   bool CReversePositioning_CheckAndEnterNewTrade(bool InpUseVirtualPrice, int InpMagicNumber, int InpMaxSlippage, string Zone_ObjName);
//class IRiskFree
   void CRiskFree_Set(ulong ticket, double TP_InPrice=0);
//class IZones
   int CZone_GetZones(MqlParam &Zones_[][13]);
   int CZone_AlertOnZone(string ZoneObjName);
   void CZone_AlertOnZone(string ZoneObjName, int Inp_AlertOnZone);
   int CZone_ZoneStatus(string ZoneObjName);
   void CZone_ZoneStatus(string ZoneObjName, int Inp_ZoneStatus);
//class ITrailEntry
   bool CTrailEntry_EnterTrade(int &MaxTrailedInPoints, int BuyOrSell, double EnterPrice);
   

   int TradingFramework_OnInitEvent(int InpMagicNumber);
   int OnInitEvent_AntiMartingale(int InpAntiMartingale_MaxAntiMartingaleLevel, int InpAntiMartingale_ConsecutiveStops, double InpAntiMartingale_Multiplier, int InpMagicNumber, bool InpUseVirtualPrice);
   int OnInitEvent_DailyPnL(int InpMode, double InpDailyProfit, double InpDailyLoss, int InpMagicNumber);
   int OnInitEvent_EquityProtector(double InpEquityProtector_Value, int InpEquityProtector_Mode, bool InpEquityProtector_StopOut);
   int OnInitEvent_MaxRoundedNumbers(int InpRoundedNumbers_ZeroDigits, int InpRoundedNumbersMaxDistance_Points);
   int OnInitEvent_MoneyManagement(int InpMoneyManagement, double InpReward2RiskRatio, int InpCustomRiskPercentage_CalculationMode, string InpCustomRiskPercentage);
   int OnInitEvent_NearestTrade(int InpNearestZoneMinDistanceInPoints);
   int OnInitEvent_NewsFilter(bool InpNewsFilter, int InpXMinutesBeforeTime, int InpXMinutesAfterTime, int InpLevel, int InpNewsUpdateEveryXSeconds);
   int OnInitEvent_OppositeTrading(bool InpOpposite_Trading);
   int OnInitEvent_PositionManagement(int InpPositionManagement, string InpClosePartialArray, int InpClosePartialProfitMode, bool InpUseVirtualPrice, int InpMagicNumber);
   int OnInitEvent_ReversePositioning(int InpReversePositioning);
   int OnInitEvent_RiskFree(double InpRiskFree, int InpRiskFreeMode, int InpRiskFreeExtra, int InpRiskFreeIncludeSwapXMinBeforeDayEnd, bool InpUseVirtualPrice, int InpMagicNumber);
   int OnInitEvent_RiskManagement(int InpRiskManagement, int InpRiskManagement_ProfitSteps_Custom, double InpRiskManagement_ProfitMultiplier_Custom, int InpRiskManagement_LossSteps_Custom, double InpRiskManagement_LossMultiplier_Custom, bool InpUseVirtualPrice, int InpMagicNumber);
   int OnInitEvent1_RW(int Inp_RiskFreeExtra
                   , int InpRiskFreeIncludeSwapXMinBeforeDayEnd
                   , bool Inp_UseVirtualPrice
                   , int Inp_MagicNumber
                   , int Inp_MaxSlippage
                   , int Inp_Method
                   , int Inp_Price_StepInPoints
                   , ENUM_TIMEFRAMES Inp_RSI_Timeframe
                   , int Inp_RSI_MAPeriod
                   , ENUM_APPLIED_PRICE Inp_RSI_AppliedPrice
                   , int Inp_RSI_Level
                   , int Inp_RSI_TurnBack
                   , ENUM_TIMEFRAMES Inp_CCI_Timeframe
                   , int Inp_CCI_MAPeriod
                   , ENUM_APPLIED_PRICE Inp_CCI_AppliedPrice
                   , int Inp_CCI_Level
                   , int Inp_CCI_TurnBack
                   , ENUM_TIMEFRAMES Inp_Stoch_Timeframe
                   , int Inp_Stoch_KPeriod
                   , int Inp_Stoch_DPeriod
                   , int Inp_Stoch_Slowing
                   , ENUM_MA_METHOD Inp_Stoch_MAMethod
                   , ENUM_STO_PRICE Inp_Stoch_PriceField
                   , int Inp_Stoch_Level
                   , int Inp_Stoch_TurnBack
                   , ENUM_TIMEFRAMES Inp_MACD_Timeframe
                   , int Inp_MACD_FastEMAPeriod
                   , int Inp_MACD_SlowEMAPeriod
                   , int Inp_MACD_SignalPeriod
                   , ENUM_APPLIED_PRICE Inp_MACD_AppliedPrice
                   , ENUM_TIMEFRAMES Inp_MA_Timeframe
                   , int Inp_MAFast_Period
                   , int Inp_MASlow_Period
                   , int Inp_MA_Shift
                   , ENUM_MA_METHOD Inp_MA_Method
                   , ENUM_APPLIED_PRICE Inp_MA_AppliedPrice
                   , ENUM_TIMEFRAMES Inp_Ichimoku_Timeframe
                   , int Inp_Ichimoku_TenkanSenPeriod
                   , int Inp_Ichimoku_KijunSenPeriod
                   , int Inp_Ichimoku_SenkouSpanBPeriod
                   , string Inp_Ichimoku_TimeTheory_Array_Str
                  );  
   int OnInitEvent2_RW(ENUM_TIMEFRAMES Inp_Zone_Timeframe
                   , int Inp_Zone_EntryType
                   , bool Inp_Zone_MultiTimeframe
                   , ENUM_TIMEFRAMES Inp_Zone_Timeframe1
                   , ENUM_LINE_STYLE Inp_Zone_ZoneStyle1
                   , color Inp_Zone_ZoneColor1_Supply
                   , color Inp_Zone_ZoneColor1_Demand
                   , color Inp_Zone_ZoneColor1_None
                   , bool Inp_Zone_ZoneFill1
                   , ENUM_TIMEFRAMES Inp_Zone_Timeframe2
                   , ENUM_LINE_STYLE Inp_Zone_ZoneStyle2
                   , color Inp_Zone_ZoneColor2_Supply
                   , color Inp_Zone_ZoneColor2_Demand
                   , color Inp_Zone_ZoneColor2_None
                   , bool Inp_Zone_ZoneFill2
                   , ENUM_TIMEFRAMES Inp_Zone_Timeframe3
                   , ENUM_LINE_STYLE Inp_Zone_ZoneStyle3
                   , color Inp_Zone_ZoneColor3_Supply
                   , color Inp_Zone_ZoneColor3_Demand
                   , color Inp_Zone_ZoneColor3_None
                   , bool Inp_Zone_ZoneFill3
                   , int Inp_Zone_IndicatorMode
                   , int Inp_Zone_BackLimit
                   , int Inp_Zone_DeleteZonesAfterXBars
                   , bool Inp_Zone_zone_show_weak
                   , bool Inp_Zone_zone_show_untested
                   , bool Inp_Zone_zone_show_turncoat
                   , bool Inp_Zone_DrawMode
                   , int Inp_Zone_TradeMode
                   , int Inp_Zone_ReversePositioning
                   , int Inp_Zone_RoundedNumbers_ZeroDigits
                   , int Inp_Zone_RoundedNumbersMaxDistance_Points
                   , int Inp_Zone_NearestZoneMinDistanceInPoints
                   , int Inp_Zone_MaxZoneSizeInPoints
                   , int Inp_Zone_MinZoneSizeInPoints
                   , bool Inp_DrawAutoZone=true
                  );
   int OnInitEvent_SessionsFilter(bool InpLondonSession, string InpLondonSession_StartTime, string InpLondonSession_EndTime, bool InpNewYorkSession, string InpNewYorkSession_StartTime, string InpNewYorkSession_EndTime, bool InpSydneySession, string InpSydneySession_StartTime, string InpSydneySession_EndTime, bool InpTokyoSession, string InpTokyoSession_StartTime, string InpTokyoSession_EndTime);
   int OnInitEvent_TrailStop(bool InpUseTrailStop, double InpTrailStopLoss, int InpTrailStopLossMode, double InpTrailStepLoss, int InpTrailStepLossMode);
   int OnInitEvent_TrailEntry(bool InpTrailEntry, int InpTrailEntryStepInPoints, int InpTrailEntryStopInPoints);
   int OnInitEvent_WeekendFilter(int InpWeekendFilter_XMinutesBeforeMarketClose);
   int OnInitEvent_Zones(bool Inp_UseVirtualPrice, int Inp_MagicNumber, bool Inp_DrawAutoZone
                        , bool Inp_MultiTimeframe
                        , ENUM_TIMEFRAMES Inp_Timeframe1
                        , ENUM_LINE_STYLE Inp_ZoneStyle1
                        , color Inp_ZoneColor1_Supply
                        , color Inp_ZoneColor1_Demand
                        , color Inp_ZoneColor1_None
                        , bool Inp_ZoneFill1
                        , ENUM_TIMEFRAMES Inp_Timeframe2
                        , ENUM_LINE_STYLE Inp_ZoneStyle2
                        , color Inp_ZoneColor2_Supply
                        , color Inp_ZoneColor2_Demand
                        , color Inp_ZoneColor2_None
                        , bool Inp_ZoneFill2
                        , ENUM_TIMEFRAMES Inp_Timeframe3
                        , ENUM_LINE_STYLE Inp_ZoneStyle3
                        , color Inp_ZoneColor3_Supply
                        , color Inp_ZoneColor3_Demand
                        , color Inp_ZoneColor3_None
                        , bool Inp_ZoneFill3
                        , int Inp_IndicatorMode
                        , int Inp_BackLimit
                        , int Inp_DeleteZonesAfterXBars
                        , bool Inp_zone_show_weak
                        , bool Inp_zone_show_untested
                        , bool Inp_zone_show_turncoat
                        , bool Inp_DrawMode
                        , int Inp_TradeMode
                        , int Inp_RoundedNumbers_ZeroDigits
                        , int Inp_RoundedNumbersMaxDistance_Points
                        , int Inp_NearestZoneMinDistanceInPoints
                        , int Inp_MaxZoneSizeInPoints
                        , int Inp_MinZoneSizeInPoints
                        , bool Inp_SendAlertViaAlertWindow
                        , bool Inp_SendAlertViaNotification
                        , bool Inp_SendAlertViaEmail
                        , bool Inp_AlertActive
                        , bool Inp_TouchZone
                        , bool Inp_BreakZone
                        , bool Inp_ReverseZone
                        , string Inp_ObjPref=""
                  );
   void TradingFramework_OnChartEvent_(const int id, const long &lparam, const double &dparam, const string &sparam);
   bool TradingFramework_OnCalculateEvent(bool InpUseVirtualPrice, int InpMagicNumber, int InpMaxSlippage, string TradeCommentPref4AntiMartingale);
   int OpenTrade(const string symbol, ENUM_ORDER_TYPE type, double &price, double sl, int InpMagicNumber, int InpMaxSlippage, bool InpUseVirtualPrice, string TradeCommentPref, string TradeCommentPref4AntiMartingale);
   double Lots(string f_symbol, int BuyOrSell, double price, double sl, double &f_tp, string TradeCommentPref4AntiMartingale, int PosNum, int &MartingaleLevel);
   string TradeComment(string comment, ulong ticket);
   
#import

input group "====================== Indicator Properties ======================"
input string input_IndicatorName = "Trader4\\trend-line\\TrendLinesWithBreaks-Indicator"; //IndicatorName
input int input_length = 14; //length
input double input_Slope = 1.; //Slope
enum ENUM_Method
{
   Atr,
   Stdev,
   Linreg
};
input ENUM_Method input_method = Atr; //Slope Calculation Method

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
   int RetVal = TradingFramework_OnInitEvent(input_MagicNumber);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent1_RW(input_RiskFreeExtra, input_RiskFreeIncludeSwapXMinBeforeDayEnd, input_UseVirtualPrice, input_MagicNumber, input_MaxSlippage, input_RW_Method, input_RW_Price_StepInPoints, input_RW_RSI_Timeframe, input_RW_RSI_MAPeriod, input_RW_RSI_AppliedPrice, input_RW_RSI_Level, input_RW_RSI_TurnBack, input_RW_CCI_Timeframe, input_RW_CCI_MAPeriod, input_RW_CCI_AppliedPrice, input_RW_CCI_Level, input_RW_CCI_TurnBack, input_RW_Stoch_Timeframe, input_RW_Stoch_KPeriod, input_RW_Stoch_DPeriod, input_RW_Stoch_Slowing, input_RW_Stoch_MAMethod, input_RW_Stoch_PriceField, input_RW_Stoch_Level, input_RW_Stoch_TurnBack, input_RW_MACD_Timeframe, input_RW_MACD_FastEMAPeriod, input_RW_MACD_SlowEMAPeriod, input_RW_MACD_SignalPeriod, input_RW_MACD_AppliedPrice, input_RW_MA_Timeframe, input_RW_MAFast_Period, input_RW_MASlow_Period, input_RW_MA_Shift, input_RW_MA_Method, input_RW_MA_AppliedPrice, input_RW_Ichimoku_Timeframe, input_RW_Ichimoku_TenkanSenPeriod, input_RW_Ichimoku_KijunSenPeriod, input_RW_Ichimoku_SenkouSpanBPeriod, input_RW_Ichimoku_TimeTheory_Array_Str);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);
    
   RetVal = OnInitEvent2_RW(input_RW_Zone_Timeframe, input_RW_Zone_EntryType, input_RW_Zone_MultiTimeframe, input_RW_Zone_Timeframe1, input_RW_Zone_ZoneStyle1, input_RW_Zone_ZoneColor1_Supply, input_RW_Zone_ZoneColor1_Demand, input_RW_Zone_ZoneColor1_None, input_RW_Zone_ZoneFill1, input_RW_Zone_Timeframe2, input_RW_Zone_ZoneStyle2, input_RW_Zone_ZoneColor2_Supply, input_RW_Zone_ZoneColor2_Demand, input_RW_Zone_ZoneColor2_None, input_RW_Zone_ZoneFill2, input_RW_Zone_Timeframe3, input_RW_Zone_ZoneStyle3, input_RW_Zone_ZoneColor3_Supply, input_RW_Zone_ZoneColor3_Demand, input_RW_Zone_ZoneColor3_None, input_RW_Zone_ZoneFill3, input_RW_Zone_IndicatorMode, input_RW_Zone_BackLimit, input_RW_Zone_DeleteZonesAfterXBars, input_RW_Zone_zone_show_weak, input_RW_Zone_zone_show_untested, input_RW_Zone_zone_show_turncoat, input_RW_Zone_DrawMode, input_RW_Zone_TradeMode, input_RW_Zone_ReversePositioning, input_RW_Zone_RoundedNumbers_ZeroDigits, input_RW_Zone_RoundedNumbersMaxDistance_Points, input_RW_Zone_NearestZoneMinDistanceInPoints, input_RW_Zone_MaxZoneSizeInPoints, input_RW_Zone_MinZoneSizeInPoints, input_RW_DrawAutoZone);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);
   
   RetVal = OnInitEvent_AntiMartingale(input_AntiMartingale_MaxMartingaleLevel, input_AntiMartingale_ConsecutiveStops, input_AntiMartingale_Multiplier, input_MagicNumber, input_UseVirtualPrice);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_DailyPnL(input_Daily_PnL, input_DailyProfit, input_DailyLoss, input_MagicNumber);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_EquityProtector(input_EquityProtector_Value, input_EquityProtector_Mode, input_EquityProtector_StopOut);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_MaxRoundedNumbers(input_Trade_RoundedNumbers_ZeroDigits, input_Trade_RoundedNumbersMaxDistance_Points);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_MoneyManagement(input_Money_Management, input_Reward2RiskRatio, input_CustomRiskPercentage_CalculationMode, input_CustomRiskPercentage);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_NearestTrade(input_NearestTradeMinDistanceInPoints);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_NewsFilter(input_News_Filter, input_News_XMinutesBeforeTime, input_News_XMinutesAfterTime, input_News_Level, input_NewsUpdateEveryXSeconds);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_OppositeTrading(input_Opposite_Trading);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_PositionManagement(input_Position_Management, input_ClosePartialArray, input_ClosePartialProfitMode, input_UseVirtualPrice, input_MagicNumber);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_ReversePositioning(input_Reverse_Positioning);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_RiskFree(input_Risk_Free, input_RiskFreeMode, input_RiskFreeExtra, input_RiskFreeIncludeSwapXMinBeforeDayEnd, input_UseVirtualPrice, input_MagicNumber);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_RiskManagement(input_Risk_Management, input_RiskManagement_ProfitSteps_Custom, input_RiskManagement_ProfitMultiplier_Custom, input_RiskManagement_LossSteps_Custom, input_RiskManagement_LossMultiplier_Custom, input_UseVirtualPrice, input_MagicNumber);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);

   RetVal = OnInitEvent_SessionsFilter(input_LondonSession, input_LondonSession_StartTime, input_LondonSession_EndTime, input_NewYorkSession, input_NewYorkSession_StartTime, input_NewYorkSession_EndTime, input_SydneySession, input_SydneySession_StartTime, input_SydneySession_EndTime, input_TokyoSession, input_TokyoSession_StartTime, input_TokyoSession_EndTime);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);
   
   RetVal = OnInitEvent_TrailEntry(input_Trail_Entry, input_TrailEntryStepInPoints, input_TrailEntryStopInPoints);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);
   
   RetVal = OnInitEvent_TrailStop(input_UseTrailStop, input_TrailStopLoss, input_TrailStopLossMode, input_TrailStepLoss, input_TrailStepLossMode);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);
   
   RetVal = OnInitEvent_WeekendFilter(input_WeekendFilter_XMinutesBeforeMarketClose);
   if (RetVal != INIT_SUCCEEDED) return(RetVal);
      
   if (!CreateIndicatorsHandles()) return(INIT_FAILED);
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
if (TimeCurrent() >= D'2022.11.1 14:27'+29)
{
   int a =0;
}
   static datetime LastTime = iTime(NULL,0,1);
   bool IsNewCandle = LastTime != iTime(NULL,0,1);
   if (IsNewCandle) LastTime = iTime(NULL,0,1);
   
   static int MaxTrailedInPoints = 0;
   
   bool CanEnterTrade = TradingFramework_OnCalculateEvent(input_UseVirtualPrice, input_MagicNumber, input_MaxSlippage, "TLB");
            
   static int Signal = 0; static datetime SignalTime = 0; static double SignalPrice = 0, SignalSL = 0;
   if (IsNewCandle && CanEnterTrade)
   {
      double SL=0;
      int TempSignal = TrendLineSignal(SL);
      if (TempSignal != 0) 
      {
         Signal = TempSignal;
         SignalTime = iTime(NULL,0,0);
         MaxTrailedInPoints = 0;
         SignalPrice = iOpen(NULL,0,0);
         SignalSL = SL;
      }
   }
   
   if (TimeCurrent() >= D'2022.11.1 2:49')
   {
      int a = 0;
   }
   bool EnterTrade;
   int BuyOrSell=-1;
   if (Signal != 0)
   {
      BuyOrSell = (Signal > 0 ? 0 : 1);
      EnterTrade = CTrailEntry_EnterTrade(MaxTrailedInPoints, BuyOrSell, SignalPrice);
   }
   
   string TradeCommentPref = "TLB"+(string)((int)SignalTime);
   if (CanEnterTrade 
       && Signal != 0
       && !CTrade_PositionExist(input_MagicNumber, _Symbol, (Signal > 0 ? 0 : 1), TradeCommentPref)
      )
   {            
      if (EnterTrade)
      { 
         string symbol = _Symbol;
         double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
         double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
         ENUM_ORDER_TYPE type = (BuyOrSell == 0 ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
         double price = (BuyOrSell == 0 ? ask : bid);
         double sl = SignalSL;
         
         
         int TotalPositions = OpenTrade(symbol, type, price, sl, input_MagicNumber, input_MaxSlippage, input_UseVirtualPrice, TradeCommentPref, "TLB");
         
         if (TotalPositions > 0)
         {                  
            MaxTrailedInPoints = 0;
            Signal = 0;
         }
      }
   }
}

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   TradingFramework_OnChartEvent_(id, lparam, dparam, sparam);

}

int TrendLineSignal(double &SL)
{
   double Breakout_Buy = CIndicator_GetBufferValue(TLB_Handle, 2, 1);
   if (Breakout_Buy > 0 && Breakout_Buy != EMPTY_VALUE)
   {
      SL = CIndicator_GetBufferValue(TLB_Handle, 4, 1);
      return(1);
   }
   
   double Breakout_Sell = CIndicator_GetBufferValue(TLB_Handle, 3, 1);
   if (Breakout_Sell > 0 && Breakout_Sell != EMPTY_VALUE)
   {
      SL = CIndicator_GetBufferValue(TLB_Handle, 5, 1);
      return(-1);
   }
   
   return(0);
}

int TLB_Handle;
bool CreateIndicatorsHandles()
{
   TLB_Handle 
         = iCustom(_Symbol, 0, input_IndicatorName
                   , input_length
                   , input_Slope
                   , input_method
               );
       
   if(TLB_Handle==INVALID_HANDLE) 
   {
      //--- tell about the failure and output the error code 
      PrintFormat("Failed to create handle of the %s indicator for the symbol %s/%s, error code %d", 
                  input_IndicatorName,
                  _Symbol, 
                  EnumToString(_Period), 
                  GetLastError()); 
      //--- the indicator is stopped early 
      return(false); 
   }  
   
   return(true);
}
//+------------------------------------------------------------------+
