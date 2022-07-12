class Offer {
  Offer({required this.id, required this.name, required this.price, required this.category});
  final String id;
  final String name;
  final int price;
  final String category;

  // Mapa de Oferta para almacenar con sqlite. colmunas deben ser nombres
  // en base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category
    };
  }

  // ToString para facilitar lectura en consola de los datos.
  @override
  String toString() {
    return 'Offer{id: $id, name: $name, price: $price, category: $category}';
  }
}