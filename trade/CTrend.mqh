//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, yjx |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CTrend
{  
   private:
      CLaguerreRsi* oCLRsi;
      CMacd* oMacdMain;
      string mTrend;
      int mTf;  //趋势时间框架
      
      CDrawRect *oRect;
      
      
      
   public:
      
      
      CTrend(int _mTf, CLaguerreRsi* _oCLRsi, CMacd* _oMacdMain){
         mTf = _mTf;
         oCLRsi = _oCLRsi;
         oMacdMain = _oMacdMain;
         mTrend = "none";
         
         oRect = new CDrawRect("trend_", mTf);
      };
      void Tick();//计算新趋势
      void TickDrawMove(int EntryTf); //入场趋势tick
      string GetTrend(); //返回当前趋势
      void TrendChange();//用于画线
      
};

void CTrend::Tick(void)
{
   if(mTrend == "none"){
      if(oCLRsi.data[1] == 1 && oMacdMain.data[1]>0){
         mTrend = "long";
         TrendChange();
      }
      if(oCLRsi.data[1] == 0 && oMacdMain.data[1]<0){
         mTrend = "short";
         TrendChange();
      }
   }else if(mTrend == "long"){
      if(/*oCLRsi.data[1] < 0.55 ||*/ oMacdMain.data[1]<0){
         mTrend = "none";
         TrendChange();
      }
   }else if(mTrend == "short"){
      if(/*oCLRsi.data[1] > 0.45 ||*/ oMacdMain.data[1]>0){
         mTrend = "none";
         TrendChange();
      }
   }
}

//周期画线
void CTrend::TickDrawMove(int DrawTf)
{
   oRect.Move(DrawTf);
}


string CTrend::GetTrend(void)
{
   return mTrend;
}

void CTrend::TrendChange(void)
{
   if(mTrend == "none"){
      oRect.End();
   }
   if(mTrend == "long"){
      oRect.CreateLong();
   }
   if(mTrend == "short"){
      oRect.CreateShort();
   }
}
