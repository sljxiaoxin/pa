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
      datetime CheckTime;
      CKeltnerChannel *oHc;
      CPriceAction *oPA;
      string trend;
   public:
      
      CEngulfing(string _symbol){
         symbol = _symbol;
         engulf = "none";
         GetPip();
         oHc = new CKeltnerChannel(symbol,0);
         oPA = new CPriceAction(symbol,m_Pip);
         trend = "none";
      };
      void Tick();
      string GetSymbol();
      string GetEngulf();
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

   

}
void CEngulfing::Entry(void){
   if(trend == "long"){
      if(oPA.isBullPin()){
         if(symbol == Symbol())CDrawArrow::ArrowUp(TimeCurrent(),Low[1]-4*m_Pip);
         string level = oPA.bullFiboLevel();
         Print(TimeCurrent()," ; ",symbol,"---bull level=>",level);
      }
   }
   if(trend == "short"){
      if(oPA.isBearPin()){
         if(symbol == Symbol())CDrawArrow::ArrowDown(TimeCurrent(),High[1]+4*m_Pip);
         string level = oPA.bearFiboLevel();
         Print(TimeCurrent()," ; ",symbol,"---bear level=>",level);
      }
   }
}


void CEngulfing::GetTrend(){
     if(trend == "none"){
         if(iClose(symbol,0,1)>oHc.dataTop[1]){
            //关闭大于通道上层
            if(oPA.Distance(2) > 7.5*m_Pip){
               //前两只距离大于8点
               trend = "long";
            }
         }
         else if(iClose(symbol,0,1)<oHc.dataBottom[1]){
            if(oPA.Distance(2) > 7.5*m_Pip){
               //前两只距离大于8点
               trend = "short";
            }
         }
     }else if(trend == "long"){
         if(iClose(symbol,0,1)<oHc.data[1] && iClose(symbol,0,2)<oHc.data[1]){
            trend = "none";
         }
     }else if(trend == "short"){
         if(iClose(symbol,0,1)>oHc.data[1] && iClose(symbol,0,2)>oHc.data[1]){
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
   if(vdigits==2 || vdigits==4){
      m_Pip = vpoint;
   }else if(vdigits==3 || vdigits==5){
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