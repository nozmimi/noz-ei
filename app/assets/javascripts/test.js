function getData_StatsData(db_data,tableTitle,tableData){
  var data = db_data;
  var colName = ["11","12","16","19"];
  for(i=0; i<colName.length; i++){
    console.log(colName[i]);
  }

  for(i=0; i<data.length; i++){
    for(j=0; j<colName.length; j++){
      switch(data[i]["category_code"]){

      case colName[j]:
        var tHead = document.createElement("th");
             tHead.appendChild(document.createTextNode(data[i]["category_name"]));
             tableTitle.appendChild(tHead);
      }
    }
  }

  for(i=0; i<data.length; i++){
    var tRow = tableData.insertRow( -1 );
        tRow.classList.add("text-right");

    var tHead = document.createElement("th");
        tHead.classList.add("text-left");

    tRow.appendChild(tHead).appendChild(document.createTextNode(data[i]["date_name"]));
  }
}
