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
     double m_Pip;
     
   public:
      
      CPriceAction(string _symbol, double _m_Pip){
         symbol = _symbol;
         m_Pip = _m_Pip;
      };
      ~CPriceAction(){};
     
      double HighValue(int counts); 
      double LowValue(int counts);
      double Distance(int counts);
      bool isBearPin();
      bool isBullPin();
      string bearFiboLevel();
      string bullFiboLevel();
      
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

bool CPriceAction::isBearPin(){
   double open = iOpen(symbol,0,1);
   double close = iClose(symbol,0,1);
   double high = iHigh(symbol,0,1);
   double low = iLow(symbol,0,1);
   double diffT;
   double distance;
   double diffB;
   if(open>close){
      if(high -low >3*m_Pip){
         diffT = high-open;
         distance = high - low;
         diffB = close - low;
         if(diffT>=distance*0.5){
            return true;
         }
         if(diffT>2*diffB && diffT>=distance*0.25){
            return true;
         }
      }
   }
   if(open<close){
      if(high -low >3*m_Pip){
         diffT = high-close;
         distance = high - low;
         diffB = open - low;
         if(diffT>=distance*0.5){
            return true;
         }
      }
   }
   return false;
}

bool CPriceAction::isBullPin(){
   double open = iOpen(symbol,0,1);
   double close = iClose(symbol,0,1);
   double high = iHigh(symbol,0,1);
   double low = iLow(symbol,0,1);
   double diffT;
   double distance;
   double diffB;
   if(open>close){
      if(high -low >3*m_Pip){
         diffT = high-open;
         distance = high - low;
         diffB = close - low;
         if(diffB>=distance*0.5){
            return true;
         }
      }
   }
   if(open<close){
      if(high -low >3*m_Pip){
         diffT = high-close;
         distance = high - low;
         diffB = open - low;
         if(diffB>=distance*0.5){
            return true;
         }
         if(diffB>2*diffT && diffB>=distance*0.25){
            return true;
         }
      }
   }
   return false;
}

string CPriceAction::bearFiboLevel(){
   int idx = iLowest(symbol,0,MODE_LOW,5,1);
   if(idx <0)return "none";
   int idxHigh = idx;
   for(int i=idx;i<40;i++){
      double low = iLow(symbol,0,i);
      double low_next = iLow(symbol,0,i+1);
      if(low_next >= low){
         continue;
      }else{
         double high = iHigh(symbol,0,i);
         double high_next = iHigh(symbol,0,i+1);
         if(high_next >= high){
            continue;
         }else{
            idxHigh = i;
         }
      }
   }
   double lowest = iLow(symbol,0,idx);
   double highest = iLow(symbol,0,idxHigh);
   double distance = highest-lowest;
   double level_236 = lowest+(distance*0.236);
   double level_382 = lowest+(distance*0.382);
   double level_50  = lowest+(distance*0.5);
   double level_618 = lowest+(distance*0.618);
   double h = iHigh(symbol,0,1);
   if(MathAbs(h-level_618)<1*m_Pip){
      return "level_618";
   }
   if(MathAbs(h-level_50)<1*m_Pip){
      return "level_50";
   }
   if(MathAbs(h-level_382)<1*m_Pip){
      return "level_382";
   }
   if(MathAbs(h-level_236)<1*m_Pip){
      return "level_236";
   }
   return "none";
}

double CPriceAction::bullFiboLevel(){


}