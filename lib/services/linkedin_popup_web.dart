import 'dart:html' as html;

Future<bool> openLinkedInPopup(String url) async {
  final width = 560;
  final height = 720;
  final left = ((html.window.screen?.width ?? 1280) - width) ~/ 2;
  final top = ((html.window.screen?.height ?? 800) - height) ~/ 2;

  final features = [
    'width=$width',
    'height=$height',
    'left=$left',
    'top=$top',
    'resizable=yes',
    'scrollbars=yes',
  ].join(',');

  final popup = html.window.open(url, 'linkedin_oauth_popup', features);
  return popup != null;
}
