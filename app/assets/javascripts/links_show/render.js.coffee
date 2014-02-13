$(document).ready ->

  template = '
  <div class="panel panel-default">
  	<div class="panel-heading">{{&title}} ({{&author}}{{&category}}{{&pubDate}})</div>
  	<div class="panel-body">{{&thumbimage}}{{&description}}</div>
  </div>'

  $.getJSON document.URL + '.json', (data) ->
  	return unless data.feeds

  	$.get '/feeds/' + btoa(data.feeds), (feeds) ->
  		$(feeds).find('item').each ->
  			el = $(this)

  			title       = el.find('title').text()
  			author      = el.find('author').text()
  			author      = el.find('dc\\:creator').text() unless author
  			description = el.find('description').text()
  			link        = el.find('link').text()
  			thumbimage  = el.find('thumbimage').attr('url')
  			fullimage   = el.find('fullimage').attr('url')
  			category    = el.find('category').categorize()
  			pubDate     = el.find('pubDate').text().toDate()

  			res = {
  				title:       ->
  					url = if link then link else '#'
  					"<a href=\"#{url}\" target=\"_blank\"><strong>#{title}</strong></a>"
  				author:      -> if author      then "by <em>#{author  }</em> "
  				category:    -> if category    then "in <em>#{category}</em> "
  				pubDate:     -> if pubDate     then "on <em>#{pubDate }</em>"
  				description: -> if description then description
  				thumbimage:  ->
  					if thumbimage
  						url = if fullimage then fullimage else '#'
  						"<a href=\"#{url}\" target=\"_blank\"><img src=\"#{thumbimage}\" class=\"feedThumb\"></a>"
  			}

  			$('#feeds').append Mustache.render(template, res)