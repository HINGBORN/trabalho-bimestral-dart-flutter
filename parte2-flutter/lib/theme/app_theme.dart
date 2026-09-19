import 'package:flutter/material.dart';

/// ARQUIVO DE APOIO — não implementa nenhum dos 10 exercícios.
/// Concentra cores, estilos e formatação para que as telas fiquem
/// legíveis e o código dos exercícios não se misture com decoração.

class AppColors {
  static const ink = Color(0xFF111821); // fundo escuro / texto forte
  static const steel = Color(0xFF1A2330); // superfície escura
  static const paper = Color(0xFFF1F0EC); // fundo claro
  static const oxide = Color(0xFFB8442B); // acento (preço, performance)
  static const hazard = Color(0xFFD99A2B); // alerta de estoque baixo
  static const mist = Color(0xFF8B96A6); // texto secundário (escuro)
  static const slate = Color(0xFF5F6874); // texto secundário (claro)
}

class AppTheme {
  const AppTheme._();

  static const double radius = 14;
  static const double radiusLg = 18;

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.oxide,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.oxide,
      onPrimary: Colors.white,
      surface: isDark ? AppColors.steel : Colors.white,
      onSurface: isDark ? Colors.white : AppColors.ink,
      error: const Color(0xFFC0392B),
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
    );

    final muted = isDark ? AppColors.mist : AppColors.slate;
    final linha = isDark
        ? Colors.white.withValues(alpha: 0.09)
        : Colors.black.withValues(alpha: 0.09);

    return base.copyWith(
      scaffoldBackgroundColor: isDark ? AppColors.ink : AppColors.paper,
      textTheme: base.textTheme.apply(
        bodyColor: isDark ? Colors.white : AppColors.ink,
        displayColor: isDark ? Colors.white : AppColors.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.ink : AppColors.paper,
        foregroundColor: isDark ? Colors.white : AppColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: isDark ? Colors.white : AppColors.ink,
        ),
      ),
      dividerTheme: DividerThemeData(space: 1, thickness: 1, color: linha),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : const Color(0xFFF7F7F5),
        labelStyle: TextStyle(color: muted, fontSize: 14),
        floatingLabelStyle: const TextStyle(color: AppColors.oxide),
        prefixIconColor: muted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.oxide,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.white : AppColors.ink,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          side: BorderSide(color: linha),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.oxide,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.steel : AppColors.ink,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Atalhos de cor. Evita repetir `isDark ? ... : ...` em cada tela.
extension AppThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get cardSurface => isDark ? AppColors.steel : Colors.white;
  Color get hairline => isDark
      ? Colors.white.withValues(alpha: 0.09)
      : Colors.black.withValues(alpha: 0.09);
  Color get textMuted => isDark ? AppColors.mist : AppColors.slate;
  Color get textStrong => isDark ? Colors.white : AppColors.ink;
}

/// Formatação em padrão brasileiro, sem depender do pacote `intl`.
class Formato {
  const Formato._();

  /// 1234.5 -> "1.234,50"
  static String moeda(double valor) {
    final partes = valor.abs().toStringAsFixed(2).split('.');
    final buffer = StringBuffer();
    for (var i = 0; i < partes[0].length; i++) {
      if (i > 0 && (partes[0].length - i) % 3 == 0) buffer.write('.');
      buffer.write(partes[0][i]);
    }
    return '${valor < 0 ? '-' : ''}$buffer,${partes[1]}';
  }

  /// 1234.5 -> "R$ 1.234,50"
  static String real(double valor) => 'R\$ ${moeda(valor)}';

  /// DateTime -> "05/03/2026"
  static String data(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}