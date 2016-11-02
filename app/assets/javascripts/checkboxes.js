$(document).ready(function(){

  $.each($(':checked'), function( index, value ) {
    $(value).parent().addClass('black inverted active');
  });

  $('.ui.button').on('click', function(){
      if($(this).children().hasClass("check")){
        $(this).toggleClass('black inverted active');
        var $this_checkbox = $(this).children();
        if ($this_checkbox.is(':checked')){
          $this_checkbox.prop('checked', false);
        } else {
          $this_checkbox.prop('checked', true);
        }
    }
  });

  $('.check').not( "#dog_search_submit" ).on('click', function(){
    $(this).parent().toggleClass('black inverted active');
  });

});