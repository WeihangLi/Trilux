var lookupElem,scrollTopVal,g_Filter=[],g_arrow;
function showLoading(){
    $('#pageLoading').removeClass('hide');
}
function hideLoading(){
	keepArrow(); 
	$('#pageLoading').addClass('hide');
}
function changeFiled(obj){
	var map_fdName_fdOption = $.parseJSON($(".defaultOp").val());
	var map_fdName_fdValues = $.parseJSON($(".defaultVal").val());
	
	$(obj).parent().next().find(".operator").empty();
	$(obj).parent().siblings(".selValCol").find(".fVal").val('');
	$(obj).parent().siblings(".selValCol").find(".hideVal").val(''); 
	if($(obj).val() == '' || $(obj).val() == null){
		$(obj).parent().next().find(".operator").append("<option value=''>--None--</option>"); 
	}else{ 
		var curFieldName = ($(obj).val().split(","))[0];
		var curFieldType = ($(obj).val().split(","))[1]; 
		var operators = map_fieldType_operator[curFieldType];
		var ops = operators.split('|'); 
		
		var defaultOps = map_fdName_fdOption[curFieldName];
		var defaultVals = map_fdName_fdValues[curFieldName];
		$(obj).parent().siblings(".selValCol").find(".fVal").val(defaultVals);
		for(var i = 0; i < ops.length; i++){ 
			$(obj).parent().next().find(".operator").append("<option value='"+ops[i]+"'>"+ops[i]+"</option>");
			if(ops[i] == defaultOps){
				$(obj).parent().next().find(".operator").val(defaultOps);
			}
		}
		if(curFieldType == 'BOOLEAN' || curFieldType == 'PICKLIST' || curFieldType == 'REFERENCE'){
			$(obj).parent().siblings(".selValCol").find(".fVal").attr('disabled',true);
			$(obj).parent().siblings(".lkpIconTd").find(".lookupIcon").show();
		}else{
			$(obj).parent().siblings(".lkpIconTd").find(".lookupIcon").hide();
			$(obj).parent().siblings(".selValCol").find(".fVal").attr('disabled',false);
		} 
	} 
	
}
function setDefaultField(){
	$(".filterTr").each(function(){
		var thisTdId = $(this).children().eq(0).attr("id"); 
		var selectList = $(this).find(".column");
		$(this).find(".column").children("option").each(function(){
			var optionFieldName = $(this).val().split(',')[0];
			if(optionFieldName == thisTdId){
				//$(this).attr("selected",true);
				$(this).parent().val($(this).val());
				changeFiled(selectList);
			}
		});
	});
}

//pop up window
function openLookUpWindow(elem){
	lookupElem = $(elem).parent().prev().find(".fVal");
	var filedArry = $(elem).parent().siblings(".filedCol").find(".column").val().split(',');
	var objName = $(".objName").val();
	var fieldName = filedArry[0];
	var fieldType = filedArry[1];
	var referenceTo = filedArry[2];
	referenceTo = referenceTo.substring(1,referenceTo.length-1);
	var selectedVal = $(elem).parent().prev().find(".hideVal").val();
	assitOpenLookUp(objName,fieldName,fieldType,referenceTo,selectedVal);
}
function assitOpenLookUp(objName,fieldName,type,referenceTo,selectedVal){
    scrollTopVal = $(document).scrollTop(); 
    $("#mask").appendTo('body').show();
    //var accId = $(".visitAcc").val();
    
    $("#status_window").empty().append(
      '<div id="loading">'
      + '<img src="'
      + rs1
      + '"/>'
      + '</div><div id="iframDiv" style="display:none;">'
      + '<iframe frameborder="0" id="theIframe" width="100%" height="450px" name="theIframe" '
      + 'src="/apex/CtrlpopUpWindow?&objectName='+objName+'&selVal='+selectedVal+'&fieldReference='+referenceTo+'&fieldType='+type+'&fieldName='+fieldName+'"/></div>'
      ).show();
}
function closeLookUp(){
    $("#status_window").empty().hide();
    $('#mask').hide();
    lookupElem = null;
}
function setLookUpVal(strVal,idVal){
    lookupElem.val(strVal).siblings('input[type="hidden"]').val(idVal);
    //$('#selectedProdId').find('input').val(idVal);
    /*if('sample'==productType){
        showLoading();
        //updateQty(); 
    }*/
}
function changeSelObj(obj){
	/*if($(obj).val() != '' && $(obj).val() != null){
		showLoading();
		$(".filedFilterDiv").removeClass('hide');
		changeObjectName();
	}else{
		$(".filedFilterDiv").addClass('hide');
	}*/
	var chooseObj = $(obj).val();
	if(chooseObj != '' && chooseObj != null){
		showLoading();
		changeObjectName();
	}else{
		showLoading();
		noObjSelected();
	}
}
function addRows(){
	var tr = $(".declarativeFilterTable tr").eq(1).clone();   
	$(tr).find(".operator").empty().append("<option value=''>--None--</option>");
	$(tr).find(".fVal").val('');
	$(tr).find(".hideVal").val('');
	$(tr).find(".removeSpan").show();
	$(tr).find(".lookupIcon").hide();
	$(tr).addClass("addLine");
    tr.appendTo(".declarativeFilterTable");   
}
function removeRows(obj){
	$(obj).parent().parent().remove(); 
}

function getFilterCondition(){
	g_Filter = [];
	$(".declarativeFilterTable").find(".filterTr").each(function(){
		var columStr = $(this).find(".column").val();
		var fieldName = columStr.split(',')[0];
		var fieldType = columStr.split(',')[1];
		var fieldOperator = $(this).find(".operator").val();
		var fieldVal = $(this).find(".hideVal").val();
		if(fieldVal == null || fieldVal == ''){
			fieldVal = $(this).find(".fVal").val();
		}
		if(fieldName != '' && fieldName != null && fieldOperator != '' && fieldOperator != null && fieldVal != '' && fieldVal != null){
			obj = {};
			obj["fieldName"] = fieldName;
			obj["operator"] = fieldOperator;
			obj["fieldVal"] = fieldVal;
			obj["fieldType"] = fieldType;
			g_Filter.push(obj);
		}
	});
	var tempStr = JSON.stringify(g_Filter);
	$(".strFilter").children().val(tempStr);
	console.log(tempStr);
	if(tempStr != '' && tempStr != null && tempStr != '[]'){
		showLoading();
		$(".errorMsgDiv").hide();
		searchAccount();
	}else{
		$(".errorMsgDiv").show();
	}
}
function delRecord(dId){
	if(confirm('Are you sure?')){
		$(".delIdVal").children().val(dId);
		showLoading();
		delAccRecord();
	}else{
		return;
	}
}
function calTdWidth(){
	
	$(".resultHeaderTable").width($(".resultInfoTable").width() + 2);
	$(".resultInfoTable > tbody > tr:eq(0) > td").each(function(i, n){
	   var topTh = $(".resultHeaderTable thead tr td").eq(i).find("div");
	   var tabTh = $(this).find("div");
	   if(topTh.width() < tabTh.width()){
	   	   topTh.width(tabTh.width());
	   	   tabTh.width(topTh.width());
	   }else{
	       tabTh.width(topTh.width());
	       topTh.width(tabTh.width());
	   }
	});
	$(".resultInfoDiv").on('scroll', function (event) {
       $(".copydiv").scrollLeft(this.scrollLeft);
    });
    hideLoading();
}
function tsort(el,fieldName,objName){
	showLoading();
    var $el = $(el);
    var method = $el.find("div").children('span').not('.hide');
    if(method.length > 0){
        if(method.hasClass('up')) method='desc';
        else method = 'asc';
    }else{
        method = 'asc';
    }
    var data = [{'objName':objName,'fieldName':fieldName,'orderType':method}];
    g_arrow = data[0];
    data = JSON.stringify(data);
    $('#sortInfo').find('input').val(data);
    searchAccount();
}
function keepArrow(){
    var $tf,$el,tp,pos = 2;
    if(g_arrow){
        $tf = $('.resultHeaderTable').find(".theader");
        tp = g_arrow['fieldName'];
        $tf.children().each(function(){
            $el = $(this);
            if($el.attr('id') == tp){
                if(g_arrow['orderType'] == 'asc'){
                    pos = 0;
                }else if(g_arrow['orderType'] == 'desc'){
                    pos = 1;
                }
                if(pos != 2){
                    $el.find("div").children('span').eq(pos).removeClass('hide');
                    $el.find("div").children('span').eq(1-pos).addClass('hide');
                }
            }else{
                $el.children('span').addClass('hide');
            }
        });
    }
}
function openRecord(id){
	window.open('/'+id);
}