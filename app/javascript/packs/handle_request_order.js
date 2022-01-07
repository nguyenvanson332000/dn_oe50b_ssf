$(document).ready(function() {
  $('.handle-request-order').click(function() {
    $.ajax({
      type: 'PATCH',
      url: "/admin/orders/"+$(this).data().id,
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        id: $(this).data().id,
        stt: $(this).data().stt
      },
      dataType: 'JSON'
    }).done(function (data) {
      alert(data.notice);
      window.location.reload();
    });
  });
})
