import 'package:flutter_project_2023/shared/enums.dart';

class ShoppingItem {
  final String uuid;
  final String creatorId;

  final String name;

  final String? description;

  final double? quantity;

  final Unit unit;

  ShoppingItemState state = ShoppingItemState.NotBought;

  ShoppingItem(
      {required this.uuid,
      required this.creatorId,
      required this.name,
      this.description,
      required this.quantity,
      required this.unit,
      required this.state});

  Map<String, dynamic> toFirestore() {
    return {
      "uuid": uuid,
      "creatorId": creatorId,
      "name": name,
      "description": description,
      "quantity": quantity,
      "unit": unit.toString(),
      "state": state.toString()
    };
  }

  ShoppingItem copy() {
    return ShoppingItem(
        uuid: uuid,
        creatorId: creatorId,
        name: name,
        description: description,
        quantity: quantity,
        unit: unit,
        state: state);
  }
}
