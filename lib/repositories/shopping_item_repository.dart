import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project_2023/repositories/shopping_item_model.dart';
import 'package:flutter_project_2023/repositories/shopping_list_model.dart';
import 'package:flutter_project_2023/shared/enums.dart';
import 'package:uuid/uuid.dart';
import '../shared/constants.dart';
import 'group_model.dart';

class ShoppingItemRepository {
  final uuid = Uuid();
  final currentUser = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  }
}
