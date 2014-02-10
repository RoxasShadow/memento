jQuery::categorize = ->
  category = ''
  if this
    $.each this, (i, cat) ->
      category += "#{$(cat).text()}, "
    category = category.slice 0, -2
  category

String::toDate = ->
  pubDate = ''
  if this
    date   = new Date this
    months = [ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' ]

    ampm   = if date.getHours() >= 12 then 'PM' else 'AM'
    string = months[date.getMonth()] + ' ' + date.getDate()    + 'th, ' + date.getFullYear()
    time   = date.getHours()         + ':' + date.getMinutes() + ' '    + ampm

    pubDate = "#{string} at #{time}"
  pubDate

$(document).ready ->
  template = '
  <div class="panel panel-default">
    <div class="panel-heading">{{&title}} ({{&author}}{{&category}}{{&pubDate}})</div>
    <div class="panel-body">{{&thumbimage}}{{&description}}</div>
  </div>'

  $.getJSON document.URL + '.json', (data) ->
    return unless data.feeds

    $.get '/feeds/' + encodeURIComponent(data.feeds), (feeds) ->
      $('#feeds').append '<hr>'

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

        data = {
          'title'      : () ->
            if title
              url = if link then link else '#'
              "<a href=\"#{url}\"><strong>#{title}</strong></a>"
            else
              ''
          'author'     : () -> if author      then "by <em>#{author}</em> "                      else '',
          'category'   : () -> if category    then "in <em>#{category}</em> "                    else '',
          'pubDate'    : () -> if pubDate     then "on <em>#{pubDate}</em> "                     else '',
          'description': () -> if description then description                                   else '',
          'thumbimage' : () ->
            if thumbimage
              url = if fullimage then fullimage else '#'
              "<a href=\"#{url}\"><img src=\"#{thumbimage}\" class=\"feedThumb\"></a>"
            else
              ''
        }

        $('#feeds').append Mustache.render(template, data)