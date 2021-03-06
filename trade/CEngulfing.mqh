//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, yjx |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CEngulfing
{  
   private:
      string symbol;
      string engulf;
      double m_Pip;
      double Distance;//通道外多少点确立趋势
      datetime CheckTime;
      CKeltnerChannel *oHc;
      CPriceAction *oPA;
      string trend;
      int countFlag;   //失败计数，用于判断趋势失效
   public:
      
      CEngulfing(string _symbol, double _Distance,double pin){
         symbol = _symbol;
         engulf = "none";
         GetPip();
         oHc = new CKeltnerChannel(symbol,0);
         oPA = new CPriceAction(symbol,m_Pip,pin);
         trend = "none";
         Distance = _Distance;
         countFlag = 0;
      };
      void Tick();
      string GetSymbol();
      string GetEngulf();
      bool isBearMiddle(); //中线信号
      bool isBullMiddle();
      bool isBearOuter(); //中线信号
      bool isBullOuter();
      double GetPip();
      void Draw();
      void GetTrend();
      void Entry();
      void SendEmail(string symbol, string signal);
};

void CEngulfing::Tick(){
   if(CheckTime != iTime(symbol,0,0)){
      CheckTime = iTime(symbol,0,0);
      oHc.Fill();
      GetTrend();
      Entry();
      Print(TimeCurrent(),symbol,"trend==",trend);
   }
   //if(symbol == Symbol())Print(symbol,"；",CheckTime,"#",TimeCurrent(),"；diff=",(int)(TimeCurrent()-CheckTime));
   

}

bool CEngulfing::isBearOuter(){
   double open = iOpen(symbol,0,1);
   double close = iClose(symbol,0,1);
   double high = iHigh(symbol,0,1);
   double low = iLow(symbol,0,1);
   if((oHc.dataTop[1]-high<1.5*m_Pip) || high>oHc.dataTop[1]){
      if(open < oHc.dataTop[1] && close < oHc.dataTop[1]){
         if(open > oHc.data[1] && close > oHc.data[1]){
            if((open>close && high - open > close - low) || (open<close && high - close > open - low)){
            
               return true;
            }
         }
      }
   }
   return false;
}

bool CEngulfing::isBullOuter(){
   double open = iOpen(symbol,0,1);
   double close = iClose(symbol,0,1);
   double high = iHigh(symbol,0,1);
   double low = iLow(symbol,0,1);
   if((low -oHc.dataBottom[1]<1.5*m_Pip) || low<oHc.dataBottom[1]){
      if(open > oHc.dataBottom[1] && close > oHc.dataBottom[1]){
         if(open < oHc.data[1] && close < oHc.data[1]){
            if((open>close && high - open < close - low) || (open<close && high - close < open - low)){
            
               return true;
            }
         }
      }
   }
   return false;
}

//通道中边支撑位
bool CEngulfing::isBearMiddle(){
   double open = iOpen(symbol,0,1);
   double close = iClose(symbol,0,1);
   double high = iHigh(symbol,0,1);
   double low = iLow(symbol,0,1);
   if(open>close){
      //中线支撑
      if(close < oHc.data[1] && close>oHc.dataBottom[1]){
         if((oHc.data[1]-high<1.5*m_Pip) || (high > oHc.data[1] && high < oHc.dataTop[1])){
            if(high - open >1*m_Pip && close - low < high-open){
               return true;
            }
         }
      }
   }
   if(open<close){
      //中线支撑
      if(close < oHc.data[1] && close>oHc.dataBottom[1]){
         if((oHc.data[1]-high<1.5*m_Pip) || (high > oHc.data[1] && high < oHc.dataTop[1])){
            if(high - close >1*m_Pip && open - low < high-close){
               return true;
            }
         }
      }
   }
   return false;
}

bool CEngulfing::isBullMiddle(){
   double open = iOpen(symbol,0,1);
   double close = iClose(symbol,0,1);
   double high = iHigh(symbol,0,1);
   double low = iLow(symbol,0,1);
   if(open>close){
      //中线支撑
      if(close > oHc.data[1] && close<oHc.dataTop[1]){
         if((low-oHc.data[1]<1.5*m_Pip) || (low < oHc.data[1] && low > oHc.dataBottom[1])){
            if(close - low >1*m_Pip && close - low > high-open){
               return true;
            }
         }
      }
   }
   if(open<close){
      //中线支撑
      if(close > oHc.data[1] && close<oHc.dataTop[1]){
         if((low-oHc.data[1]<1.5*m_Pip) || (low < oHc.data[1] && low > oHc.dataBottom[1])){
            if(open - low >1*m_Pip && open - low > high-close){
               return true;
            }
         }
      }
   }
   return false;
}

void CEngulfing::Entry(void){
   if(trend == "long"){
      if(oPA.isBullPin()){
         if(symbol == Symbol())CDrawArrow::ArrowUp(iTime(symbol,0,1),iLow(symbol,0,1)-15*m_Pip);
         string level = oPA.bullFiboLevel();
         Print(TimeCurrent()," ; ",symbol,"---bull level=>",level);
         if(isBullMiddle()){
            CDrawText::Draw("中",iTime(symbol,0,1),iLow(symbol,0,1)-12*m_Pip,clrWhite);
            Alert(symbol,"pinbar中线支撑buy信号","；fibo level=",level);
         }else if(isBullOuter()){
            CDrawText::Draw("外",iTime(symbol,0,1),iLow(symbol,0,1)-12*m_Pip,clrWhite);
            Alert(symbol,"pinbar外线支撑buy信号","；fibo level=",level);
         }
      }else if(isBullMiddle()){
         CDrawText::Draw("中",iTime(symbol,0,1),iLow(symbol,0,1)-15*m_Pip,clrWhite);
         string level = oPA.bullFiboLevel();
         Alert(symbol,"中线支撑buy信号","；fibo level=",level);
      }else if(isBullOuter()){
         CDrawText::Draw("外",iTime(symbol,0,1),iLow(symbol,0,1)-15*m_Pip,clrWhite);
         string level = oPA.bullFiboLevel();
         Alert(symbol,"外线支撑buy信号","；fibo level=",level);
      }
   }
   if(trend == "short"){
      if(oPA.isBearPin()){
         if(symbol == Symbol())CDrawArrow::ArrowDown(iTime(symbol,0,1),iHigh(symbol,0,1)+15*m_Pip);
         string level = oPA.bearFiboLevel();
         Print(TimeCurrent()," ; ",symbol,"---bear level=>",level);
         if(isBearMiddle()){
            CDrawText::Draw("中",iTime(symbol,0,1),iHigh(symbol,0,1)+12*m_Pip,clrWhite);
            Alert(symbol,"pinbar中线支撑sell信号","；fibo level=",level);
         }else if(isBearOuter()){
            CDrawText::Draw("外",iTime(symbol,0,1),iHigh(symbol,0,1)+12*m_Pip,clrWhite);
            Alert(symbol,"pinbar外线支撑sell信号","；fibo level=",level);
         }
      }else if(isBearMiddle()){
         CDrawText::Draw("中",iTime(symbol,0,1),iHigh(symbol,0,1)+15*m_Pip,clrWhite);
         string level = oPA.bearFiboLevel();
         Alert(symbol,"中线支撑sell信号","；fibo level=",level);
      }else if(isBearOuter()){
         CDrawText::Draw("外",iTime(symbol,0,1),iHigh(symbol,0,1)+15*m_Pip,clrWhite);
         string level = oPA.bearFiboLevel();
         Alert(symbol,"外线支撑sell信号","；fibo level=",level);
      }
   }
}


void CEngulfing::GetTrend(){
      
      int h=TimeHour(TimeCurrent());
      Print("count time our=",h);
      if(h>=22 || h<=4){
         trend = "none";
         return ;
      }
     if(trend == "none"){
     /*
         if(iClose(symbol,0,1)>oHc.dataTop[1]){
            //关闭大于通道上层
            if(oPA.Distance(2) > Distance*m_Pip){
               //前两只距离大于7.5点
               trend = "long";
            }
         }
         else if(iClose(symbol,0,1)<oHc.dataBottom[1]){
            if(oPA.Distance(2) > Distance*m_Pip){
               //前两只距离大于7.5点
               trend = "short";
            }
         }
         */
         if(iClose(symbol,0,2)>oHc.dataTop[1] && iClose(symbol,0,1)>oHc.dataTop[1]){
            //关闭大于通道上层
            if(oPA.Distance(3) > Distance*m_Pip){
               //前两只距离大于7.5点
               trend = "long";
            }
         }
         else if(iClose(symbol,0,2)<oHc.dataBottom[1] && iClose(symbol,0,1)<oHc.dataBottom[1]){
            if(oPA.Distance(3) > Distance*m_Pip){
               //前两只距离大于7.5点
               trend = "short";
            }
         }
     }else if(trend == "long"){
         if(iClose(symbol,0,1) > oHc.dataTop[1]){
            countFlag = 0;
         }
         if(iClose(symbol,0,2) >= oHc.data[2] && iClose(symbol,0,1) < oHc.data[1]){
            countFlag += 1;
         }
         if(iClose(symbol,0,2) < oHc.data[2] && iClose(symbol,0,1) > oHc.data[1]){
            countFlag += 1;
         }
         if(countFlag >=3){
            trend = "none";
         }
         if(iClose(symbol,0,1)<oHc.dataBottom[1]){
            trend = "none";
         }
     }else if(trend == "short"){
         if(iClose(symbol,0,1) < oHc.dataBottom[1]){
            countFlag = 0;
         }
         if(iClose(symbol,0,2) <= oHc.data[2] && iClose(symbol,0,1) > oHc.data[1]){
            countFlag += 1;
         }
         if(iClose(symbol,0,2) > oHc.data[2] && iClose(symbol,0,1) <= oHc.data[1]){
            countFlag += 1;
         }
         if(countFlag >=3){
            trend = "none";
         }
         if(iClose(symbol,0,1)>oHc.dataTop[1]){
            trend = "none";
         }
     }

}

string CEngulfing::GetSymbol(){
   return symbol;
}

string CEngulfing::GetEngulf(){
   return engulf;
}


void CEngulfing::Draw(){
   if(engulf == "up"){
      if(symbol == Symbol())CDrawArrow::ArrowUp(TimeCurrent(),Low[1]-10*m_Pip);
      SendEmail(symbol, "up");
   }
   if(engulf == "upCheck"){
      if(symbol == Symbol())CDrawArrow::ArrowStop(TimeCurrent(),Low[1]-10*m_Pip);
      SendEmail(symbol, "upCheck");
   }
   if(engulf == "down"){
      if(symbol == Symbol())CDrawArrow::ArrowDown(TimeCurrent(),High[1]+10*m_Pip);
      SendEmail(symbol, "down");
   }
   if(engulf == "downCheck"){
      if(symbol == Symbol())CDrawArrow::ArrowStop(TimeCurrent(),High[1]+10*m_Pip);
      SendEmail(symbol, "downCheck");
   }
}


double CEngulfing::GetPip(){
   
   double vpoint  = MarketInfo(symbol,MODE_POINT);
   int    vdigits = (int)MarketInfo(symbol,MODE_DIGITS);
   if( vdigits==4){
      m_Pip = vpoint;
   }else if(vdigits==2 || vdigits==3 || vdigits==5){
      m_Pip = 10*vpoint;
   }else if(vdigits==6){
      m_Pip = 100*vpoint;
   }else{
      m_Pip = vpoint;
   }
   return m_Pip;
}

void CEngulfing::SendEmail(string symbol, string signal){
   string t=TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS);
   Print("Engulfing","["+t+"]"+symbol+" has triggered ["+signal+"] signal.");
   if(UseEmail)
   SendMail("Engulfing","["+t+"]"+symbol+" has triggered ["+signal+"] signal.");
}