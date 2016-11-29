(function($){
  $(function(){
    
    $('#signup-form').hide(0); 
       
       
    $("#sign-up-btn").click(function(){
        $("#signup-form").show();
    });
        
           
    $("#close-link").click(function(){
        $("#signup-form").hide();
    });
    
  });
 
})(jQuery); // end of jQuery name space