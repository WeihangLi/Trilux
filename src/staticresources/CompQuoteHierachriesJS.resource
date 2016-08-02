function showData() {
	$("#hierCon").html("");
	$("#hierCon").removeData();
	var json = $.parseJSON($("#getJson").text()), flag = true, str = "",pic = "";
	for(var i = 0; i < json.length; i++){
		var realStr = '';
		var qType = json[i].quoteType;
		if(qType == 'AF'){
			pic = boIcon;
		}else if(qType == 'AG'){
			pic = coIcon;
		}else if(qType == 'KA'){
			pic = ordIcon;
		}else{
			pic = '';
		}
		str += '<tr bgcolor="" width="100%" id="'+json[i].recordId + '"  parentsId="" inc="0">' 
				+ '<td class="tdStyle">' 
					+ '<span onclick="getChild(this, \''+json[i].recordId+'\',1)">+</span>';
		if(pic != ''){
			str +=  '<img src="'+pic+'" height="16" width="16" />';
		}
		str +=  '</td>' 
				+'<td class="tdStyle" onclick="openRecord(\''+json[i].recordId+'\');" style="cursor:pointer;">' + json[i].quoteInfo + '</td>'
				
				+'</tr>';		
				
	}
	$("#hierCon").html(str);
	$("#mask").hide();
}



function showMask() { 
	$("#mask").show();
}
function hideMask(){
	$("#mask").hide(); 
}
function openRecord(rdId){
	window.open('/'+rdId);
}