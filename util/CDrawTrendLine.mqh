//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CDrawTrendLine
{  

   private:
      static int s_index;
   
   public:
   
      static bool Draw(datetime time1,double price1,datetime time2,double price2, color clr);
};

int CDrawTrendLine::s_index = 0;

static bool CDrawTrendLine::Draw(datetime time1,double price1,datetime time2,double price2, color clr)
{
   s_index += 1;
   int chart_ID = 0;
   string name = "Trendline_"+s_index;
   int width = 1;
   
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,0,time1,price1,time2,price2))
   {
     Print(__FUNCTION__,
         ": failed to create a trend line! Error code = ",GetLastError());
     return(false);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,false);
   return true;
}

