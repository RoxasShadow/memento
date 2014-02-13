$(document).ready ->
	renderize()

	oldOrder = []
	$('#feedList').sortable {
		placeholder: 'ui-state-highlight'
		start:  (event, ui) ->
			oldOrder = $(this).sortable('toArray')
		update: (event, ui) ->
			newOrder = $(this).sortable('toArray')
			$.ajax '/links/swap_priority',
				type:        'POST'
				dataType:    'json'
				contentType: 'application/json'
				data:         JSON.stringify {
					new_id:     ui.item[0].id.split('link-')[1]
					old_id:     newOrder[oldOrder.indexOf(ui.item[0].id)].split('link-')[1]
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