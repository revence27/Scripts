pieceName = (nom, nom1, chap, chap1, ver1, nom2, chap2, ver2) ->
  them1 = ver1.split(' ')
  them2 = ver2.split(' ')
  ver1  = them1[0]
  ver2  = them2[them2.length - 1]
  if (nom != '' and nom != nom1) or (chap != chap1)
    unless ver1 == '1' and chap1 == '1'
      nom1  = nom
      chap1 = chap unless ver1 == '1'
  ans = "#{nom1} #{chap1}:#{ver1}#{(if nom1 == nom2 then (if chap1 == chap2 then (if ver1 == ver2 then '' else '-' + ver2) else '-' + chap2 + ':' + ver2) else ('-' + nom2 + ' ' + chap2 + ':' + ver2))}"
  ans

messWithIt = (x) ->
  english(parseInt(x))

english = (x) ->
  if x < 21
    return [
      'zero'
      'one'
      'two'
      'three'
      'four'
      'five'
      'six'
      'seven'
      'eight'
      'nine'
      'ten'
      'eleven'
      'twelve'
      'thirteen'
      'fourteen'
      'fifteen'
      'sixteen'
      'seventeen'
      'eighteen'
      'nineteen'
      'twenty'
    ][x]
  if x < 100
    return [
      'oh'
      'ten-and'
      'twenty'
      'thirty'
      'forty'
      'fifty'
      'sixty'
      'seventy'
      'eighty'
      'ninety'
      'hundred-and'
    ][Math.floor(x / 10)] + (if (x % 10) < 1 then '' else '-' + english(x % 10))
  # No chapters above 15x.
  if x < 1000
    return english(Math.floor(x / 100)) + '-hundred and ' + english(x % 100)

Prince.addScriptFunc 'pieceName', pieceName
Prince.addScriptFunc 'messWithIt', messWithIt
