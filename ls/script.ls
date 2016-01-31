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
