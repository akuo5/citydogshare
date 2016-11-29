(function($){
  $(function(){
    
    $(".button-collapse").sideNav({
      draggable: true
    });
    $("#show-menu-btn").sideNav({
      draggable: false
    });
    $("#hide-menu-btn").click(function() {
      $("#show-menu-btn").sideNav("hide");
    });
    $(".filters-button-collapse").sideNav({
      draggable: true
    });
    $('.tooltipped').tooltip({delay: 50});
    
    $('.parallax').parallax();
    
    $('select').material_select();
    
    $("#filters-slide-out").css("height", $(window).height() - 56 + "px");
    $( window ).resize(function(){
      $("#filters-slide-out").css("height", $(window).height() - 56 + "px");
    });
    
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
    
    $('.datepicker').pickadate({
      selectMonths: true, // Creates a dropdown to control month
      selectYears: 15 // Creates a dropdown of 15 years to control year
    });
    
    $(document).scroll(function(){
      if ($(document).width() > 600) {
        $('#calendar').css('margin-top', $(document).scrollTop());
      } else {
        $('#calendar').css('margin-top', 0);
      }
    });
    
    // Uses Ajax to either star or unstar a given dog
    $('.star_dog_link').removeAttr("data-method");
    $(document).on('click', '.star_dog_link', function(event) {
      event.preventDefault();
      event.stopPropagation();
      var starred = $(this).children().first().hasClass("fa-star");
      var href = $(this).attr("href");
      if (starred) {
        $.ajax({ 
          url: href, 
          method: "DELETE",
          error: function (error) {
            // If error occurs, add and sumbit a form that carries out regular link action
            $("html").append('<form id="immediate-click" action="'+$(this).attr("href")+'" method="delete"></form>');
            $("#immediate-click").submit();
          }
        });
        $(this).children().first().removeClass("fa-star");
        $(this).children().first().addClass("fa-star-o");
      } else {
        $.ajax({ 
          url: href, 
          method: "POST",
          error: function (data) {
            // If error occurs, add and sumbit a form that carries out regular link action
            $("html").append('<form id="immediate-click" action="'+$(this).attr("href")+'" method="post"></form>');
            $("#immediate-click").submit();
          }
        });
        $(this).children().first().addClass("fa-star");
        $(this).children().first().removeClass("fa-star-o");
      }
    });

  }); // end of document ready
})(jQuery); // end of jQuery name space
;
