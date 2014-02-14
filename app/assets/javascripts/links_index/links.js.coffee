$(document).ready ->
	renderize()

	$('#feedList').sortable {
		placeholder: 'ui-state-highlight'
		start:  (event, ui) ->
			$(this).attr('data-previndex', ui.item.index())
		update: (event, ui) ->
      newIndex = ui.item.index()
      oldIndex = $(this).attr('data-previndex')
      $(this).removeAttr('data-previndex')

      $.ajax '/links/swap_priority',
      	type:        'POST'
      	dataType:    'json'
      	contentType: 'application/json'
      	data:         JSON.stringify {
      		new_id: newIndex
      		old_id: oldIndex
      	}
      .success ->
      	$('#feeds').html('')
      	renderize()
	}

	$('#feedList').disableSelection()

	$('#feeds').on 'click', '.feed', ->
		currentFeed = $(this)
		title    = currentFeed.find('.panel-heading').html()
		contents = currentFeed.find('.panel-body').html()

		feedInfo = $('#feedInfo')
		feedInfo.find('h4').html          title
		feedInfo.find('.modal-body').html contents
		feedInfo.modal()

	$('#feeds').on 'click', 'a.collapse-btn', ->
    $(this).toggleClass 'glyphicon-chevron-down glyphicon-chevron-up'