//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
#property copyright "xiaoxin003"
#property link      "yangjx009@139.com"
#property version   "1.0"
#property strict

#include "CStrategy.mqh";
 
extern int       Input_MagicNumber  = 20191222;  
extern string    LabelUE             = "Email Settings:";
extern bool      UseEmail            = true;  
extern double    Input_Lots         = 0.1;
extern int       Input_intTP        = 0;
extern int       Input_intSL        = 0;
extern string    Input_symbols      = "GBPUSD;GBPJPY";
extern string    TrendDistance_memo = "欧美等慢货币建议4，棒子黄金建议7.5";
extern double    Input_Distance      = 7.5;  //两颗蜡烛的高低点间距大于多少点，并且最新蜡烛close通道外侧，确立趋势
extern string    Pin_memo = "PinBar最小高度，欧美建议1.5，棒子黄金3";
extern double    Input_Pin          = 3;

CStrategy* oCStrategy;

int testIdx = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
   Print("begin");
   if(oCStrategy == NULL){
      oCStrategy = new CStrategy(Input_MagicNumber,UseEmail,Input_symbols,Input_Distance,Input_Pin);
   }
   oCStrategy.Init(Input_Lots,Input_intTP,Input_intSL);
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print("deinit");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()
{
   testIdx+=1;
   if(testIdx == 20){
      string t=TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS);
      if(UseEmail)
      SendMail("Pa","["+t+"] ea opened ok!!!!");
   }
   oCStrategy.Tick();
   subPrintDetails();
}


void subPrintDetails()
{
   //
   string sComment   = "";
   string sp         = "----------------------------------------\n";
   string NL         = "\n";

   sComment = sp;
   sComment = sComment + "Trend = " + oCStrategy.getTrend() + NL; 
   sComment = sComment + sp;
   sComment = sComment + sp;
   //sComment = sComment + "Lots=" + DoubleToStr(Lots,2) + NL;
   Comment(sComment);
}


