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

  }); // end of document ready
})(jQuery); // end of jQuery name space