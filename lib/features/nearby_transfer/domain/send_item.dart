/// A PDF the user chose to send to a nearby phone.
///
/// Either [cachePath] (a PDF already open in the viewer) or [uri] (a recent
/// file, copied to the cache when sending starts) is set.
class SendItem {
  const SendItem({required this.name, this.uri, this.cachePath})
    : assert(uri != null || cachePath != null);

  final String name;
  final String? uri;
  final String? cachePath;
}

/// The folder received PDFs are saved into.
class ReceiveFolder {
  const ReceiveFolder({required this.uri, required this.name});

  /// The folder's tree URI (the app keeps lasting access to it).
  final String uri;

  /// The folder's name, as the system shows it.
  final String name;
}
