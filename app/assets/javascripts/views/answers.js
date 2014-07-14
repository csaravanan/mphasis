/* validation for auditee_response*/
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


});
/*$(window).scroll(function(){
  Top_postion = $(window).scrollTop();

  if(Top_postion>10){
    $(".go_to_top").show();
  }else{
    $(".go_to_top").hide();
  }
});
$(".go_to_top").click(function(){
  top = 0;
  $("html, body").animate({scrollTop: "0"}, 800);
});
*/

function display_selected_files(e)
{
$(e).parent().find("#selected_files").html("<h5>selected: " + $(e).val() + "</h5>");
}

$(function() {
  $( "#Accordion1" ).accordion();
});
