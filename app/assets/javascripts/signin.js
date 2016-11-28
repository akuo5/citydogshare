(function($){
  $(function(){
    
    $('#signup-form').hide(0); 
       
       
    $("#sign-up-btn").click(function(){
        $("#signup-form").show();
    });
        
           
    $("#close-link").click(function(){
        $("#signup-form").hide();
    });
    
    
    
    $("#pro-toggle").click(function(){
      //check if it is currently checked or unchecked. 
        $("#signup-form").show();
    });

  });
 
})(jQuery); // end of jQuery name space