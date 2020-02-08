module BBRuby
  if @@tags
    @@tags['h2'] = [
      /\[h2\](.*?)\[\/h2\1?\]/mi,
      '<h2 class="bb">\1</h2>',
      'h2',
      '[h2]h2[/h2]',
      :h2]
  end
  if @@tags
    @@tags['h3'] = [
      /\[h3\](.*?)\[\/h3\1?\]/mi,
      '<h3 class="bb">\1</h3>',
      'h3',
      '[h3]h3[/h3]',
      :h3]
  end
  if @@tags
    @@tags['gallery'] = [
      /\[gallery\](.*?)\[\/gallery\1?\]/mi,
      '<div class="entryImgUploads">\1</div>',
      'gallery',
      '[gallery]gallery[/gallery]',
      :h3]
  end
  if @@tags
    @@tags['imgtxt'] = [
      /\[imgtxt\](.*?)\[\/imgtxt\1?\]/mi,
      '<div class="imgtxt">\1</div>',
      'imgtxt',
      '[imgtxt]imgtxt[/imgtxt]',
      :h3]
  end
  if @@tags
    @@tags['txt'] = [
      /\[txt\](.*?)\[\/txt\1?\]/mi,
      '<span>\1</span>',
      'txt',
      '[txt]txt[/txt]',
      :h3]
  end
end
