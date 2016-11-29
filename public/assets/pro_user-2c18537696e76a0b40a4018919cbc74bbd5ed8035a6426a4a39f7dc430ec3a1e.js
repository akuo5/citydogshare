(function($){
  $(document).on('ready page:load', function(){
    
    $("#pro-cal-button").hide(0);
    
    window.alert("Hi");
    
    $("#pro-toggle").click(function () {
      
    tog_url = "/users/" + userId + "/toggle";
    check = $("#pro-toggle").is(":checked");
    
    if(check) {
        alert("Checkbox is checked.");
        //use ajax to change to pro user. show the button for my calendar 
        $("#pro-cal-button").show();
        
        $.ajax({
          type: "POST",
          url: tog_url,
          data: true,
          dataType: "boolean",
          success: function (msg) {
            alert('Success');
            if (msg != 'success') {
                alert('Fail');
            }
          });
        
    } else {
        alert("Checkbox is unchecked.");
        //use ajax to change pro to non user. make button disappear
        $("#pro-cal-button").hide(0);
        $.ajax({
          type: "POST",
          url: tog_url,
          data: false,
          dataType: "boolean",
          success: function (msg) {
            alert('Success');
            if (msg != 'success') {
                alert('Fail');
            }
          }
        
    });
    
    // $("#pro-toggle").attr({
    //     "href" : "http://www.w3schools.com/jquery",
    //     "title" : "W3Schools jQuery Tutorial"
    // });
  
  });   



  });
 
})(jQuery); // end of jQuery name space
;
