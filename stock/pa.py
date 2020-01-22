import time
import datetime
import random
import tushare
import pandas
import sys

stock_list_file = 'stock_list.csv'
stock_result_file = 'result.csv'
tushare_token = "611bfd8fdd752a60f0ccd5d4fbbdee150de28b228ef2dae1015db728"

def get_stock_basic() :
    print("开始下载列表数据")
    #获取tushare
    pro = tushare.pro_api()
    data = pro.query('stock_basic', exchange='', list_status='L', fields='ts_code,symbol,name,area,industry,list_date')
    #保存到csv文件
    data.to_csv(stock_list_file)

if __name__ == '__main__':
    print("----begin----")
    pro = tushare.pro_api()
    tushare.set_token(tushare_token)
    #get_stock_basic()
    data = pandas.read_csv(stock_list_file,header=0) #nrows=100
    #data = data.loc[1140:1320]
    #print(data)
    result = []
    result2 = []
    result.append({"ts_code":"insideBar Breakout", "name":"突破"})
    result2.append({"ts_code":"insideBar", "name":"内线"})
    curIdx = 0
    for index, row in data.iterrows():
        curIdx += 1
        print(row['ts_code'], row['symbol'])
        #取12个工作日
        df = pro.daily(ts_code=row['ts_code'], start_date='20200106', end_date='20200121')
        #print(df)
        ls = []
        for index2, row2 in df.iterrows():
            #print("trade_date=>", row2['trade_date'],"; open=>", row2['open'],"; high=>",row2['high'],"; close=>",row2['close'],"; low=>",row2['low'])
            ls.append({"date":row2['trade_date'], "open" : row2["open"], "high" : row2["high"], "close" : row2["close"], "low" : row2["low"]})
        #print(ls)
        #break
        if len(ls) >= 3:
            if ls[2]['open'] < ls[2]['close']:
                if ls[2]['high'] > ls[1]['high'] and ls[2]['low'] <= ls[1]['low'] :
                    if ls[0]['high'] > ls[1]['high']:
                        result.append({"ts_code":row['ts_code'], "name":row['name']})
            
            if ls[1]['open'] < ls[1]['close']:
                if ls[1]['high'] > ls[0]['high'] and ls[1]['low'] <= ls[0]['low'] :
                    result2.append({"ts_code":row['ts_code'], "name":row['name']})
            
            '''
            if ls[1]['open'] > ls[1]['close'] and ls[0]['open'] < ls[0]['close'] and  ls[1]['high'] < ls[0]['high'] and ls[1]['low'] > ls[0]['low'] and ls[1]['close'] < ls[0]['close'] :
                result.append({"ts_code":row['ts_code'], "name":row['name']})
            '''
        
        if curIdx%190 == 0:
            print("暂停70秒")
            print("当前符合条数为：",len(result))
            sys.stdout.flush() #刷新缓冲区
            time.sleep(70)
            
    print("最终符合条数为：",len(result))
    if len(result) > 0:
        d = pandas.DataFrame(result)
        d.to_csv(stock_result_file, mode='a')
        d2 = pandas.DataFrame(result2)
        d2.to_csv(stock_result_file, mode='a')
        
    print("----end----")