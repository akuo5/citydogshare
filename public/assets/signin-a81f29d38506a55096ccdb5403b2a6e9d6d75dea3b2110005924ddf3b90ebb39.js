(function($){
  $(function(){
    
    $('#signup-form').hide(0); 
       
       
    $("#sign-up-btn").click(function(){
        $("#signup-form").show();
    });
        
           
    $("#close-link").click(function(){
        $("#signup-form").hide();
    });

  }); // end of document ready
 
 
})(jQuery); // end of jQuery name space
;
