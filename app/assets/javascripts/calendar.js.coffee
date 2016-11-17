$(document).ready ->
  $('#calendar').fullCalendar
    editable: true,
    header:
      right: 'prev,next',
      left: 'title'
    defaultView: 'month',
    events: "/events/fc_info",
    height: 550
    
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      updateEvent(event);

    eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
      updateEvent(event);

updateEvent = (updated_event) ->
  $.ajax({
    type: 'PUT',
    dataType: 'script',
    url: '/events/' + updated_event.id,
    contentType: 'application/json',
    data: JSON.stringify({
      event: { start_date: updated_event.start, end_date: updated_event.end },
      fc_update:'true',
      _method:'put'
    });
    success: (result) ->
      $('.tab').html(result);
  });
