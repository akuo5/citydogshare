(function($){
  $(function(){
    
    $('#signup-form').hide(0); 
    $('#signup-notice').hide(0); 
       
       
    $("#sign-up-btn").click(function(){
        $("#signup-form").show();
    });
        
           
    $("#close-link").click(function(){
        $("#signup-form").hide();
    });

    $("#close-link-2").click(function(){
        $("#signup-form").hide();
        $("#signup-notice").hide();
    });

    //For the sign up notice
      $("#fb-signup-hold").click(function(){
        $("#signup-form").hide();
        $("#signup-notice").show();
        
    });
    
    
    $("#back-link").click(function(){
        $("#signup-form").show();
        $("#signup-notice").hide();
        
    });

  }); // end of document ready
 
 
})(jQuery); // end of jQuery name space
;
