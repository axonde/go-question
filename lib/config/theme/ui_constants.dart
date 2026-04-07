class UiConstants {
  static const double leftPadding = 8;
  static const double rightPadding = 8;
  static const double bottomPadding = 8;
  static const double topPadding = 8;
  static const double middlePadding = 8;
  static const double horizontalPadding = 8;
  static const double verticalPadding = 8;

  static const double borderRadius = 2;
  static const double borderWidth = 2;

  static const double boxUnit = 8;
  static const double textSize = boxUnit * 2.0; // 16px — базовый размер текста

  static const double strokeWidth = 1;

  // Тень без blur — смещение только вниз (используется везде в приложении).
  static const double shadowOffsetY = 4;
  // Тень под текстом (stroke titles) — меньше чем у блоков.
  static const double textShadowOffsetY = 2;
}
