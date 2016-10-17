(function($){
  $(function(){
    $(".button-collapse").sideNav();
    $("#show-menu-btn").sideNav();
    $("#hide-menu-btn").click(function() {
      $("#show-menu-btn").sideNav("hide");
    });
    $('.tooltipped').tooltip({delay: 50});
    
    $('.parallax').parallax();
    
    $('select').material_select();
    
    /* Adds functionality to the flash notice */
    var keepNotice = false;
    $(".application-notice-close").click(function() {
      $(".application-notice").fadeOut();
    });
    $(".application-notice").hover(function() {
      keepNotice = true;
    });
    setTimeout(function() {
      if (!keepNotice) $(".application-notice").fadeOut();
    }, 3000);

  }); // end of document ready
})(jQuery); // end of jQuery name space