// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.remotipart


function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(link).parent().before(content.replace(regexp, new_id));
    $($(link).parent().prev().find(".datepicker")).kendoDatePicker({
        min: new Date(),
        format: "dd/MM/yyyy"
        });
     $(".datepicker").bind("focus", function() {
      $(this).data("kendoDatePicker").open();
    });
    $('.datepicker').attr('readonly', true);
    return false;
}

function add_auditees(link, association) {
    var content = $(".team-auditee").html()
    var new_id = new Date().getTime();
    var regexp = new RegExp("[0]", "g");
    var regexp_new = new RegExp('selected="selected"', "g");
    $(link).parent().parent().find("#auditee-list").append("<div class='team-auditee'>"+content.replace(regexp, new_id).replace(regexp_new , "")+"</div>");
    return false;
}

function remove_fields(link) {
    jQuery(link).parent().find("input[type=hidden]").val(1);
    jQuery(link).parents(".fields").hide();
}

function remove_options(link) {
    jQuery(link).parent().find("input[type=hidden]").val(1);
    jQuery(link).parents(".choices").hide();
}

function setCookie(name, value) {
    var d = new Date();
    d.setTime(d.getTime() + (1*24*60*60*1000));
    var expires = "expires="+d.toGMTString();
    document.cookie = name + "=" + value + "; " + expires;
}

 $(window).load(function(){
	var $container = $('#grid_items');
	// initialize
	$container.masonry({
	  columnWidth: 292,
	  itemSelector: '.item',
	  isFitWidth: true
	});


	$(".block_banner img").each(function(index, element) {
        var screenImage = $(this);

		// Create new offscreen image to test
		var theImage = new Image();
		theImage.src = screenImage.attr("src");

		var imageHeight = theImage.height;

		$(this).css("max-height",imageHeight);
		$(this).css("min-height",imageHeight);
    });
});

$(".click_icon").click(function() {
			$(".share_pop").show();
});

$(".click_icon").click(function(){
		$(".share_pop").show();
});

$(document).ready(function(){

	Top_postion = $(window).scrollTop();

	$( ".user_login" ).mouseenter(function() {
		$(this).addClass("active");
		$(".account_header_dropdown").slideDown(100);
	})
	.mouseleave(function() {
		$(this).removeClass("active");
		$(".account_header_dropdown").hide();
	});

	//for notification drop hide in outside click
	onclick_icon = 0;
	$(".click_icon").mouseenter(function() {
		onclick_icon = 0;
	})
	.mouseleave(function() {
		onclick_icon = 1;
	});


	$("body").click(function(){
		if(onclick_icon){
			$(".share_pop").hide();
		}
	});


	/* placeholder */
	$(".place_holder").each(function(index, element) {
		placeholder = $(this).attr("data-original");
		$(this).val(placeholder);
		$(this).removeClass("active");
    });

	$(".place_holder").focus(function(){
		placeholder = $(this).attr("data-original");
		current_value = $(this).val();
		if(current_value==placeholder){
			$(this).val("");
			$(this).addClass("active");
		}
	});
	$(".place_holder").blur(function(){
		placeholder = $(this).attr("data-original");
		current_value = $(this).val();
		if(current_value==""){
			$(this).val(placeholder);
			$(this).removeClass("active");
		}else{
			$(this).addClass("active");
		}
	});
	$(".place_holder").click(function(){
		placeholder = $(this).attr("data-original");
		current_value = $(this).val();
		if(current_value==placeholder){
			$(this).val("");
			$(this).addClass("active");
		}
	});
	/* placeholder */

    $(".next-phase").click(function(){
      // new Messi('Planned for further phases.', {autoclose: '5000'});
      new Messi('Planned for further phases.', {title: 'Warning', titleClass: 'warning', autoclose: 2000});
    });

});

// More contacts show
$(".more-link").click(function(){
  if($(this).html() == "More")
    $(this).html("Less").parent().siblings(".more-info").show();
  else
    $(this).html("More").parent().siblings(".more-info").hide();
});

function goBack() {
    window.history.go(-1)
}