$( document ).ready(function(){
    $('.slider').slider({
        full_width: true, 
        indicators: true,
    })
    $('.slider').slider('pause');
    $('.indicator-item').on('click',function(){
        $('.slider').slider('pause');
    });
    
});

(function($){
  $(function(){
    
    $('#delete_dog_form').hide(0); 
    $('.gray-overlay').hide(0); 
       
    $("#cancel_dog_button").click(function(){
        $("#delete_dog_form").show();
        $(".gray-overlay").show();
    });
        
           
    $("#close-link").click(function(){
        $("#delete_dog_form").hide();
        $('.gray-overlay').hide(0);
    });

  }); // end of document ready

 
 
})(jQuery); // end of jQuery name space
;
