$(document).ready ->
  $('.alert').alert()

  window.setTimeout ( ->
    $('.alert-success').alert('close')
  ), 2000