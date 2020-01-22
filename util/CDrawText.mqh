//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CDrawText
{  

   private:
      static int s_index;
   
   public:
   
      static bool Draw(string text,datetime time1,double price1, color clr);
};

int CDrawText::s_index = 0;

static bool CDrawText::Draw(string text,datetime time1,double price1, color clr)
{
   s_index += 1;
   int chart_ID = 0;
   string name = "Text_"+s_index;
   int width = 1;
   
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,0,time1,price1))
   {
     Print(__FUNCTION__,
         ": failed to create a text line! Error code = ",GetLastError());
     return(false);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,"Arial");
   return true;
}

