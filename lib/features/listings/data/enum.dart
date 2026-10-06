enum BusinessType {
  farmer,
  manufacturer,
  wholesaler,
  retailer,
  artisan,
  trader,
  serviceProvider,
}

extension BusinessTypeExtension on BusinessType {
  String get label {
    switch (this) {
      case BusinessType.farmer:
        return 'Farmer';
      case BusinessType.manufacturer:
        return 'Manufacturer';
      case BusinessType.wholesaler:
        return 'Wholesaler';
      case BusinessType.retailer:
        return 'Retailer';
      case BusinessType.artisan:
        return 'Artisan / Handicraft';
      case BusinessType.trader:
        return 'Trader';
      case BusinessType.serviceProvider:
        return 'Service Provider';
    }
  }
}

enum ProductUnit {
  kg,
  quintal,
  ton,
  piece,
  litre,
  dozen,
  packet,
  box,
}

extension ProductUnitExtension on ProductUnit {
  String get label {
    switch (this) {
      case ProductUnit.kg:
        return 'Kg';
      case ProductUnit.quintal:
        return 'Quintal';
      case ProductUnit.ton:
        return 'Ton';
      case ProductUnit.piece:
        return 'Piece';
      case ProductUnit.litre:
        return 'Litre';
      case ProductUnit.dozen:
        return 'Dozen';
      case ProductUnit.packet:
        return 'Packet';
      case ProductUnit.box:
        return 'Box';
    }
  }
}