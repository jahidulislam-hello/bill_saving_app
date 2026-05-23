/// Application string constants for internationalization and maintainability.
///
/// This class centralizes all user-facing strings in the application, making it
/// easier to:
/// - Update text across the app from a single location
/// - Prepare for internationalization (i18n)
/// - Maintain consistent messaging
/// - Search and replace text efficiently
///
/// **Best Practices:**
/// - Use descriptive constant names that indicate context
/// - Group related strings together with comments
/// - Keep strings in alphabetical order within groups
/// - Use const for compile-time constants
///
/// **Usage:**
/// ```dart
/// Text(AppStrings.searchHint)  // Instead of: Text('Search food or restaurant here...')
/// ```
///
/// **Future i18n Support:**
/// When adding internationalization, this class can be replaced with:
/// ```dart
/// AppLocalizations.of(context).searchHint
/// ```
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // Search
  static const String searchHint = 'Cerca qui...';

  // Section headers
  static const String categories = 'Categorie';
  static const String popularFoodNearby = 'Popolari nelle vicinanze';
  static const String foodCampaign = 'Campagna';
  static const String restaurants = 'Ristoranti';
  static const String viewAll = 'Vedi tutto';

  // Error messages
  static const String noInternetConnection = 'Nessuna connessione Internet';
  static const String noInternetMessage =
      'Nessuna connessione Internet. Riprova.';
  static const String oops = 'Ops!';
  static const String retry = 'Riprova';
  static const String loadMoreFailed = 'Caricamento fallito';
  static const String requestTimeout = 'Richiesta scaduta. Riprova';
  static const String serverError = 'Errore del server';
  static const String unexpectedError = 'Si è verificato un errore imprevisto';
  static const String failedToLoadData = 'Impossibile caricare i dati';

  // Placeholders
  static const String unknownProduct = 'Prodotto sconosciuto';
  static const String unknownRestaurant = 'Ristorante sconosciuto';
  static const String unknownCategory = 'Categoria sconosciuta';

  // Address
  static const String defaultAddress = 'Via Roma, 1, Roma, IT';

  // Cache messages
  static const String cacheNotInitialized =
      'Servizio di cache non inizializzato. Chiama prima init().';
}

