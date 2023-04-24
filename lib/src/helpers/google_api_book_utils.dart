String authorListToString(List<String> authors) {
  String authorsString = '';
  if (authors.isNotEmpty)
    for (var i = 0; i < authors.length; i++) {
      if (i == authors.length - 1)
        authorsString += authors[i];
      else
        authorsString += authors[i] + ', ';
    }

  return authorsString;
}
