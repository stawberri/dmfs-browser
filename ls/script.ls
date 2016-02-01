window.Buffer = buffer.Buffer

body-element = $ \body

$ \#text-to-file .click ->
  it.prevent-default!
  try
    json-object = $.parseJSON <| $ \#compressed-text .val!
  catch
    return

  unless json-object.ct?
    return

  filename = json-object.fn

  content = json-object.ct
  content |>= Base65536.decode

  if $ \#use-base64 .is \:checked
    content .= to-string!
    content |>= -> new Buffer it, \base64

  content |>= -> new Uint8Array it

  blob = new Blob do
    [content]
    type: \application/octet-stream

  object-url = URL.create-object-URL blob

  console.log object-url

  $ \<a>
    ..attr do
      href: object-url
      download: filename
    ..0.click!

$ \#file-to-text .click ->
  it.prevent-default!

  file = $ \#file-picker .0.files.0
  return unless file?

  file-reader = new FileReader!
  file-reader.add-event-listener \loadend ->
    data = new Buffer new Uint8Array file-reader.result

    if $ \#use-base64 .is \:checked
      data .= to-string \base64
      data |>= -> new Buffer it

    data |>= Base65536.encode

    output =
      fn: file.name
      pt: 0
      ct: data

    output |>= JSON.stringify
    $ \#compressed-text .val output
  file-reader.read-as-array-buffer file
