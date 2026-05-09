// lib/features/inventory/data/repositories/category_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/app_database.dart';

class CategoryRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  CategoryRepository(this._db);

  // ── Categories ─────────────────────────────────────────────────────────────

  Stream<List<Category>> watchShopCategories(int shopId) {
    return (_db.select(_db.categories)
          ..where((c) => c.shopId.equals(shopId))
          ..where((c) => c.isDeleted.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  Future<int> createCategory({
    required int shopId,
    required String name,
    String? description,
  }) async {
    final now = DateTime.now();
    return _db.into(_db.categories).insert(
          CategoriesCompanion.insert(
            uuid: _uuid.v4(),
            shopId: shopId,
            name: name,
            description: Value(description),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<bool> updateCategory({
    required int id,
    String? name,
    String? description,
  }) async {
    final now = DateTime.now();
    final result = await (_db.update(_db.categories)..where((c) => c.id.equals(id))).write(
          CategoriesCompanion(
            name: name != null ? Value(name) : const Value.absent(),
            description: description != null ? Value(description) : const Value.absent(),
            updatedAt: Value(now),
          ),
        );
    return result > 0;
  }

  Future<void> deleteCategory(int id) async {
    final now = DateTime.now();
    await (_db.update(_db.categories)..where((c) => c.id.equals(id))).write(
          CategoriesCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  // ── Sub-Categories ─────────────────────────────────────────────────────────

  Stream<List<SubCategory>> watchSubCategories(int categoryId) {
    return (_db.select(_db.subCategories)
          ..where((s) => s.categoryId.equals(categoryId))
          ..where((s) => s.isDeleted.equals(false))
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .watch();
  }

  Future<int> createSubCategory({
    required int shopId,
    required int categoryId,
    required String name,
    String? description,
  }) async {
    final now = DateTime.now();
    return _db.into(_db.subCategories).insert(
          SubCategoriesCompanion.insert(
            uuid: _uuid.v4(),
            shopId: shopId,
            categoryId: categoryId,
            name: name,
            description: Value(description),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<bool> updateSubCategory({
    required int id,
    String? name,
    String? description,
  }) async {
    final now = DateTime.now();
    final result = await (_db.update(_db.subCategories)..where((s) => s.id.equals(id))).write(
          SubCategoriesCompanion(
            name: name != null ? Value(name) : const Value.absent(),
            description: description != null ? Value(description) : const Value.absent(),
            updatedAt: Value(now),
          ),
        );
    return result > 0;
  }

  Future<void> deleteSubCategory(int id) async {
    final now = DateTime.now();
    await (_db.update(_db.subCategories)..where((s) => s.id.equals(id))).write(
          SubCategoriesCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }
}
