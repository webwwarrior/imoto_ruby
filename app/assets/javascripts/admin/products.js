//= require select2

$(document).ready(function(){
  $('[data-taggable=attribute]').select2({
    tags: true,
    tokenSeparators: [',']
  });
});

$(document).on('click', '[data-modal=open]', function() {
  $('[data-modal=window]').show();
})

$(document).on('click', '[data-modal=close]', function(){
  $('[data-modal=window]').hide();
})

$(document).on('click', '[data-type=add_kind]', function() {
  var kind = $('[data-products-type=kind]').val();
  var duplicated = $('[data-products-attribute-type=' + kind + ']').children($('[data-products-attribute-type=clone]')).clone();
  var object = duplicated.appendTo($('[data-type=attributes]'));

  $('[data-attribute=status]').attr('disabled', false);

  object.find($('[data-taggable=tags]')).select2({
    tags: true,
    tokenSeparators: [',']
  });
});

$(document).on('click', '[data-type=closed]', function(){
  $(this).closest($('[data-products-attribute-type=clone]')).remove();
  if ($('[data-type=attributes]').is(':empty')) {
    $('[data-attribute=status]').val('disabled').attr('disabled', true);
  }
});

$(document).on('click', '[data-type=add_options]', function(){
  var duplicated = $('[data-type=options]').children($('[products-attribute-type=clone]')).clone();
  duplicated.show().appendTo($(this).parent($('[data-options-single-select=clone]')));
});
