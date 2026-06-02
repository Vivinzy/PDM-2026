class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return "Email obrigatório";
    if (!value.contains("@")) return "Email inválido";
    return null;
  }

  static String? senha(String? value) {
    if (value == null || value.isEmpty) return "Senha obrigatória";
    if (value.length < 6) return "Mínimo 6 caracteres";
    return null;
  }
}