###
By Josiah Ulfers, 2012. Public domain or closest thing to it.
###
formatTime = (millis) ->
  s = parseInt(millis / 1000)
  m = parseInt(s / 60)
  s = "00#{s % 60}"[-2..]
  return "#{m}:#{s}"

watch = (textarea) ->
  start = null
  last = null
  timeout = null
  original = textarea.value.replace(/\|/g, 'e')
  errcalc = null
  startBars = textarea.value.match(/\|/gm).length
  countstart = 4
  countdown = (tick) ->
    results = $(textarea).siblings('.results')
    results.find('.pipes').text(startBars)
    if tick < countstart
      $(textarea).siblings('.status').find('.countdown').text(tick)
      errcalc ?= levenshtein textarea.value, original, (distance) ->
        results.find('.errors').text(distance)
    if not tick
      results.find('.time').text(formatTime(last - start))
      results.animate({'left': 0})
      textarea.disabled = 'disabled'
      clearInterval(watcher)
    else
      timeout = setTimeout((-> countdown(tick - 1)), 500)
  watcher = setInterval( ->
    bars = textarea.value.match(/\|/gm)?.length or 0
    status = $(textarea).siblings('.status')
    status.find('.progress').text(bars)
    status.find('.progress-bar').children()
      .css({'width': parseInt((1 - bars / startBars) * 100) + '%'})
    if not bars and not timeout
      countdown(countstart)
  , 100)
  $(textarea).on 'keydown', ->
    start ?= Date.now()
    last = Date.now()
    clearTimeout(timeout)
    timeout = null
    errcalc?.cancel()
    errcalc = null
    $(textarea).siblings('.status').find('.countdown').text('')

levenshtein = (a, b, callback) ->
  # Wagner-Fischer algorithm for Levenshtein distance
  d = [[0..b.length]]
  last = Date.now()
  cancel = false
  fill = (i) ->
    if cancel
      return
    if i > a.length
      callback(d[a.length][b.length])
      return
    d[i] = [i]
    for j in [1...b.length + 1]
      d[i][j] = Math.min(
        d[i - 1][j] + 1,
        d[i][j - 1] + 1,
        d[i - 1][j - 1] + (if a[i - 1] == b[j - 1] then 0 else 1)
      )
    if Date.now() > last + 200
      #fill(i + 1)
      setTimeout((-> fill(i + 1)), 0)
    else
      fill(i + 1)
  setTimeout((-> fill(1)), 0)
  return {cancel: -> cancel = true}

selectBar = (textarea) ->
  firstbar = textarea.val().indexOf('|')
  if textarea[0].setSelectionRange
    textarea[0].setSelectionRange(firstbar, firstbar + 1)
  else
    range = textarea[0].createTextRange()
    range.collapse(true)
    range.moveStart('character', firstbar)
    range.moveEnd('character', 1)
    range.select()
  return textarea.focus()

setup = (text, wrapper) ->
  wrapper.find('.test').animate({'opacity': 1})
  textarea = wrapper.find('textarea')
  textarea[0].value = text
  selectBar(textarea) # Not visible in IE while textarea disabled
  return textarea

setFontFamily = ->
  $('.test textarea').css('font-family', $('form input[name="family"]:checked').val())

$ ->
  $('form input').attr('disabled', null) # Firefox maintains form attribute disabled after refresh
  setFontFamily()
  $.getJSON 'https://baconipsum.com/api/?callback=?', 
    {'type': 'meat-and-filler', 'start-with-lorem': '1', 'paras': '2'},
    (bacon) ->
      source = bacon.join('\n\n').replace(/e/g, '|')
      setup(source, $('.keyboard'))
      setup(source, $('.mouse'))
        .on 'keydown', (e) ->
          if 36 < e.which < 41 or e.which == 8 or e.which == 46
            e.preventDefault()
  $('form input[name="family"]').on 'change', setFontFamily
  $('button.start').on 'click', ->
    $('form').addClass('disabled').find('input').attr('disabled', 'disabled')
    duration = 750
    textarea = $(this).siblings('textarea')
    textarea.attr('disabled', null) # In IE, must be enabled for selection to show
    selectBar(textarea)
      .animate(
        { 'font-size': $('form input[name="size"]:checked').val(), 'width': '80%'},
        duration, 'swing', ->
          $(this).css({'overflow': 'auto'})
      )
      .siblings('.status').animate({
        'left': '80%'}, duration, 'swing')
    watch(textarea[0])
    $(this).remove()
