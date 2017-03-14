

$(document).ready(function() {
	$("#loginLink").click(function(e){
		e.preventDefault();
		if( $("#loginForm").hasClass("hide")){
			$("#loginForm").removeClass("hide");			
		}else{
			$("#loginForm").addClass("hide");
		}
	});
	$("#enterBox a").click(doLogin);
	$("#loginFields input").keypress(function(e) {
		removeErrorLogin();
	    if(e.which == 13) {
	        doLogin(e);
	    }
	});
	outOfMenuTimeout=undefined;
	$("#userLink").mouseover(function(e){
		width=$("#userLink").width()+40;
		leftPosition=(width-180)/2
		$("#userTopMenu").css({left:leftPosition})
		$("#userTopMenu").removeClass("hide");
		if(outOfMenuTimeout!=undefined){
			window.clearTimeout(outOfMenuTimeout)
		}
	});
	$("#userLink").mouseleave(function(e){
		outOfMenuTimeout=setTimeout(removeTopMenu,300);
		
	});
});

function doLogin(e){
	
	e.preventDefault();
	
	$.ajax({
		url:'/login',
		data: $("#loginForm").serialize(),
    	beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
		type: 'post',
		async: false
	}).done (function( data ) {
		if (data.result=="success"){
			location.reload();
		}else{
			addErrorLogin();
		}
	});
	
}

function addErrorLogin(){
	$("#loginForm input").addClass("errorInput");
	$("#loginForm input").removeClass("loginInput");
	$("#loginForm .errorText").removeClass("hide");
}
function removeErrorLogin(){
	$("#loginForm input").removeClass("errorInput");
	$("#loginForm input").addClass("loginInput");
	$("#loginForm .errorText").addClass("hide");
}
function removeTopMenu(){
	$("#userTopMenu").addClass("hide");
}

