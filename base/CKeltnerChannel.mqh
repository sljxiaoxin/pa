//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CKeltnerChannel
{  
   private:
     int    vdigits;
     string symbal;
     int tf;   //PERIOD_M1
     
   public:
      double dataTop[50];
      double data[50];
      double dataBottom[50];
      
      CKeltnerChannel(string _symbal, int _tf){
         symbal = _symbal;
         tf = _tf;
         vdigits = (int)MarketInfo(symbal,MODE_DIGITS);
         Fill();
      };
      
      void Fill();
};

void CKeltnerChannel::Fill()
{
   for(int i=0;i<50;i++){
      dataTop[i] = iCustom(symbal,tf,"Keltner Channel",0,i);
      data[i] = iCustom(symbal,tf,"Keltner Channel",1,i);
      dataBottom[i] = iCustom(symbal,tf,"Keltner Channel",2,i);
      dataTop[i] = NormalizeDouble(dataTop[i],vdigits);
      data[i] = NormalizeDouble(data[i],vdigits);
      dataBottom[i] = NormalizeDouble(dataBottom[i],vdigits);
   }
   //Print(TimeCurrent(),symbal+"-----top="+dataTop[1]+";mid="+data[1]+";bottom="+dataBottom[1]);
}
