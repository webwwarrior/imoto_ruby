/* global $ */

$(document).on('click', '[data-check-box=true]', function () {
  $(this).closest('tr').find($('[data=field]')).attr('disabled', !$(this).prop('checked'))
})

$(document).ready(function () {
  $('[data-placeholder=time_zone]').select2({
    width: 'auto',
    allowClear: true
  })

  $('[data-taggable=zip_codes]').select2({
    width: 'auto',
    tokenSeparators: [','],
    ajax: {
      url: $('[data-taggable=zip_codes]').data('select2-remote'),
      dataType: 'json',
      delay: 250,
      data: function (query) {
        return { query: query.term }
      },
      processResults: function (data, params) {
        return { results: data }
      },
      cache: true
    }
  })
})
