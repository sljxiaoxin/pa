//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, yjx |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CSignal
{  
   private:
      CTrend* oCTrend;
      CLaguerreRsi* oCLRsi;
      CMacd* oMacd;
      CMacd* oMacdSignal;
      string mTrend;
      int mTf;  //过滤时间框架
      int idxNum; //signal后H1过了多少颗
      
      
   public:
      
      
      CSignal(int _mTf,CTrend* _oCTrend, CLaguerreRsi* _oCLRsi, CMacd* _oMacd, CMacd* _oMacdSignal){
         mTf = _mTf;
         oCTrend = _oCTrend;
         oCLRsi = _oCLRsi;
         oMacd = _oMacd;
         oMacdSignal = _oMacdSignal;
         mTrend = "none";
         idxNum = -1;
      };
      void Tick();
      void TickIdxPass();
      int  GetIdxPass();
      
};

int CSignal::GetIdxPass(void){
   return idxNum;
}

void CSignal::TickIdxPass(void){
   //由chance调用
   if(mTrend != "none" && idxNum>-1){
      idxNum += 1;
   }else{
      idxNum = -1;
   }
}

void CSignal::Tick(void)
{
   
   if(mTrend == "long"){
      mTrend = oCTrend.GetTrend();
      if(mTrend == "long"){
         if(oCLRsi.data[2]<0.5 && oCLRsi.data[1]>0.5){
            if(oCLRsi.LowValue(0,9)<0.15){
               if(oMacdSignal.data[1]<0 && oMacdSignal.data[1]<oMacd.data[1]){
                  CDrawLine::Vline(TimeCurrent(), clrRed);
                  idxNum = 0;
               }
            }
         }
         
      }
   }
   if(mTrend == "short"){
      mTrend = oCTrend.GetTrend();
      if(mTrend == "short"){
         if(oCLRsi.data[2]>0.5 && oCLRsi.data[1]<0.5){
            if(oCLRsi.HighValue(0,9)>0.85){
               if(oMacdSignal.data[1]>0 && oMacdSignal.data[1]>oMacd.data[1]){
                  CDrawLine::Vline(TimeCurrent(), clrRed);
                  idxNum = 0;
               }
            }
         }
        
      }
   }
   if(mTrend == "none"){
      mTrend = oCTrend.GetTrend();
   }
   
}