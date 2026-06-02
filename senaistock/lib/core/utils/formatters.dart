class Formatters {
  static String moeda(double valor) {
    return "R\$ ${valor.toStringAsFixed(2)}";
  }
}