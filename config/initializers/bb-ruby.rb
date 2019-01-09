module BBRuby
  if @@tags
    @@tags['h2'] = [
      /\[h3\](.*?)\[\/h3\1?\]/mi,
      '<h3>\1</h3>',
      'h3',
      '[h3]h3[/h3]',
      :h3]
  end
end
