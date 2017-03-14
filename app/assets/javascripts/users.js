//= require jquery.fancybox.pack

$(document).ready(function() {

	$(".editUser").click(showForm);
	$("#sendForm").click(function(e){
		e.preventDefault();
		$(this).closest('form').submit();
		
	});
	
	if ($("#detailsSection").hasClass("errors_found")){
		showForm()
	}
	$(".payBid").click(payBid)
	$("body").delegate(".confirmButton","click",confirmBid)
});

function showForm(e){
	if (e!=undefined){
		e.preventDefault();
	}
	$(".value").toggleClass("hide");
	$(".hiddableButton").toggleClass("hide");
}

function payBid(e){
	
	e.preventDefault();
	obj=$(this)
	
	$.ajax({
		url:$(this).attr("href"),
    	beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
		type: 'post',
		async: false
	}).done (function( data ) {
		if (data.result=="success"){
			if(data.type=="Dinero"){
				$("#successBox p").html(""+data.msgmoney);
				$(obj).closest(".buttonContainer").html('<a id="payedBid" class="formButton payButton " href="#payedBid">'+data.msgpayed+'</a>')
			}else{
				$("#successBox p").html(""+data.msgprize);
				$(obj).closest(".buttonContainer").html('<a  class="formButton confirmButton" href="/user/confirmbid/'+data.id+'/product">'+data.msgrequestproduct+'</a>	<a  class="formButton confirmButton" href="/user/confirmbid/'+data.id+'/money">'+data.msgrequestcredits+'</a>');
				
			}
			$("#successBox").removeClass("hide");			
			$("#userMoney").html(data.money+" €");
	
	
	

			
		}else{
			
			$("#warningBox ").html(""+data.msgerror);
			$("#warningBox").removeClass("hide");
		}
	});
	
	
	
	
	
}

function confirmBid(e){
	e.preventDefault();
	obj=$(this)
	
	$.ajax({
		url:$(this).attr("href"),
    	beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
		type: 'post',
		async: false
	}).done (function( data ) {
		if (data.result=="success"){
			
			if(data.type=="money"){
				$("#successBox p").html(""+data.msgmoney);
			}else{
				$("#successBox").html(""+data.msgproduct);
				
			}		
			$("#successBox").removeClass("hide");			
			$("#userMoney").html(data.money+" €");
			$(obj).closest(".buttonContainer").html('<a id="payedBid" class="formButton payButton " href="#payedBid">'+data.msgpayed+'</a>')

			
		}else{
			
			$("#warningBox p").html("El proceso no se ha podido realizar,intentelo de nuevo más tarde")			 
			$("#warningBox").removeClass("hide");
		}
	});
	
	
}