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