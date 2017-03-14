//= require jquery.fancybox.pack

$(document).ready(function() {

	$( ".time" ).each(function( i ) {
		timeCountInBid(this)	
	});
	
	$(".bid").on("mouseover",function(e){
		$(this).find(".overlay").removeClass("hide");
	});
	
	$(".bid").on("mouseleave",function(e){
		$(this).find(".overlay").addClass("hide");
	});
	
	$(".goToBidContainer a img").on("mouseover",function(e){
		src=$(this).attr("src");
		src=src.replace("Main","Hover");
		$(this).attr("src",src);
	});
	$(".goToBidContainer a img").on("mouseleave",function(e){
		src=$(this).attr("src");
		src=src.replace("Hover","Main");
		$(this).attr("src",src);
	});
	
	
	$(".fancyImage").fancybox();
	$(".fancyText").fancybox();	
	
	
	$("#bidSelector a.value").on("click",function(e){
		e.preventDefault();
		var values=$(this).html().split(".")
		$("#eurosBid").val(values[0])
		$("#centsBid").val(values[1])
	});
		
	var intervalBid=undefined;
	$("#bidSelector .previous").on("mouseover",function(e){
		if (intervalBid==undefined){
			intervalBid=setInterval(lessValues,100);
		}
	});
	$("#bidSelector .next").on("mouseover",function(e){
		if (intervalBid==undefined){
			intervalBid=setInterval(moreValues,100);
		}
	});
	$("#bidSelector .bidMove").on("mouseleave",function(e){
		clearInterval(intervalBid);
		intervalBid=undefined;
	});
	
	$("#bidButtonContainer a").on("click",doBet);
	$(".alertBox a").click(function(e){
		e.preventDefault();
		$(this).closest(".alertBox").addClass("hide")
	});
	
	$(".bidCheck").click(function(e){
		
	    e.preventDefault();
	    if (!($(this).hasClass("option_checked"))){
		    $(".option_checked").each(function( index, value ) {
		    	managefreehalfbids(this);
		    });
		}	
		managefreehalfbids(this);
	})
	if ($('#reload').length > 0) {
		setInterval(function() {
			$("#reload").click();
			
		},90000);
	}
	
	var cookiesacepted=$.cookie('cookiesAcepted');
	if (cookiesacepted!="true"){
		$.cookie('cookiesAcepted',"true");
		$("#CookieAdvice").removeClass("hide");
	}
	$("#CookieAdvice .close").click(function(e){
		e.preventDefault();
		$("#CookieAdvice").addClass("hide");
	});
	
	if($("#trophy").length>0){
		setInterval(function() {
			$("#trophy").effect( "highlight","slow");
			
		},5000);
		
	}	
	
	$("#gotoDesktop").click(function(e){
		$.cookie('preferencedesktop',"true");
	});
	$("#gotoMovileVersion").click(function(e){
		$.cookie('preferencedesktop',"false");
	});
	
});

function timeCountInBid(obj){
	var seconds=$(obj).find('.seconds span').html();
	var minutes=$(obj).find('.minutes span').html();
	var hours=$(obj).find('.hours span').html();
	var countRetry=0;
	var id=$(obj).attr("data-id");
	var counter=setInterval(function() {
    				seconds=seconds-1
    				if (seconds<0){
    					seconds=59;
    					minutes=minutes-1;
    				}
    				if (minutes<0){
    					minutes=59;
    					hours=hours-1;
    				}
    				if (hours<0){
    					    minutes=0;
		    				seconds=0;
		    				hours=0;
		    				
    					if (countRetry==0){
    						

	    					$.ajax({
	    						url:'/bids/bidTime/'+id+'.json',
	    						data: 'json',
	    						async: false
	    					}).done (function( data ) {
	    						if (data.tryagain==undefined ){
		    						minutes=data.minutes;
		    						seconds=data.seconds;
		    						hours=data.hours;
		    					}else{
		    						if (data.ended==true){
		    							countRetry=3000;
		    							location.reload();		    							
		    						}else{
		    							countRetry=5;
		    						}
		    					}
	    					});
	    				}else{
	    					countRetry=countRetry-1;
	    				}
    						
    				}    				
    				updateTime(obj,seconds,minutes,hours);
    				
				},
				 1000);
}


function updateTime(obj,seconds,minutes,hours){
	seconds+='';
	minutes+='';
	hours+='';
	if (seconds.length<2){
		seconds="0"+seconds;
	}
	if (minutes.length<2){
		minutes="0"+minutes;
	}
	if (hours.length<2){
		hours="0"+hours;
	}
	$(obj).find('.seconds span').html(seconds)
	$(obj).find('.minutes span').html(minutes)
	$(obj).find('.hours span').html(hours)

}

function lessValues(){

	
	$("a.value").each(function( i ) {
		var actualValue=parseFloat($(this).html(),10);
		var diff=0.01;
		var newValue=(actualValue-diff).toFixed(2);
		if (newValue>=0){
			if (newValue.length<5){
				newValue="0"+newValue;
			}
			$(this).html(newValue)
			
		}else{
			 return false;
		}
	});
}
function moreValues(){
	var maxValue=$("#bidSelector").attr("data-max");
	$("a.value").each(function( i ) {
		var actualValue=parseFloat($(this).html(),10);
		var diff=parseFloat((0.06-(i*0.01)).toFixed(2));		
		if ((actualValue+diff)<=maxValue){
			var newValue=(actualValue+0.01).toFixed(2);
			if (newValue.length<5){
				newValue="0"+newValue;
			}
			$(this).html(newValue)
		}else{
			 return false;
		}
	});
}

function doBet(e){
	
	e.preventDefault();
	
	$.ajax({
		url:'/bets/create',
		data: $("#InputMoneyContainer").serialize(),
    	beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
		type: 'post',
		error:function(){
			$("#errorBox").removeClass("hide");
		},
		async: false
	}).done (function( data ) {
		if (data.result=="success"){
			$(".alertBox").addClass("hide");
			$('#reload').click();
			if (data.status==1){
				$("#successBox p").html(''+data.successmsg);
				$("#successBox").removeClass("hide");
			}else if (data.status==2){
				$("#warningBox p").html(''+data.successmsg);
				$("#warningBox").removeClass("hide");
			}else{
				$("#invalidBox p").html(''+data.successmsg);
				$("#invalidBox").removeClass("hide");
			};
			
			$("#userMoney").html(data.money+" €");
			$("#freeBidsUpperCount .redCounter").html(data.freeBids);				
			$("#halfBidsUpperCount .redCounter").html(data.halfBids);
			$("#freeBidsCount ").html("("+data.freeBids+")");
			$("#halfBidsCount ").html("("+data.halfBids+")");
			$("#nbids ").html(data.bids);
			$("#leftnbids ").html(data.leftbids);
			$(".bidSpark").effect( "highlight","slow");	
			
			$(".option_checked").each(function( index, value ) {
		    	managefreehalfbids(this);
		    });
			
		}else{
			
			$("#errorBox p").html(data.errorMessage);
			$("#errorBox").removeClass("hide");
		}
	});
	
}

function managefreehalfbids(obj){
	 
	  $(obj).find("img").toggleClass("hide")
	  $(obj).toggleClass("option_checked");
	  id=$(obj).attr("data-id");
	  valueId=$("#"+id).val();
	  if (valueId=="false"){
			$("#"+id).val("true");
	  }else{
			$("#"+id).val("false");
	  };
	  
	  
		
}



