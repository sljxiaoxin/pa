//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, yjx |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"
//H1
class CChance
{  
   private:
      CTrend* oCTrend;
      CSignal* oCSignal;
      CLaguerreRsi* oCLRsi;
      CMacd* oMacd;
      CMacd* oMacdSignal;
      string mTrend;
      int mTf;
      int intDrawing;   //正在画rect
      CDrawRect *oRect;
      
      
   public:
      
      
      CChance(int _mTf,CTrend* _oCTrend, CSignal* _oCSignal, CLaguerreRsi* _oCLRsi, CMacd* _oMacd, CMacd* _oMacdSignal){
         mTf = _mTf;
         oCTrend = _oCTrend;
         oCSignal = _oCSignal;
         oCLRsi = _oCLRsi;
         oMacd = _oMacd;
         oMacdSignal = _oMacdSignal;
         mTrend = "none";
         intDrawing = -1;
         oRect = new CDrawRect("chance_", mTf);
      };
      void Tick();
      bool GetChance();
      void TickDrawMove(int DrawTf);
      
};

bool CChance::GetChance(){
   if(intDrawing >-1){
      return true;
   }
   return false;
}

void CChance::TickDrawMove(int DrawTf)
{
   if(intDrawing >-1){
      intDrawing += 1;
      oRect.Move(DrawTf);
   }
}

void CChance::Tick(void)
{
   int signalPass;
   if(mTrend == "long"){
      mTrend = oCTrend.GetTrend();
      if(mTrend == "long"){
         signalPass = oCSignal.GetIdxPass();
         if(signalPass>-1 && signalPass<24*10){
            if(intDrawing == -1){
               if(oCLRsi.data[1]==1 && oCLRsi.LowValue(0,9)<=0.65){
                  intDrawing = 0;
                  oRect.CreateLong();
               }
            }else if(intDrawing >12*4){
               //>12 hour close draw
               intDrawing = -1;
               oRect.End();
            }
         }
      }
   }
   if(mTrend == "short"){
      mTrend = oCTrend.GetTrend();
      if(mTrend == "short"){
         signalPass = oCSignal.GetIdxPass();
         if(signalPass>-1 && signalPass<24*10){
            if(intDrawing == -1){
               if(oCLRsi.data[1]==0 && oCLRsi.HighValue(0,9)>=0.35){
                  intDrawing = 0;
                  oRect.CreateShort();
               }
            }else if(intDrawing >12*4){
               //>12 hour close draw
               intDrawing = -1;
               oRect.End();
            }
         }
      }
   }
   if(mTrend == "none"){
      mTrend = oCTrend.GetTrend();
      if(intDrawing != -1){
         intDrawing = -1;
         oRect.End();
      }
   }
   
}