(function() {
  var updateEvent;

  $(document).ready(function() {
    return $('#calendar').fullCalendar({
      editable: true,
      header: {
        right: 'prev,next',
        left: 'title'
      },
      defaultView: 'month',
      events: "/events/fc_info",
      height: 550,
      eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
        return updateEvent(event);
      },
      eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
        return updateEvent(event);
      }
    });
  });

  updateEvent = function(updated_event) {
    return $.ajax({
      type: 'PUT',
      dataType: 'script',
      url: '/events/' + updated_event.id,
      contentType: 'application/json',
      data: JSON.stringify({
        event: {
          start_date: updated_event.start,
          end_date: updated_event.end
        },
        fc_update: 'true',
        _method: 'put'
      }),
      success: function(result) {
        return $('.tab').html(result);
      }
    });
  };

}).call(this);
