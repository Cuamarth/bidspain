//= require jquery
//= require jquery_ujs
//= require ckeditor/init
//= require jquery.fancybox.pack




$(document).ready(function() {

	//FancyBox Events
	$(".fancyImage").fancybox();
	$(".fancyText").fancybox();
	$(".fancyAjax").fancybox({
		  type : 'ajax'
	});
	
	$("#placeSelectorContainer a").click(put_place_in_input);
	

});

function add_product_to_bid(data){
			$('#product_data #title').html(data.title)
			$('.img_thumbnail').attr('href','/'+data.image_url)
			$('.img_thumbnail img').attr('src','/'+data.image_url)
			$('#bid_price').attr('value',data.price)
			$('#bid_product_id').attr('value',data.id)
			$('#product_data #description').html(data.description.substring(0,500)+"...")
			$('#NoProductSelected').addClass("hide")
			$('.form_container ').removeClass("hide")	
			$.fancybox.close()		
}

function put_place_in_input(e){
	e.preventDefault();
	place=$(this).attr("data-id")
	$("#bid_place").val(place)
}
