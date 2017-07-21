$(document).on('change', '[data-preffered-time=date]', function() {
  $('[data-date=field]').val($(this).val())
})
