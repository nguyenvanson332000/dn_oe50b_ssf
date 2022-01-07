$(document).ready(function() {
  $('.banner-account').click(function() {
    $.ajax({
      type: 'PATCH',
      url: "/admin/users/"+$(this).data().id,
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {
        id: $(this).data().id,
        type: $(this).data().type
      },
      dataType: 'JSON'
    }).done(function (data) {
      alert("xử lý thành công !");
      window.location.reload();
    });
  });
})
