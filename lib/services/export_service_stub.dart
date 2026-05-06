void downloadHtml(String content, String filename) {
  throw UnsupportedError('Download is only supported on the web platform.');
}

void downloadPdf(List<int> bytes, String filename) {
  throw UnsupportedError('PDF export is only supported on the web platform.');
}
