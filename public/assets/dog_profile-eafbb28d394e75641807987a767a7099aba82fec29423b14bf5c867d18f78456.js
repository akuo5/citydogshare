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
    
    $(".delete_picture_button").click(function(){
        var pic_id = this.id;
        var url = "/pictures/" + pic_id;
        
        $.ajax({
            url: url,
            type: "DELETE",
            data: { dog_id: this.name },
            success:function(result){
                alert("hello");
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.log("request failed" +textStatus);
            }       
        });
    });

  }); // end of document ready

 
 
})(jQuery); // end of jQuery name space
;
