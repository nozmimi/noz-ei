class EconomicIndicatorController < ApplicationController
  
FISCAL_YEAR = "年度"  
CALENDAR_YEAR = "暦年"
QUARTERLY = "四半期"
MONTHLY = "月"
  
  def index
    get_data_gdp("0003109786",CALENDAR_YEAR)  #国民経済計算（暦年＿名目）
    get_data_gdp("0003109751",CALENDAR_YEAR)  #国民経済計算（暦年＿実質）
    
    get_data_gdp("0003109742",FISCAL_YEAR)  #国民経済計算（年度＿名目）
    get_data_gdp("0003109767",FISCAL_YEAR)  #国民経済計算（年度＿実質）

    get_data_gdp("0003109741",QUARTERLY)  #国民経済計算（四半期＿名目）
    get_data_gdp("0003109785",QUARTERLY)  #国民経済計算（四半期＿名目＿季節調整）
    get_data_gdp("0003109766",QUARTERLY)  #国民経済計算（四半期＿実質）
    get_data_gdp("0003109750",QUARTERLY)  #国民経済計算（四半期＿実質＿季節調整）
  end

  def show
    @SOA = SystemOfNationalAccount.all
    @CL = CategoryList.all
  end


  def table
    gon.data_sna = SystemOfNationalAccount.all
  end


#以下、各統計のデータを呼び出すメソッド。
#統計毎にデータ構造が違うため、使用する統計毎にメソッドを作成することにしました。

  #（メモ）国民経済計算より（主にGDP）
  def get_data_gdp(stats_data_id,total_unit)
  
    # アクセスするURLを取得
    get_api_url(stats_data_id)
    
    # データの取得
    req_uri = URI.parse(@req_url)
    data_json = Net::HTTP.get(req_uri)
    data_all = JSON.parse(data_json, symbolize_names: true)
    
    # データの更新日時の取得
    update_date = data_all[:GET_STATS_DATA][:STATISTICAL_DATA][:TABLE_INF][:UPDATED_DATE]
    
    # 統計データ名の取得
    stats_title = data_all[:GET_STATS_DATA][:STATISTICAL_DATA][:TABLE_INF]

    # date,categoryの取り出し
    data_classobj = data_all[:GET_STATS_DATA][:STATISTICAL_DATA][:CLASS_INF][:CLASS_OBJ]
    # pp data_classobj
   
    # date,categoryごとのデータの取り出し
    data_datainf = data_all[:GET_STATS_DATA][:STATISTICAL_DATA][:DATA_INF]
    # pp data_datainf


    db_catlist = CategoryList.all
    if db_catlist.count == 0
      db_catlist.create(category_code:stats_title[:@id], category_name:stats_title[:STAT_NAME][:"$"] ,data_update_date:update_date)
    end
    
    db_sna = SystemOfNationalAccount.all
    if  0 == db_sna.count
      classobj_time = {}
      classobj_cat = {}

      data_classobj.each do |obj|
        case obj[:@id] 
        when "time" then
          data_classobj_time = obj[:CLASS]
          # pp data_classobj_time
            data_classobj_time.each do |obj_time|
              classobj_time[obj_time[:@code]] = obj_time[:@name]
            end
        when "cat01" then
          data_classobj_cat = obj[:CLASS]
          # pp data_classobj_cat
            data_classobj_cat.each do  |obj_cat|
              classobj_cat[obj_cat[:@code]] = obj_cat[:@name]
            end
        end
      end
      
      data_datainf[:VALUE].each do |data_inf|
        db_sna.create(
          category_code:data_inf[:@cat01], 
          category_name:classobj_cat[data_inf[:@cat01]],           
          date_code:data_inf[:@time], 
          date_name:classobj_time[data_inf[:@time]], 
          amount:data_inf[:"$"], 
          unit:data_inf[:@unit],
          period_time:total_unit,
          update_date:update_date
          )
        #  )
      end
    end
  end
  
  #（メモ）e-statのAPIアドレスを作成するメソッド
  def get_api_url(stats_data_id)
    api_url = "https://api.e-stat.go.jp/rest/2.1/app/json/getStatsData"    
    api_appid = "bb86c86ee575b3adfa4930ee0f17a74de14e57e6"
    @req_url = api_url +"?appId=" + api_appid +"&statsDataId=" + stats_data_id
  end
end