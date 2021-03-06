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
     double pin;
     
   public:
      
      CPriceAction(string _symbol, double _m_Pip, double _pin){
         symbol = _symbol;
         m_Pip = _m_Pip;
         pin = _pin;
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
      if(high -low >pin*m_Pip){//过滤过小蜡烛
         diffT = high-open;
         distance = high - low;
         diffB = close - low;
         if(diffT>open-close && diffT>diffB){
            return true;
         }
         if(diffT>=distance*0.5){
            return true;
         }
         if(diffT>2*diffB && diffT>=distance*0.25){
            return true;
         }
      }
   }
   if(open<close){
      if(high -low >pin*m_Pip){
         diffT = high-close;
         distance = high - low;
         diffB = open - low;
         //if(diffT>1.5*(close-open) && diffT>diffB){
         if(diffT>0.6*(close-open) && diffT>diffB){
            return true;
         }
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
      if(high -low >pin*m_Pip){
         diffT = high-open;
         distance = high - low;
         diffB = close - low;
        //if(diffB>1.5*(open-close) && diffT<diffB){
        if(diffB>0.6*(open-close) && diffT<diffB){
            return true;
         }
         if(diffB>=distance*0.5){
            return true;
         }
      }
   }
   if(open<close){
      if(high -low >pin*m_Pip){
         diffT = high-close;
         distance = high - low;
         diffB = open - low;
         if(diffB>close-open && diffT<diffB){
            return true;
         }
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
            break;
         }
      }
   }
   idxHigh = iHighest(symbol,0,MODE_HIGH,(idxHigh-idx),idx);
   double lowest = iLow(symbol,0,idx);
   double highest = iHigh(symbol,0,idxHigh);
   double distance = highest-lowest;
   double level_236 = lowest+(distance*0.236);
   double level_382 = lowest+(distance*0.382);
   double level_50  = lowest+(distance*0.5);
   double level_618 = lowest+(distance*0.618);
   double h = iHigh(symbol,0,1);
   double rate = 1.1;
   if(distance<20*m_Pip){
      rate = 0.7;
   }else if(distance<=40*m_Pip){
      rate = 1.4;
   }else if(distance<=60*m_Pip){
      rate = 1.9;
   }else{
      rate = 2.2;
   }
   if(MathAbs(h-level_618)<rate*m_Pip){
      if(symbol == Symbol()){
         CDrawTrendLine::Draw(iTime(symbol,0,idxHigh),highest,iTime(symbol,0,idx),lowest,clrYellow);
         CDrawTrendLine::Draw(iTime(symbol,0,idxHigh),level_618,iTime(symbol,0,1),level_618,clrYellow);
         CDrawText::Draw("61.8",iTime(symbol,0,1),level_618+6*m_Pip,clrWhite);
      }
      return "level_618";
   }
   if(MathAbs(h-level_50)<rate*m_Pip){
      if(symbol == Symbol()){
         CDrawTrendLine::Draw(iTime(symbol,0,idxHigh),highest,iTime(symbol,0,idx),lowest,clrYellow);
         CDrawTrendLine::Draw(iTime(symbol,0,idxHigh),level_50,iTime(symbol,0,1),level_50,clrRed);
         CDrawText::Draw("50",iTime(symbol,0,1),level_50+6*m_Pip,clrWhite);
      }
      return "level_50";
   }
   if(MathAbs(h-level_382)<rate*m_Pip){
      if(symbol == Symbol()){
         CDrawTrendLine::Draw(iTime(symbol,0,idxHigh),highest,iTime(symbol,0,idx),lowest,clrYellow);
         CDrawTrendLine::Draw(iTime(symbol,0,idxHigh),level_382,iTime(symbol,0,1),level_382,clrWhite);
         CDrawText::Draw("38.2",iTime(symbol,0,1),level_382+6*m_Pip,clrWhite);
      }
      return "level_382";
   }
   /*
   if(MathAbs(h-level_236)<rate*m_Pip){
      if(symbol == Symbol()){
         CDrawTrendLine::Draw(iTime(symbol,0,idxHigh),highest,iTime(symbol,0,idx),lowest,clrYellow);
         CDrawTrendLine::Draw(iTime(symbol,0,idxHigh),level_236,iTime(symbol,0,1),level_236,clrAqua);
         CDrawText::Draw("23.6",iTime(symbol,0,1),level_236+6*m_Pip,clrWhite);
      }
      return "level_236";
   }
   */
   return "none";
}

string CPriceAction::bullFiboLevel(){
   int idx = iHighest(symbol,0,MODE_HIGH,5,1);
   if(idx <0)return "none";
   int idxLow = idx;
   for(int i=idx;i<40;i++){
      double high = iHigh(symbol,0,i);
      double high_next = iHigh(symbol,0,i+1);
      if(high_next <= high){
         continue;
      }else{
         double low = iLow(symbol,0,i);
         double low_next = iLow(symbol,0,i+1);
         if(low_next <= low){
            continue;
         }else{
            idxLow = i;
            break;
         }
      }
   }
   idxLow = iLowest(symbol,0,MODE_LOW,(idxLow-idx),idx);
   double highest= iHigh(symbol,0,idx);
   double lowest = iLow(symbol,0,idxLow);
   double distance = highest-lowest;
   double level_236 = highest-(distance*0.236);
   double level_382 = highest-(distance*0.382);
   double level_50  = highest-(distance*0.5);
   double level_618 = highest-(distance*0.618);
   double l = iLow(symbol,0,1);
   double rate = 1.1;
   if(distance<20*m_Pip){
      rate = 0.7;
   }else if(distance<=40*m_Pip){
      rate = 1.4;
   }else if(distance<=60*m_Pip){
      rate = 1.9;
   }else{
      rate = 2.2;
   }
   if(MathAbs(l-level_618)<rate*m_Pip){
      if(symbol == Symbol()){
         CDrawTrendLine::Draw(iTime(symbol,0,idxLow),lowest,iTime(symbol,0,idx),highest,clrYellow);
         CDrawTrendLine::Draw(iTime(symbol,0,idxLow),level_618,iTime(symbol,0,1),level_618,clrYellow);
         CDrawText::Draw("61.8",iTime(symbol,0,1),level_618-4*m_Pip,clrWhite);
      }
      return "level_618";
   }
   if(MathAbs(l-level_50)<rate*m_Pip){
      if(symbol == Symbol()){
         CDrawTrendLine::Draw(iTime(symbol,0,idxLow),lowest,iTime(symbol,0,idx),highest,clrYellow);
         CDrawTrendLine::Draw(iTime(symbol,0,idxLow),level_50,iTime(symbol,0,1),level_50,clrRed);
         CDrawText::Draw("50",iTime(symbol,0,1),level_50-4*m_Pip,clrWhite);
      }
      return "level_50";
   }
   if(MathAbs(l-level_382)<rate*m_Pip){
      if(symbol == Symbol()){
         CDrawTrendLine::Draw(iTime(symbol,0,idxLow),lowest,iTime(symbol,0,idx),highest,clrYellow);
         CDrawTrendLine::Draw(iTime(symbol,0,idxLow),level_382,iTime(symbol,0,1),level_382,clrWhite);
         CDrawText::Draw("38.2",iTime(symbol,0,1),level_382-4*m_Pip,clrWhite);
      }
      return "level_382";
   }
   /*
   if(MathAbs(l-level_236)<rate*m_Pip){
      if(symbol == Symbol()){
         CDrawTrendLine::Draw(iTime(symbol,0,idxLow),lowest,iTime(symbol,0,idx),highest,clrYellow);
         CDrawTrendLine::Draw(iTime(symbol,0,idxLow),level_236,iTime(symbol,0,1),level_236,clrAqua);
         CDrawText::Draw("23.6",iTime(symbol,0,1),level_236-4*m_Pip,clrWhite);
      }
      return "level_236";
   }*/
   return "none";

}