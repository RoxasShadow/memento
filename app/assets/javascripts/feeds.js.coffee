$(document).ready ->
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
        category    = el.find('category').text()
        pubDate     = el.find('pubDate').text()

        $('#feeds').append "<b>Title:</b> " + title + "<br><b>Author:</b> " + author + "<br><b>Description:</b> " + description + "<br><b>Link:</b> " + link + "<br><b>Thumb image:</b> " + thumbimage + "<br><b>Full image:</b> " + fullimage + "<br><b>Category:</b> " + category + "<br><b>Publication date:</b> " + pubDate + "<hr>"