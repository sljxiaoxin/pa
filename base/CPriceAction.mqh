//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CPriceAction
{  
   private:
     string symbol;
     
   public:
      
      CPriceAction(string _symbol){
         symbol = _symbol;
      };
      ~CPriceAction(){};
     
      double HighValue(int counts); 
      double LowValue(int counts);
      double Distance(int counts);
      
};

double CPriceAction::HighValue(int counts)
{
   double high = 0;
   double curH;
   for(int i=1;i<=counts;i++){
      curH = iHigh(symbol,0,i);
      if(curH>high){
         high = curH;
      }
   }
   return high;
}

double CPriceAction::LowValue(int counts)
{
   double low = 999999;
   double curL;
   for(int i=1;i<=counts;i++){
      curL = iLow(symbol,0,i);
      if(curL<low){
         low = curL;
      }
   }
   return low;
}

double CPriceAction::Distance(int counts)
{
   double high = HighValue(counts);
   double low = LowValue(counts);
   return NormalizeDouble(high - low,Digits);
}
