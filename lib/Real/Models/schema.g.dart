// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Invoice extends _Invoice with RealmEntity, RealmObjectBase, RealmObject {
  Invoice(
    ObjectId? id, {
    Supplier? supplier,
    Shop? shop,
    UserModel? attendantId,
    int? balance,
    int? total,
    int? dated,
    String? receiptNumber,
    bool? onCredit,
    int? productCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Iterable<InvoiceItem> items = const [],
    Iterable<InvoiceItem> returneditems = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'supplier', supplier);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'attendantId', attendantId);
    RealmObjectBase.set(this, 'balance', balance);
    RealmObjectBase.set(this, 'total', total);
    RealmObjectBase.set(this, 'dated', dated);
    RealmObjectBase.set(this, 'receiptNumber', receiptNumber);
    RealmObjectBase.set(this, 'onCredit', onCredit);
    RealmObjectBase.set(this, 'productCount', productCount);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set<RealmList<InvoiceItem>>(
        this, 'items', RealmList<InvoiceItem>(items));
    RealmObjectBase.set<RealmList<InvoiceItem>>(
        this, 'returneditems', RealmList<InvoiceItem>(returneditems));
  }

  Invoice._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  Supplier? get supplier =>
      RealmObjectBase.get<Supplier>(this, 'supplier') as Supplier?;
  @override
  set supplier(covariant Supplier? value) =>
      RealmObjectBase.set(this, 'supplier', value);

  @override
  Shop? get shop => RealmObjectBase.get<Shop>(this, 'shop') as Shop?;
  @override
  set shop(covariant Shop? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  UserModel? get attendantId =>
      RealmObjectBase.get<UserModel>(this, 'attendantId') as UserModel?;
  @override
  set attendantId(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendantId', value);

  @override
  int? get balance => RealmObjectBase.get<int>(this, 'balance') as int?;
  @override
  set balance(int? value) => RealmObjectBase.set(this, 'balance', value);

  @override
  int? get total => RealmObjectBase.get<int>(this, 'total') as int?;
  @override
  set total(int? value) => RealmObjectBase.set(this, 'total', value);

  @override
  int? get dated => RealmObjectBase.get<int>(this, 'dated') as int?;
  @override
  set dated(int? value) => RealmObjectBase.set(this, 'dated', value);

  @override
  String? get receiptNumber =>
      RealmObjectBase.get<String>(this, 'receiptNumber') as String?;
  @override
  set receiptNumber(String? value) =>
      RealmObjectBase.set(this, 'receiptNumber', value);

  @override
  bool? get onCredit => RealmObjectBase.get<bool>(this, 'onCredit') as bool?;
  @override
  set onCredit(bool? value) => RealmObjectBase.set(this, 'onCredit', value);

  @override
  int? get productCount =>
      RealmObjectBase.get<int>(this, 'productCount') as int?;
  @override
  set productCount(int? value) =>
      RealmObjectBase.set(this, 'productCount', value);

  @override
  RealmList<InvoiceItem> get items =>
      RealmObjectBase.get<InvoiceItem>(this, 'items') as RealmList<InvoiceItem>;
  @override
  set items(covariant RealmList<InvoiceItem> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<InvoiceItem> get returneditems =>
      RealmObjectBase.get<InvoiceItem>(this, 'returneditems')
          as RealmList<InvoiceItem>;
  @override
  set returneditems(covariant RealmList<InvoiceItem> value) =>
      throw RealmUnsupportedSetError();

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<Invoice>> get changes =>
      RealmObjectBase.getChanges<Invoice>(this);

  @override
  Invoice freeze() => RealmObjectBase.freezeObject<Invoice>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Invoice._);
    return const SchemaObject(ObjectType.realmObject, Invoice, 'Invoice', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('supplier', RealmPropertyType.object,
          optional: true, linkTarget: 'Supplier'),
      SchemaProperty('shop', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('attendantId', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('balance', RealmPropertyType.int, optional: true),
      SchemaProperty('total', RealmPropertyType.int, optional: true),
      SchemaProperty('dated', RealmPropertyType.int, optional: true),
      SchemaProperty('receiptNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('onCredit', RealmPropertyType.bool, optional: true),
      SchemaProperty('productCount', RealmPropertyType.int, optional: true),
      SchemaProperty('items', RealmPropertyType.object,
          linkTarget: 'InvoiceItem', collectionType: RealmCollectionType.list),
      SchemaProperty('returneditems', RealmPropertyType.object,
          linkTarget: 'InvoiceItem', collectionType: RealmCollectionType.list),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class CashOutGroup extends _CashOutGroup
    with RealmEntity, RealmObjectBase, RealmObject {
  CashOutGroup(
    ObjectId? id, {
    String? name,
    String? key,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'key', key);
  }

  CashOutGroup._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get key => RealmObjectBase.get<String>(this, 'key') as String?;
  @override
  set key(String? value) => RealmObjectBase.set(this, 'key', value);

  @override
  Stream<RealmObjectChanges<CashOutGroup>> get changes =>
      RealmObjectBase.getChanges<CashOutGroup>(this);

  @override
  CashOutGroup freeze() => RealmObjectBase.freezeObject<CashOutGroup>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CashOutGroup._);
    return const SchemaObject(
        ObjectType.realmObject, CashOutGroup, 'CashOutGroup', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('key', RealmPropertyType.string, optional: true),
    ]);
  }
}

class Supplier extends _Supplier
    with RealmEntity, RealmObjectBase, RealmObject {
  Supplier(
    ObjectId? id, {
    String? fullName,
    String? phoneNumber,
    String? shopId,
    String? emailAddress,
    String? location,
    String? credit,
    int? balance,
    bool? onCredit,
    DateTime? createdAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'fullName', fullName);
    RealmObjectBase.set(this, 'phoneNumber', phoneNumber);
    RealmObjectBase.set(this, 'shopId', shopId);
    RealmObjectBase.set(this, 'emailAddress', emailAddress);
    RealmObjectBase.set(this, 'location', location);
    RealmObjectBase.set(this, 'credit', credit);
    RealmObjectBase.set(this, 'balance', balance);
    RealmObjectBase.set(this, 'onCredit', onCredit);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  Supplier._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get fullName =>
      RealmObjectBase.get<String>(this, 'fullName') as String?;
  @override
  set fullName(String? value) => RealmObjectBase.set(this, 'fullName', value);

  @override
  String? get phoneNumber =>
      RealmObjectBase.get<String>(this, 'phoneNumber') as String?;
  @override
  set phoneNumber(String? value) =>
      RealmObjectBase.set(this, 'phoneNumber', value);

  @override
  String? get shopId => RealmObjectBase.get<String>(this, 'shopId') as String?;
  @override
  set shopId(String? value) => RealmObjectBase.set(this, 'shopId', value);

  @override
  String? get emailAddress =>
      RealmObjectBase.get<String>(this, 'emailAddress') as String?;
  @override
  set emailAddress(String? value) =>
      RealmObjectBase.set(this, 'emailAddress', value);

  @override
  String? get location =>
      RealmObjectBase.get<String>(this, 'location') as String?;
  @override
  set location(String? value) => RealmObjectBase.set(this, 'location', value);

  @override
  String? get credit => RealmObjectBase.get<String>(this, 'credit') as String?;
  @override
  set credit(String? value) => RealmObjectBase.set(this, 'credit', value);

  @override
  int? get balance => RealmObjectBase.get<int>(this, 'balance') as int?;
  @override
  set balance(int? value) => RealmObjectBase.set(this, 'balance', value);

  @override
  bool? get onCredit => RealmObjectBase.get<bool>(this, 'onCredit') as bool?;
  @override
  set onCredit(bool? value) => RealmObjectBase.set(this, 'onCredit', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<Supplier>> get changes =>
      RealmObjectBase.getChanges<Supplier>(this);

  @override
  Supplier freeze() => RealmObjectBase.freezeObject<Supplier>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Supplier._);
    return const SchemaObject(ObjectType.realmObject, Supplier, 'Supplier', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('fullName', RealmPropertyType.string, optional: true),
      SchemaProperty('phoneNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('shopId', RealmPropertyType.string, optional: true),
      SchemaProperty('emailAddress', RealmPropertyType.string, optional: true),
      SchemaProperty('location', RealmPropertyType.string, optional: true),
      SchemaProperty('credit', RealmPropertyType.string, optional: true),
      SchemaProperty('balance', RealmPropertyType.int, optional: true),
      SchemaProperty('onCredit', RealmPropertyType.bool, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class Shop extends _Shop with RealmEntity, RealmObjectBase, RealmObject {
  Shop(
    ObjectId? id, {
    String? name,
    String? location,
    ShopTypes? type,
    String? owner,
    String? currency,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'location', location);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'owner', owner);
    RealmObjectBase.set(this, 'currency', currency);
  }

  Shop._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get location =>
      RealmObjectBase.get<String>(this, 'location') as String?;
  @override
  set location(String? value) => RealmObjectBase.set(this, 'location', value);

  @override
  ShopTypes? get type =>
      RealmObjectBase.get<ShopTypes>(this, 'type') as ShopTypes?;
  @override
  set type(covariant ShopTypes? value) =>
      RealmObjectBase.set(this, 'type', value);

  @override
  String? get owner => RealmObjectBase.get<String>(this, 'owner') as String?;
  @override
  set owner(String? value) => RealmObjectBase.set(this, 'owner', value);

  @override
  String? get currency =>
      RealmObjectBase.get<String>(this, 'currency') as String?;
  @override
  set currency(String? value) => RealmObjectBase.set(this, 'currency', value);

  @override
  Stream<RealmObjectChanges<Shop>> get changes =>
      RealmObjectBase.getChanges<Shop>(this);

  @override
  Shop freeze() => RealmObjectBase.freezeObject<Shop>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Shop._);
    return const SchemaObject(ObjectType.realmObject, Shop, 'Shop', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('location', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.object,
          optional: true, linkTarget: 'ShopTypes'),
      SchemaProperty('owner', RealmPropertyType.string, optional: true),
      SchemaProperty('currency', RealmPropertyType.string, optional: true),
    ]);
  }
}

class UserModel extends _UserModel
    with RealmEntity, RealmObjectBase, RealmObject {
  UserModel(
    ObjectId? id,
    int UNID, {
    String? username,
    bool? loggedin,
    bool? deleted,
    String? fullnames,
    String? phonenumber,
    String? authId,
    Shop? shop,
    String? permisions,
    String? usertype,
    Iterable<RolesModel> roles = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'username', username);
    RealmObjectBase.set(this, 'loggedin', loggedin);
    RealmObjectBase.set(this, 'deleted', deleted);
    RealmObjectBase.set(this, 'fullnames', fullnames);
    RealmObjectBase.set(this, 'phonenumber', phonenumber);
    RealmObjectBase.set(this, 'authId', authId);
    RealmObjectBase.set(this, 'UNID', UNID);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'permisions', permisions);
    RealmObjectBase.set(this, 'usertype', usertype);
    RealmObjectBase.set<RealmList<RolesModel>>(
        this, 'roles', RealmList<RolesModel>(roles));
  }

  UserModel._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get username =>
      RealmObjectBase.get<String>(this, 'username') as String?;
  @override
  set username(String? value) => RealmObjectBase.set(this, 'username', value);

  @override
  bool? get loggedin => RealmObjectBase.get<bool>(this, 'loggedin') as bool?;
  @override
  set loggedin(bool? value) => RealmObjectBase.set(this, 'loggedin', value);

  @override
  bool? get deleted => RealmObjectBase.get<bool>(this, 'deleted') as bool?;
  @override
  set deleted(bool? value) => RealmObjectBase.set(this, 'deleted', value);

  @override
  String? get fullnames =>
      RealmObjectBase.get<String>(this, 'fullnames') as String?;
  @override
  set fullnames(String? value) => RealmObjectBase.set(this, 'fullnames', value);

  @override
  String? get phonenumber =>
      RealmObjectBase.get<String>(this, 'phonenumber') as String?;
  @override
  set phonenumber(String? value) =>
      RealmObjectBase.set(this, 'phonenumber', value);

  @override
  String? get authId => RealmObjectBase.get<String>(this, 'authId') as String?;
  @override
  set authId(String? value) => RealmObjectBase.set(this, 'authId', value);

  @override
  int get UNID => RealmObjectBase.get<int>(this, 'UNID') as int;
  @override
  set UNID(int value) => RealmObjectBase.set(this, 'UNID', value);

  @override
  Shop? get shop => RealmObjectBase.get<Shop>(this, 'shop') as Shop?;
  @override
  set shop(covariant Shop? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  RealmList<RolesModel> get roles =>
      RealmObjectBase.get<RolesModel>(this, 'roles') as RealmList<RolesModel>;
  @override
  set roles(covariant RealmList<RolesModel> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get permisions =>
      RealmObjectBase.get<String>(this, 'permisions') as String?;
  @override
  set permisions(String? value) =>
      RealmObjectBase.set(this, 'permisions', value);

  @override
  String? get usertype =>
      RealmObjectBase.get<String>(this, 'usertype') as String?;
  @override
  set usertype(String? value) => RealmObjectBase.set(this, 'usertype', value);

  @override
  Stream<RealmObjectChanges<UserModel>> get changes =>
      RealmObjectBase.getChanges<UserModel>(this);

  @override
  UserModel freeze() => RealmObjectBase.freezeObject<UserModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(UserModel._);
    return const SchemaObject(ObjectType.realmObject, UserModel, 'UserModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('username', RealmPropertyType.string, optional: true),
      SchemaProperty('loggedin', RealmPropertyType.bool, optional: true),
      SchemaProperty('deleted', RealmPropertyType.bool, optional: true),
      SchemaProperty('fullnames', RealmPropertyType.string, optional: true),
      SchemaProperty('phonenumber', RealmPropertyType.string, optional: true),
      SchemaProperty('authId', RealmPropertyType.string, optional: true),
      SchemaProperty('UNID', RealmPropertyType.int),
      SchemaProperty('shop', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('roles', RealmPropertyType.object,
          linkTarget: 'RolesModel', collectionType: RealmCollectionType.list),
      SchemaProperty('permisions', RealmPropertyType.string, optional: true),
      SchemaProperty('usertype', RealmPropertyType.string, optional: true),
    ]);
  }
}

class RolesModel extends _RolesModel
    with RealmEntity, RealmObjectBase, RealmObject {
  RolesModel(
    ObjectId? id, {
    String? key,
    String? name,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'key', key);
    RealmObjectBase.set(this, 'name', name);
  }

  RolesModel._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get key => RealmObjectBase.get<String>(this, 'key') as String?;
  @override
  set key(String? value) => RealmObjectBase.set(this, 'key', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<RolesModel>> get changes =>
      RealmObjectBase.getChanges<RolesModel>(this);

  @override
  RolesModel freeze() => RealmObjectBase.freezeObject<RolesModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RolesModel._);
    return const SchemaObject(
        ObjectType.realmObject, RolesModel, 'RolesModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('key', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
    ]);
  }
}

class ShopTypes extends _ShopTypes
    with RealmEntity, RealmObjectBase, RealmObject {
  ShopTypes(
    ObjectId? id, {
    String? title,
  }) {
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, '_id', id);
  }

  ShopTypes._();

  @override
  String? get title => RealmObjectBase.get<String>(this, 'title') as String?;
  @override
  set title(String? value) => RealmObjectBase.set(this, 'title', value);

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  Stream<RealmObjectChanges<ShopTypes>> get changes =>
      RealmObjectBase.getChanges<ShopTypes>(this);

  @override
  ShopTypes freeze() => RealmObjectBase.freezeObject<ShopTypes>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ShopTypes._);
    return const SchemaObject(ObjectType.realmObject, ShopTypes, 'ShopTypes', [
      SchemaProperty('title', RealmPropertyType.string, optional: true),
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
    ]);
  }
}

class Product extends _Product with RealmEntity, RealmObjectBase, RealmObject {
  Product(
    ObjectId? id, {
    String? name,
    int? quantity,
    ProductCategory? category,
    int? stockLevel,
    Shop? shop,
    int? discount,
    UserModel? attendant,
    int? buyingPrice,
    int? minPrice,
    int? badstock,
    String? description,
    String? unit,
    bool? deleted,
    bool? counted,
    String? supplier,
    int? cartquantity,
    int? amount,
    int? selling,
    String? counteddate,
    String? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    Iterable<String> sellingPrice = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'stockLevel', stockLevel);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'discount', discount);
    RealmObjectBase.set(this, 'attendant', attendant);
    RealmObjectBase.set(this, 'buyingPrice', buyingPrice);
    RealmObjectBase.set(this, 'minPrice', minPrice);
    RealmObjectBase.set(this, 'badstock', badstock);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'unit', unit);
    RealmObjectBase.set(this, 'deleted', deleted);
    RealmObjectBase.set(this, 'counted', counted);
    RealmObjectBase.set(this, 'supplier', supplier);
    RealmObjectBase.set(this, 'cartquantity', cartquantity);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'selling', selling);
    RealmObjectBase.set(this, 'counteddate', counteddate);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set<RealmList<String>>(
        this, 'sellingPrice', RealmList<String>(sellingPrice));
  }

  Product._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  int? get quantity => RealmObjectBase.get<int>(this, 'quantity') as int?;
  @override
  set quantity(int? value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  ProductCategory? get category =>
      RealmObjectBase.get<ProductCategory>(this, 'category')
          as ProductCategory?;
  @override
  set category(covariant ProductCategory? value) =>
      RealmObjectBase.set(this, 'category', value);

  @override
  int? get stockLevel => RealmObjectBase.get<int>(this, 'stockLevel') as int?;
  @override
  set stockLevel(int? value) => RealmObjectBase.set(this, 'stockLevel', value);

  @override
  RealmList<String> get sellingPrice =>
      RealmObjectBase.get<String>(this, 'sellingPrice') as RealmList<String>;
  @override
  set sellingPrice(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  Shop? get shop => RealmObjectBase.get<Shop>(this, 'shop') as Shop?;
  @override
  set shop(covariant Shop? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  int? get discount => RealmObjectBase.get<int>(this, 'discount') as int?;
  @override
  set discount(int? value) => RealmObjectBase.set(this, 'discount', value);

  @override
  UserModel? get attendant =>
      RealmObjectBase.get<UserModel>(this, 'attendant') as UserModel?;
  @override
  set attendant(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendant', value);

  @override
  int? get buyingPrice => RealmObjectBase.get<int>(this, 'buyingPrice') as int?;
  @override
  set buyingPrice(int? value) =>
      RealmObjectBase.set(this, 'buyingPrice', value);

  @override
  int? get minPrice => RealmObjectBase.get<int>(this, 'minPrice') as int?;
  @override
  set minPrice(int? value) => RealmObjectBase.set(this, 'minPrice', value);

  @override
  int? get badstock => RealmObjectBase.get<int>(this, 'badstock') as int?;
  @override
  set badstock(int? value) => RealmObjectBase.set(this, 'badstock', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String? get unit => RealmObjectBase.get<String>(this, 'unit') as String?;
  @override
  set unit(String? value) => RealmObjectBase.set(this, 'unit', value);

  @override
  bool? get deleted => RealmObjectBase.get<bool>(this, 'deleted') as bool?;
  @override
  set deleted(bool? value) => RealmObjectBase.set(this, 'deleted', value);

  @override
  bool? get counted => RealmObjectBase.get<bool>(this, 'counted') as bool?;
  @override
  set counted(bool? value) => RealmObjectBase.set(this, 'counted', value);

  @override
  String? get supplier =>
      RealmObjectBase.get<String>(this, 'supplier') as String?;
  @override
  set supplier(String? value) => RealmObjectBase.set(this, 'supplier', value);

  @override
  int? get cartquantity =>
      RealmObjectBase.get<int>(this, 'cartquantity') as int?;
  @override
  set cartquantity(int? value) =>
      RealmObjectBase.set(this, 'cartquantity', value);

  @override
  int? get amount => RealmObjectBase.get<int>(this, 'amount') as int?;
  @override
  set amount(int? value) => RealmObjectBase.set(this, 'amount', value);

  @override
  int? get selling => RealmObjectBase.get<int>(this, 'selling') as int?;
  @override
  set selling(int? value) => RealmObjectBase.set(this, 'selling', value);

  @override
  String? get counteddate =>
      RealmObjectBase.get<String>(this, 'counteddate') as String?;
  @override
  set counteddate(String? value) =>
      RealmObjectBase.set(this, 'counteddate', value);

  @override
  String? get date => RealmObjectBase.get<String>(this, 'date') as String?;
  @override
  set date(String? value) => RealmObjectBase.set(this, 'date', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<Product>> get changes =>
      RealmObjectBase.getChanges<Product>(this);

  @override
  Product freeze() => RealmObjectBase.freezeObject<Product>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Product._);
    return const SchemaObject(ObjectType.realmObject, Product, 'Product', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('quantity', RealmPropertyType.int, optional: true),
      SchemaProperty('category', RealmPropertyType.object,
          optional: true, linkTarget: 'ProductCategory'),
      SchemaProperty('stockLevel', RealmPropertyType.int, optional: true),
      SchemaProperty('sellingPrice', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('shop', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('discount', RealmPropertyType.int, optional: true),
      SchemaProperty('attendant', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('buyingPrice', RealmPropertyType.int, optional: true),
      SchemaProperty('minPrice', RealmPropertyType.int, optional: true),
      SchemaProperty('badstock', RealmPropertyType.int, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('unit', RealmPropertyType.string, optional: true),
      SchemaProperty('deleted', RealmPropertyType.bool, optional: true),
      SchemaProperty('counted', RealmPropertyType.bool, optional: true),
      SchemaProperty('supplier', RealmPropertyType.string, optional: true),
      SchemaProperty('cartquantity', RealmPropertyType.int, optional: true),
      SchemaProperty('amount', RealmPropertyType.int, optional: true),
      SchemaProperty('selling', RealmPropertyType.int, optional: true),
      SchemaProperty('counteddate', RealmPropertyType.string, optional: true),
      SchemaProperty('date', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class ProductCategory extends _ProductCategory
    with RealmEntity, RealmObjectBase, RealmObject {
  ProductCategory(
    ObjectId? id, {
    String? name,
    Shop? shop,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  ProductCategory._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  Shop? get shop => RealmObjectBase.get<Shop>(this, 'shop') as Shop?;
  @override
  set shop(covariant Shop? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<ProductCategory>> get changes =>
      RealmObjectBase.getChanges<ProductCategory>(this);

  @override
  ProductCategory freeze() =>
      RealmObjectBase.freezeObject<ProductCategory>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ProductCategory._);
    return const SchemaObject(
        ObjectType.realmObject, ProductCategory, 'ProductCategory', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('shop', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class BadStock extends _BadStock
    with RealmEntity, RealmObjectBase, RealmObject {
  BadStock(
    ObjectId? id, {
    String? description,
    int? quantity,
    int? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    Product? product,
    UserModel? attendantId,
    Shop? shop,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'product', product);
    RealmObjectBase.set(this, 'attendantId', attendantId);
    RealmObjectBase.set(this, 'shop', shop);
  }

  BadStock._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  int? get quantity => RealmObjectBase.get<int>(this, 'quantity') as int?;
  @override
  set quantity(int? value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  int? get date => RealmObjectBase.get<int>(this, 'date') as int?;
  @override
  set date(int? value) => RealmObjectBase.set(this, 'date', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Product? get product =>
      RealmObjectBase.get<Product>(this, 'product') as Product?;
  @override
  set product(covariant Product? value) =>
      RealmObjectBase.set(this, 'product', value);

  @override
  UserModel? get attendantId =>
      RealmObjectBase.get<UserModel>(this, 'attendantId') as UserModel?;
  @override
  set attendantId(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendantId', value);

  @override
  Shop? get shop => RealmObjectBase.get<Shop>(this, 'shop') as Shop?;
  @override
  set shop(covariant Shop? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  Stream<RealmObjectChanges<BadStock>> get changes =>
      RealmObjectBase.getChanges<BadStock>(this);

  @override
  BadStock freeze() => RealmObjectBase.freezeObject<BadStock>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(BadStock._);
    return const SchemaObject(ObjectType.realmObject, BadStock, 'BadStock', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('quantity', RealmPropertyType.int, optional: true),
      SchemaProperty('date', RealmPropertyType.int, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('product', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
      SchemaProperty('attendantId', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('shop', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
    ]);
  }
}

class BankModel extends _BankModel
    with RealmEntity, RealmObjectBase, RealmObject {
  BankModel(
    ObjectId? id, {
    String? shop,
    String? name,
    int? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  BankModel._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get shop => RealmObjectBase.get<String>(this, 'shop') as String?;
  @override
  set shop(String? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  int? get amount => RealmObjectBase.get<int>(this, 'amount') as int?;
  @override
  set amount(int? value) => RealmObjectBase.set(this, 'amount', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<BankModel>> get changes =>
      RealmObjectBase.getChanges<BankModel>(this);

  @override
  BankModel freeze() => RealmObjectBase.freezeObject<BankModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(BankModel._);
    return const SchemaObject(ObjectType.realmObject, BankModel, 'BankModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('shop', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('amount', RealmPropertyType.int, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class BankTransactions extends _BankTransactions
    with RealmEntity, RealmObjectBase, RealmObject {
  BankTransactions(
    ObjectId? id, {
    String? shop,
    String? category,
    CashOutGroup? group,
    int? amount,
    DateTime? createdAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'group', group);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  BankTransactions._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get shop => RealmObjectBase.get<String>(this, 'shop') as String?;
  @override
  set shop(String? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  String? get category =>
      RealmObjectBase.get<String>(this, 'category') as String?;
  @override
  set category(String? value) => RealmObjectBase.set(this, 'category', value);

  @override
  CashOutGroup? get group =>
      RealmObjectBase.get<CashOutGroup>(this, 'group') as CashOutGroup?;
  @override
  set group(covariant CashOutGroup? value) =>
      RealmObjectBase.set(this, 'group', value);

  @override
  int? get amount => RealmObjectBase.get<int>(this, 'amount') as int?;
  @override
  set amount(int? value) => RealmObjectBase.set(this, 'amount', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<BankTransactions>> get changes =>
      RealmObjectBase.getChanges<BankTransactions>(this);

  @override
  BankTransactions freeze() =>
      RealmObjectBase.freezeObject<BankTransactions>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(BankTransactions._);
    return const SchemaObject(
        ObjectType.realmObject, BankTransactions, 'BankTransactions', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('shop', RealmPropertyType.string, optional: true),
      SchemaProperty('category', RealmPropertyType.string, optional: true),
      SchemaProperty('group', RealmPropertyType.object,
          optional: true, linkTarget: 'CashOutGroup'),
      SchemaProperty('amount', RealmPropertyType.int, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class CashFlowCategory extends _CashFlowCategory
    with RealmEntity, RealmObjectBase, RealmObject {
  CashFlowCategory(
    ObjectId? id, {
    String? name,
    int? amount,
    String? type,
    String? key,
    String? shop,
    DateTime? createdAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'key', key);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  CashFlowCategory._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  int? get amount => RealmObjectBase.get<int>(this, 'amount') as int?;
  @override
  set amount(int? value) => RealmObjectBase.set(this, 'amount', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get key => RealmObjectBase.get<String>(this, 'key') as String?;
  @override
  set key(String? value) => RealmObjectBase.set(this, 'key', value);

  @override
  String? get shop => RealmObjectBase.get<String>(this, 'shop') as String?;
  @override
  set shop(String? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<CashFlowCategory>> get changes =>
      RealmObjectBase.getChanges<CashFlowCategory>(this);

  @override
  CashFlowCategory freeze() =>
      RealmObjectBase.freezeObject<CashFlowCategory>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CashFlowCategory._);
    return const SchemaObject(
        ObjectType.realmObject, CashFlowCategory, 'CashFlowCategory', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('amount', RealmPropertyType.int, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('key', RealmPropertyType.string, optional: true),
      SchemaProperty('shop', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class CashFlowTransaction extends _CashFlowTransaction
    with RealmEntity, RealmObjectBase, RealmObject {
  CashFlowTransaction(
    ObjectId? id, {
    CashFlowCategory? cashFlowCategory,
    BankModel? bank,
    int? amount,
    String? type,
    String? description,
    Shop? shop,
    int? date,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'cashFlowCategory', cashFlowCategory);
    RealmObjectBase.set(this, 'bank', bank);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'date', date);
  }

  CashFlowTransaction._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  CashFlowCategory? get cashFlowCategory =>
      RealmObjectBase.get<CashFlowCategory>(this, 'cashFlowCategory')
          as CashFlowCategory?;
  @override
  set cashFlowCategory(covariant CashFlowCategory? value) =>
      RealmObjectBase.set(this, 'cashFlowCategory', value);

  @override
  BankModel? get bank =>
      RealmObjectBase.get<BankModel>(this, 'bank') as BankModel?;
  @override
  set bank(covariant BankModel? value) =>
      RealmObjectBase.set(this, 'bank', value);

  @override
  int? get amount => RealmObjectBase.get<int>(this, 'amount') as int?;
  @override
  set amount(int? value) => RealmObjectBase.set(this, 'amount', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  Shop? get shop => RealmObjectBase.get<Shop>(this, 'shop') as Shop?;
  @override
  set shop(covariant Shop? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  int? get date => RealmObjectBase.get<int>(this, 'date') as int?;
  @override
  set date(int? value) => RealmObjectBase.set(this, 'date', value);

  @override
  Stream<RealmObjectChanges<CashFlowTransaction>> get changes =>
      RealmObjectBase.getChanges<CashFlowTransaction>(this);

  @override
  CashFlowTransaction freeze() =>
      RealmObjectBase.freezeObject<CashFlowTransaction>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CashFlowTransaction._);
    return const SchemaObject(
        ObjectType.realmObject, CashFlowTransaction, 'CashFlowTransaction', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('cashFlowCategory', RealmPropertyType.object,
          optional: true, linkTarget: 'CashFlowCategory'),
      SchemaProperty('bank', RealmPropertyType.object,
          optional: true, linkTarget: 'BankModel'),
      SchemaProperty('amount', RealmPropertyType.int, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('shop', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('date', RealmPropertyType.int, optional: true),
    ]);
  }
}

class CustomerModel extends _CustomerModel
    with RealmEntity, RealmObjectBase, RealmObject {
  CustomerModel(
    ObjectId? id, {
    String? fullName,
    String? phoneNumber,
    int? walletBalance,
    bool? onCredit,
    int? credit,
    Shop? shopId,
    String? gender,
    String? email,
    String? address,
    DateTime? createdAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'fullName', fullName);
    RealmObjectBase.set(this, 'phoneNumber', phoneNumber);
    RealmObjectBase.set(this, 'walletBalance', walletBalance);
    RealmObjectBase.set(this, 'onCredit', onCredit);
    RealmObjectBase.set(this, 'credit', credit);
    RealmObjectBase.set(this, 'shopId', shopId);
    RealmObjectBase.set(this, 'gender', gender);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'address', address);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  CustomerModel._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get fullName =>
      RealmObjectBase.get<String>(this, 'fullName') as String?;
  @override
  set fullName(String? value) => RealmObjectBase.set(this, 'fullName', value);

  @override
  String? get phoneNumber =>
      RealmObjectBase.get<String>(this, 'phoneNumber') as String?;
  @override
  set phoneNumber(String? value) =>
      RealmObjectBase.set(this, 'phoneNumber', value);

  @override
  int? get walletBalance =>
      RealmObjectBase.get<int>(this, 'walletBalance') as int?;
  @override
  set walletBalance(int? value) =>
      RealmObjectBase.set(this, 'walletBalance', value);

  @override
  bool? get onCredit => RealmObjectBase.get<bool>(this, 'onCredit') as bool?;
  @override
  set onCredit(bool? value) => RealmObjectBase.set(this, 'onCredit', value);

  @override
  int? get credit => RealmObjectBase.get<int>(this, 'credit') as int?;
  @override
  set credit(int? value) => RealmObjectBase.set(this, 'credit', value);

  @override
  Shop? get shopId => RealmObjectBase.get<Shop>(this, 'shopId') as Shop?;
  @override
  set shopId(covariant Shop? value) =>
      RealmObjectBase.set(this, 'shopId', value);

  @override
  String? get gender => RealmObjectBase.get<String>(this, 'gender') as String?;
  @override
  set gender(String? value) => RealmObjectBase.set(this, 'gender', value);

  @override
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  String? get address =>
      RealmObjectBase.get<String>(this, 'address') as String?;
  @override
  set address(String? value) => RealmObjectBase.set(this, 'address', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<CustomerModel>> get changes =>
      RealmObjectBase.getChanges<CustomerModel>(this);

  @override
  CustomerModel freeze() => RealmObjectBase.freezeObject<CustomerModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(CustomerModel._);
    return const SchemaObject(
        ObjectType.realmObject, CustomerModel, 'CustomerModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('fullName', RealmPropertyType.string, optional: true),
      SchemaProperty('phoneNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('walletBalance', RealmPropertyType.int, optional: true),
      SchemaProperty('onCredit', RealmPropertyType.bool, optional: true),
      SchemaProperty('credit', RealmPropertyType.int, optional: true),
      SchemaProperty('shopId', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('gender', RealmPropertyType.string, optional: true),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('address', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class DepositModel extends _DepositModel
    with RealmEntity, RealmObjectBase, RealmObject {
  DepositModel(
    ObjectId? id, {
    CustomerModel? customer,
    int? amount,
    SalesModel? receipt,
    String? recieptNumber,
    String? type,
    UserModel? attendant,
    int? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'customer', customer);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'receipt', receipt);
    RealmObjectBase.set(this, 'recieptNumber', recieptNumber);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'attendant', attendant);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  DepositModel._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  CustomerModel? get customer =>
      RealmObjectBase.get<CustomerModel>(this, 'customer') as CustomerModel?;
  @override
  set customer(covariant CustomerModel? value) =>
      RealmObjectBase.set(this, 'customer', value);

  @override
  int? get amount => RealmObjectBase.get<int>(this, 'amount') as int?;
  @override
  set amount(int? value) => RealmObjectBase.set(this, 'amount', value);

  @override
  SalesModel? get receipt =>
      RealmObjectBase.get<SalesModel>(this, 'receipt') as SalesModel?;
  @override
  set receipt(covariant SalesModel? value) =>
      RealmObjectBase.set(this, 'receipt', value);

  @override
  String? get recieptNumber =>
      RealmObjectBase.get<String>(this, 'recieptNumber') as String?;
  @override
  set recieptNumber(String? value) =>
      RealmObjectBase.set(this, 'recieptNumber', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  UserModel? get attendant =>
      RealmObjectBase.get<UserModel>(this, 'attendant') as UserModel?;
  @override
  set attendant(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendant', value);

  @override
  int? get date => RealmObjectBase.get<int>(this, 'date') as int?;
  @override
  set date(int? value) => RealmObjectBase.set(this, 'date', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<DepositModel>> get changes =>
      RealmObjectBase.getChanges<DepositModel>(this);

  @override
  DepositModel freeze() => RealmObjectBase.freezeObject<DepositModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(DepositModel._);
    return const SchemaObject(
        ObjectType.realmObject, DepositModel, 'DepositModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('customer', RealmPropertyType.object,
          optional: true, linkTarget: 'CustomerModel'),
      SchemaProperty('amount', RealmPropertyType.int, optional: true),
      SchemaProperty('receipt', RealmPropertyType.object,
          optional: true, linkTarget: 'SalesModel'),
      SchemaProperty('recieptNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('attendant', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('date', RealmPropertyType.int, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class ExpenseModel extends _ExpenseModel
    with RealmEntity, RealmObjectBase, RealmObject {
  ExpenseModel(
    ObjectId? id, {
    String? category,
    int? amount,
    String? shop,
    String? name,
    UserModel? attendantId,
    int? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'attendantId', attendantId);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  ExpenseModel._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get category =>
      RealmObjectBase.get<String>(this, 'category') as String?;
  @override
  set category(String? value) => RealmObjectBase.set(this, 'category', value);

  @override
  int? get amount => RealmObjectBase.get<int>(this, 'amount') as int?;
  @override
  set amount(int? value) => RealmObjectBase.set(this, 'amount', value);

  @override
  String? get shop => RealmObjectBase.get<String>(this, 'shop') as String?;
  @override
  set shop(String? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  UserModel? get attendantId =>
      RealmObjectBase.get<UserModel>(this, 'attendantId') as UserModel?;
  @override
  set attendantId(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendantId', value);

  @override
  int? get date => RealmObjectBase.get<int>(this, 'date') as int?;
  @override
  set date(int? value) => RealmObjectBase.set(this, 'date', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<ExpenseModel>> get changes =>
      RealmObjectBase.getChanges<ExpenseModel>(this);

  @override
  ExpenseModel freeze() => RealmObjectBase.freezeObject<ExpenseModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ExpenseModel._);
    return const SchemaObject(
        ObjectType.realmObject, ExpenseModel, 'ExpenseModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('category', RealmPropertyType.string, optional: true),
      SchemaProperty('amount', RealmPropertyType.int, optional: true),
      SchemaProperty('shop', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('attendantId', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('date', RealmPropertyType.int, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class InvoiceItem extends _InvoiceItem
    with RealmEntity, RealmObjectBase, RealmObject {
  InvoiceItem(
    ObjectId? id, {
    Product? product,
    String? type,
    String? shop,
    Supplier? supplier,
    Invoice? invoice,
    UserModel? attendantid,
    int? total,
    int? itemCount,
    int? returnedItems,
    int? price,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'product', product);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'supplier', supplier);
    RealmObjectBase.set(this, 'invoice', invoice);
    RealmObjectBase.set(this, 'attendantid', attendantid);
    RealmObjectBase.set(this, 'total', total);
    RealmObjectBase.set(this, 'itemCount', itemCount);
    RealmObjectBase.set(this, 'returnedItems', returnedItems);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  InvoiceItem._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  Product? get product =>
      RealmObjectBase.get<Product>(this, 'product') as Product?;
  @override
  set product(covariant Product? value) =>
      RealmObjectBase.set(this, 'product', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get shop => RealmObjectBase.get<String>(this, 'shop') as String?;
  @override
  set shop(String? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  Supplier? get supplier =>
      RealmObjectBase.get<Supplier>(this, 'supplier') as Supplier?;
  @override
  set supplier(covariant Supplier? value) =>
      RealmObjectBase.set(this, 'supplier', value);

  @override
  Invoice? get invoice =>
      RealmObjectBase.get<Invoice>(this, 'invoice') as Invoice?;
  @override
  set invoice(covariant Invoice? value) =>
      RealmObjectBase.set(this, 'invoice', value);

  @override
  UserModel? get attendantid =>
      RealmObjectBase.get<UserModel>(this, 'attendantid') as UserModel?;
  @override
  set attendantid(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendantid', value);

  @override
  int? get total => RealmObjectBase.get<int>(this, 'total') as int?;
  @override
  set total(int? value) => RealmObjectBase.set(this, 'total', value);

  @override
  int? get itemCount => RealmObjectBase.get<int>(this, 'itemCount') as int?;
  @override
  set itemCount(int? value) => RealmObjectBase.set(this, 'itemCount', value);

  @override
  int? get returnedItems =>
      RealmObjectBase.get<int>(this, 'returnedItems') as int?;
  @override
  set returnedItems(int? value) =>
      RealmObjectBase.set(this, 'returnedItems', value);

  @override
  int? get price => RealmObjectBase.get<int>(this, 'price') as int?;
  @override
  set price(int? value) => RealmObjectBase.set(this, 'price', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<InvoiceItem>> get changes =>
      RealmObjectBase.getChanges<InvoiceItem>(this);

  @override
  InvoiceItem freeze() => RealmObjectBase.freezeObject<InvoiceItem>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(InvoiceItem._);
    return const SchemaObject(
        ObjectType.realmObject, InvoiceItem, 'InvoiceItem', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('product', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('shop', RealmPropertyType.string, optional: true),
      SchemaProperty('supplier', RealmPropertyType.object,
          optional: true, linkTarget: 'Supplier'),
      SchemaProperty('invoice', RealmPropertyType.object,
          optional: true, linkTarget: 'Invoice'),
      SchemaProperty('attendantid', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('total', RealmPropertyType.int, optional: true),
      SchemaProperty('itemCount', RealmPropertyType.int, optional: true),
      SchemaProperty('returnedItems', RealmPropertyType.int, optional: true),
      SchemaProperty('price', RealmPropertyType.int, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class PayHistory extends _PayHistory
    with RealmEntity, RealmObjectBase, RealmObject {
  PayHistory(
    ObjectId? id, {
    UserModel? attendant,
    int? amountPaid,
    int? balance,
    Invoice? invoice,
    SalesModel? receipt,
    DateTime? createdAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'attendant', attendant);
    RealmObjectBase.set(this, 'amountPaid', amountPaid);
    RealmObjectBase.set(this, 'balance', balance);
    RealmObjectBase.set(this, 'invoice', invoice);
    RealmObjectBase.set(this, 'receipt', receipt);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  PayHistory._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  UserModel? get attendant =>
      RealmObjectBase.get<UserModel>(this, 'attendant') as UserModel?;
  @override
  set attendant(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendant', value);

  @override
  int? get amountPaid => RealmObjectBase.get<int>(this, 'amountPaid') as int?;
  @override
  set amountPaid(int? value) => RealmObjectBase.set(this, 'amountPaid', value);

  @override
  int? get balance => RealmObjectBase.get<int>(this, 'balance') as int?;
  @override
  set balance(int? value) => RealmObjectBase.set(this, 'balance', value);

  @override
  Invoice? get invoice =>
      RealmObjectBase.get<Invoice>(this, 'invoice') as Invoice?;
  @override
  set invoice(covariant Invoice? value) =>
      RealmObjectBase.set(this, 'invoice', value);

  @override
  SalesModel? get receipt =>
      RealmObjectBase.get<SalesModel>(this, 'receipt') as SalesModel?;
  @override
  set receipt(covariant SalesModel? value) =>
      RealmObjectBase.set(this, 'receipt', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<PayHistory>> get changes =>
      RealmObjectBase.getChanges<PayHistory>(this);

  @override
  PayHistory freeze() => RealmObjectBase.freezeObject<PayHistory>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(PayHistory._);
    return const SchemaObject(
        ObjectType.realmObject, PayHistory, 'PayHistory', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('attendant', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('amountPaid', RealmPropertyType.int, optional: true),
      SchemaProperty('balance', RealmPropertyType.int, optional: true),
      SchemaProperty('invoice', RealmPropertyType.object,
          optional: true, linkTarget: 'Invoice'),
      SchemaProperty('receipt', RealmPropertyType.object,
          optional: true, linkTarget: 'SalesModel'),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class Plan extends _Plan with RealmEntity, RealmObjectBase, RealmObject {
  Plan(
    String title,
    double price,
    String description,
    int shops,
    int time,
  ) {
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'shops', shops);
    RealmObjectBase.set(this, 'time', time);
  }

  Plan._();

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override
  set price(double value) => RealmObjectBase.set(this, 'price', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  int get shops => RealmObjectBase.get<int>(this, 'shops') as int;
  @override
  set shops(int value) => RealmObjectBase.set(this, 'shops', value);

  @override
  int get time => RealmObjectBase.get<int>(this, 'time') as int;
  @override
  set time(int value) => RealmObjectBase.set(this, 'time', value);

  @override
  Stream<RealmObjectChanges<Plan>> get changes =>
      RealmObjectBase.getChanges<Plan>(this);

  @override
  Plan freeze() => RealmObjectBase.freezeObject<Plan>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Plan._);
    return const SchemaObject(ObjectType.realmObject, Plan, 'Plan', [
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('price', RealmPropertyType.double),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('shops', RealmPropertyType.int),
      SchemaProperty('time', RealmPropertyType.int),
    ]);
  }
}

class ProductCountModel extends _ProductCountModel
    with RealmEntity, RealmObjectBase, RealmObject {
  ProductCountModel(
    ObjectId? id, {
    Product? product,
    int? quantity,
    int? initialquantity,
    UserModel? attendantId,
    Shop? shopId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'product', product);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'initialquantity', initialquantity);
    RealmObjectBase.set(this, 'attendantId', attendantId);
    RealmObjectBase.set(this, 'shopId', shopId);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  ProductCountModel._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  Product? get product =>
      RealmObjectBase.get<Product>(this, 'product') as Product?;
  @override
  set product(covariant Product? value) =>
      RealmObjectBase.set(this, 'product', value);

  @override
  int? get quantity => RealmObjectBase.get<int>(this, 'quantity') as int?;
  @override
  set quantity(int? value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  int? get initialquantity =>
      RealmObjectBase.get<int>(this, 'initialquantity') as int?;
  @override
  set initialquantity(int? value) =>
      RealmObjectBase.set(this, 'initialquantity', value);

  @override
  UserModel? get attendantId =>
      RealmObjectBase.get<UserModel>(this, 'attendantId') as UserModel?;
  @override
  set attendantId(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendantId', value);

  @override
  Shop? get shopId => RealmObjectBase.get<Shop>(this, 'shopId') as Shop?;
  @override
  set shopId(covariant Shop? value) =>
      RealmObjectBase.set(this, 'shopId', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<ProductCountModel>> get changes =>
      RealmObjectBase.getChanges<ProductCountModel>(this);

  @override
  ProductCountModel freeze() =>
      RealmObjectBase.freezeObject<ProductCountModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ProductCountModel._);
    return const SchemaObject(
        ObjectType.realmObject, ProductCountModel, 'ProductCountModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('product', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
      SchemaProperty('quantity', RealmPropertyType.int, optional: true),
      SchemaProperty('initialquantity', RealmPropertyType.int, optional: true),
      SchemaProperty('attendantId', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('shopId', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class ProductHistoryModel extends _ProductHistoryModel
    with RealmEntity, RealmObjectBase, RealmObject {
  ProductHistoryModel(
    ObjectId? id, {
    Product? product,
    ObjectId? stockTransferHistory,
    String? type,
    int? quantity,
    String? shop,
    String? supplier,
    Shop? toShop,
    CustomerModel? customer,
    DateTime? createdAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'product', product);
    RealmObjectBase.set(this, 'stockTransferHistory', stockTransferHistory);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'supplier', supplier);
    RealmObjectBase.set(this, 'toShop', toShop);
    RealmObjectBase.set(this, 'customer', customer);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  ProductHistoryModel._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  Product? get product =>
      RealmObjectBase.get<Product>(this, 'product') as Product?;
  @override
  set product(covariant Product? value) =>
      RealmObjectBase.set(this, 'product', value);

  @override
  ObjectId? get stockTransferHistory =>
      RealmObjectBase.get<ObjectId>(this, 'stockTransferHistory') as ObjectId?;
  @override
  set stockTransferHistory(ObjectId? value) =>
      RealmObjectBase.set(this, 'stockTransferHistory', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  int? get quantity => RealmObjectBase.get<int>(this, 'quantity') as int?;
  @override
  set quantity(int? value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  String? get shop => RealmObjectBase.get<String>(this, 'shop') as String?;
  @override
  set shop(String? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  String? get supplier =>
      RealmObjectBase.get<String>(this, 'supplier') as String?;
  @override
  set supplier(String? value) => RealmObjectBase.set(this, 'supplier', value);

  @override
  Shop? get toShop => RealmObjectBase.get<Shop>(this, 'toShop') as Shop?;
  @override
  set toShop(covariant Shop? value) =>
      RealmObjectBase.set(this, 'toShop', value);

  @override
  CustomerModel? get customer =>
      RealmObjectBase.get<CustomerModel>(this, 'customer') as CustomerModel?;
  @override
  set customer(covariant CustomerModel? value) =>
      RealmObjectBase.set(this, 'customer', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<ProductHistoryModel>> get changes =>
      RealmObjectBase.getChanges<ProductHistoryModel>(this);

  @override
  ProductHistoryModel freeze() =>
      RealmObjectBase.freezeObject<ProductHistoryModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ProductHistoryModel._);
    return const SchemaObject(
        ObjectType.realmObject, ProductHistoryModel, 'ProductHistoryModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('product', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
      SchemaProperty('stockTransferHistory', RealmPropertyType.objectid,
          optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('quantity', RealmPropertyType.int, optional: true),
      SchemaProperty('shop', RealmPropertyType.string, optional: true),
      SchemaProperty('supplier', RealmPropertyType.string, optional: true),
      SchemaProperty('toShop', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('customer', RealmPropertyType.object,
          optional: true, linkTarget: 'CustomerModel'),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class PurchaseReturn extends _PurchaseReturn
    with RealmEntity, RealmObjectBase, RealmObject {
  PurchaseReturn({
    InvoiceItem? saleOrderItemModel,
    UserModel? attendant,
    Supplier? supplier,
    int? count,
    Product? productModel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, 'saleOrderItemModel', saleOrderItemModel);
    RealmObjectBase.set(this, 'attendant', attendant);
    RealmObjectBase.set(this, 'supplier', supplier);
    RealmObjectBase.set(this, 'count', count);
    RealmObjectBase.set(this, 'productModel', productModel);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  PurchaseReturn._();

  @override
  InvoiceItem? get saleOrderItemModel =>
      RealmObjectBase.get<InvoiceItem>(this, 'saleOrderItemModel')
          as InvoiceItem?;
  @override
  set saleOrderItemModel(covariant InvoiceItem? value) =>
      RealmObjectBase.set(this, 'saleOrderItemModel', value);

  @override
  UserModel? get attendant =>
      RealmObjectBase.get<UserModel>(this, 'attendant') as UserModel?;
  @override
  set attendant(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendant', value);

  @override
  Supplier? get supplier =>
      RealmObjectBase.get<Supplier>(this, 'supplier') as Supplier?;
  @override
  set supplier(covariant Supplier? value) =>
      RealmObjectBase.set(this, 'supplier', value);

  @override
  int? get count => RealmObjectBase.get<int>(this, 'count') as int?;
  @override
  set count(int? value) => RealmObjectBase.set(this, 'count', value);

  @override
  Product? get productModel =>
      RealmObjectBase.get<Product>(this, 'productModel') as Product?;
  @override
  set productModel(covariant Product? value) =>
      RealmObjectBase.set(this, 'productModel', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<PurchaseReturn>> get changes =>
      RealmObjectBase.getChanges<PurchaseReturn>(this);

  @override
  PurchaseReturn freeze() => RealmObjectBase.freezeObject<PurchaseReturn>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(PurchaseReturn._);
    return const SchemaObject(
        ObjectType.realmObject, PurchaseReturn, 'PurchaseReturn', [
      SchemaProperty('saleOrderItemModel', RealmPropertyType.object,
          optional: true, linkTarget: 'InvoiceItem'),
      SchemaProperty('attendant', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('supplier', RealmPropertyType.object,
          optional: true, linkTarget: 'Supplier'),
      SchemaProperty('count', RealmPropertyType.int, optional: true),
      SchemaProperty('productModel', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class SalesModel extends _SalesModel
    with RealmEntity, RealmObjectBase, RealmObject {
  SalesModel(
    ObjectId? id, {
    String? receiptNumber,
    Shop? shop,
    UserModel? attendantId,
    CustomerModel? customerId,
    int? grandTotal,
    int? creditTotal,
    int? returnsCount,
    int? totalDiscount,
    int? quantity,
    String? paymentMethod,
    int? dated,
    String? date,
    String? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Iterable<ReceiptItem> items = const [],
    Iterable<ReceiptItem> returneditems = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'receiptNumber', receiptNumber);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'attendantId', attendantId);
    RealmObjectBase.set(this, 'customerId', customerId);
    RealmObjectBase.set(this, 'grandTotal', grandTotal);
    RealmObjectBase.set(this, 'creditTotal', creditTotal);
    RealmObjectBase.set(this, 'returnsCount', returnsCount);
    RealmObjectBase.set(this, 'totalDiscount', totalDiscount);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'paymentMethod', paymentMethod);
    RealmObjectBase.set(this, 'dated', dated);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'dueDate', dueDate);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set<RealmList<ReceiptItem>>(
        this, 'items', RealmList<ReceiptItem>(items));
    RealmObjectBase.set<RealmList<ReceiptItem>>(
        this, 'returneditems', RealmList<ReceiptItem>(returneditems));
  }

  SalesModel._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get receiptNumber =>
      RealmObjectBase.get<String>(this, 'receiptNumber') as String?;
  @override
  set receiptNumber(String? value) =>
      RealmObjectBase.set(this, 'receiptNumber', value);

  @override
  Shop? get shop => RealmObjectBase.get<Shop>(this, 'shop') as Shop?;
  @override
  set shop(covariant Shop? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  UserModel? get attendantId =>
      RealmObjectBase.get<UserModel>(this, 'attendantId') as UserModel?;
  @override
  set attendantId(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendantId', value);

  @override
  CustomerModel? get customerId =>
      RealmObjectBase.get<CustomerModel>(this, 'customerId') as CustomerModel?;
  @override
  set customerId(covariant CustomerModel? value) =>
      RealmObjectBase.set(this, 'customerId', value);

  @override
  int? get grandTotal => RealmObjectBase.get<int>(this, 'grandTotal') as int?;
  @override
  set grandTotal(int? value) => RealmObjectBase.set(this, 'grandTotal', value);

  @override
  int? get creditTotal => RealmObjectBase.get<int>(this, 'creditTotal') as int?;
  @override
  set creditTotal(int? value) =>
      RealmObjectBase.set(this, 'creditTotal', value);

  @override
  int? get returnsCount =>
      RealmObjectBase.get<int>(this, 'returnsCount') as int?;
  @override
  set returnsCount(int? value) =>
      RealmObjectBase.set(this, 'returnsCount', value);

  @override
  RealmList<ReceiptItem> get items =>
      RealmObjectBase.get<ReceiptItem>(this, 'items') as RealmList<ReceiptItem>;
  @override
  set items(covariant RealmList<ReceiptItem> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<ReceiptItem> get returneditems =>
      RealmObjectBase.get<ReceiptItem>(this, 'returneditems')
          as RealmList<ReceiptItem>;
  @override
  set returneditems(covariant RealmList<ReceiptItem> value) =>
      throw RealmUnsupportedSetError();

  @override
  int? get totalDiscount =>
      RealmObjectBase.get<int>(this, 'totalDiscount') as int?;
  @override
  set totalDiscount(int? value) =>
      RealmObjectBase.set(this, 'totalDiscount', value);

  @override
  int? get quantity => RealmObjectBase.get<int>(this, 'quantity') as int?;
  @override
  set quantity(int? value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  String? get paymentMethod =>
      RealmObjectBase.get<String>(this, 'paymentMethod') as String?;
  @override
  set paymentMethod(String? value) =>
      RealmObjectBase.set(this, 'paymentMethod', value);

  @override
  int? get dated => RealmObjectBase.get<int>(this, 'dated') as int?;
  @override
  set dated(int? value) => RealmObjectBase.set(this, 'dated', value);

  @override
  String? get date => RealmObjectBase.get<String>(this, 'date') as String?;
  @override
  set date(String? value) => RealmObjectBase.set(this, 'date', value);

  @override
  String? get dueDate =>
      RealmObjectBase.get<String>(this, 'dueDate') as String?;
  @override
  set dueDate(String? value) => RealmObjectBase.set(this, 'dueDate', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<SalesModel>> get changes =>
      RealmObjectBase.getChanges<SalesModel>(this);

  @override
  SalesModel freeze() => RealmObjectBase.freezeObject<SalesModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(SalesModel._);
    return const SchemaObject(
        ObjectType.realmObject, SalesModel, 'SalesModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('receiptNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('shop', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('attendantId', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('customerId', RealmPropertyType.object,
          optional: true, linkTarget: 'CustomerModel'),
      SchemaProperty('grandTotal', RealmPropertyType.int, optional: true),
      SchemaProperty('creditTotal', RealmPropertyType.int, optional: true),
      SchemaProperty('returnsCount', RealmPropertyType.int, optional: true),
      SchemaProperty('items', RealmPropertyType.object,
          linkTarget: 'ReceiptItem', collectionType: RealmCollectionType.list),
      SchemaProperty('returneditems', RealmPropertyType.object,
          linkTarget: 'ReceiptItem', collectionType: RealmCollectionType.list),
      SchemaProperty('totalDiscount', RealmPropertyType.int, optional: true),
      SchemaProperty('quantity', RealmPropertyType.int, optional: true),
      SchemaProperty('paymentMethod', RealmPropertyType.string, optional: true),
      SchemaProperty('dated', RealmPropertyType.int, optional: true),
      SchemaProperty('date', RealmPropertyType.string, optional: true),
      SchemaProperty('dueDate', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class ReceiptItem extends _ReceiptItem
    with RealmEntity, RealmObjectBase, RealmObject {
  ReceiptItem(
    ObjectId? id, {
    Product? product,
    SalesModel? receipt,
    CustomerModel? customerId,
    int? quantity,
    Shop? shop,
    String? type,
    String? date,
    int? soldOn,
    int? total,
    int? discount,
    int? price,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'product', product);
    RealmObjectBase.set(this, 'receipt', receipt);
    RealmObjectBase.set(this, 'customerId', customerId);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'soldOn', soldOn);
    RealmObjectBase.set(this, 'total', total);
    RealmObjectBase.set(this, 'discount', discount);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  ReceiptItem._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  Product? get product =>
      RealmObjectBase.get<Product>(this, 'product') as Product?;
  @override
  set product(covariant Product? value) =>
      RealmObjectBase.set(this, 'product', value);

  @override
  SalesModel? get receipt =>
      RealmObjectBase.get<SalesModel>(this, 'receipt') as SalesModel?;
  @override
  set receipt(covariant SalesModel? value) =>
      RealmObjectBase.set(this, 'receipt', value);

  @override
  CustomerModel? get customerId =>
      RealmObjectBase.get<CustomerModel>(this, 'customerId') as CustomerModel?;
  @override
  set customerId(covariant CustomerModel? value) =>
      RealmObjectBase.set(this, 'customerId', value);

  @override
  int? get quantity => RealmObjectBase.get<int>(this, 'quantity') as int?;
  @override
  set quantity(int? value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  Shop? get shop => RealmObjectBase.get<Shop>(this, 'shop') as Shop?;
  @override
  set shop(covariant Shop? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get date => RealmObjectBase.get<String>(this, 'date') as String?;
  @override
  set date(String? value) => RealmObjectBase.set(this, 'date', value);

  @override
  int? get soldOn => RealmObjectBase.get<int>(this, 'soldOn') as int?;
  @override
  set soldOn(int? value) => RealmObjectBase.set(this, 'soldOn', value);

  @override
  int? get total => RealmObjectBase.get<int>(this, 'total') as int?;
  @override
  set total(int? value) => RealmObjectBase.set(this, 'total', value);

  @override
  int? get discount => RealmObjectBase.get<int>(this, 'discount') as int?;
  @override
  set discount(int? value) => RealmObjectBase.set(this, 'discount', value);

  @override
  int? get price => RealmObjectBase.get<int>(this, 'price') as int?;
  @override
  set price(int? value) => RealmObjectBase.set(this, 'price', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<ReceiptItem>> get changes =>
      RealmObjectBase.getChanges<ReceiptItem>(this);

  @override
  ReceiptItem freeze() => RealmObjectBase.freezeObject<ReceiptItem>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ReceiptItem._);
    return const SchemaObject(
        ObjectType.realmObject, ReceiptItem, 'ReceiptItem', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('product', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
      SchemaProperty('receipt', RealmPropertyType.object,
          optional: true, linkTarget: 'SalesModel'),
      SchemaProperty('customerId', RealmPropertyType.object,
          optional: true, linkTarget: 'CustomerModel'),
      SchemaProperty('quantity', RealmPropertyType.int, optional: true),
      SchemaProperty('shop', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('date', RealmPropertyType.string, optional: true),
      SchemaProperty('soldOn', RealmPropertyType.int, optional: true),
      SchemaProperty('total', RealmPropertyType.int, optional: true),
      SchemaProperty('discount', RealmPropertyType.int, optional: true),
      SchemaProperty('price', RealmPropertyType.int, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class SalesReturn extends _SalesReturn
    with RealmEntity, RealmObjectBase, RealmObject {
  SalesReturn(
    ObjectId? id, {
    ReceiptItem? receiptItem,
    SalesModel? sale,
    UserModel? attendant,
    int? count,
    Product? productModel,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'receiptItem', receiptItem);
    RealmObjectBase.set(this, 'sale', sale);
    RealmObjectBase.set(this, 'attendant', attendant);
    RealmObjectBase.set(this, 'count', count);
    RealmObjectBase.set(this, 'productModel', productModel);
  }

  SalesReturn._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  ReceiptItem? get receiptItem =>
      RealmObjectBase.get<ReceiptItem>(this, 'receiptItem') as ReceiptItem?;
  @override
  set receiptItem(covariant ReceiptItem? value) =>
      RealmObjectBase.set(this, 'receiptItem', value);

  @override
  SalesModel? get sale =>
      RealmObjectBase.get<SalesModel>(this, 'sale') as SalesModel?;
  @override
  set sale(covariant SalesModel? value) =>
      RealmObjectBase.set(this, 'sale', value);

  @override
  UserModel? get attendant =>
      RealmObjectBase.get<UserModel>(this, 'attendant') as UserModel?;
  @override
  set attendant(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendant', value);

  @override
  int? get count => RealmObjectBase.get<int>(this, 'count') as int?;
  @override
  set count(int? value) => RealmObjectBase.set(this, 'count', value);

  @override
  Product? get productModel =>
      RealmObjectBase.get<Product>(this, 'productModel') as Product?;
  @override
  set productModel(covariant Product? value) =>
      RealmObjectBase.set(this, 'productModel', value);

  @override
  Stream<RealmObjectChanges<SalesReturn>> get changes =>
      RealmObjectBase.getChanges<SalesReturn>(this);

  @override
  SalesReturn freeze() => RealmObjectBase.freezeObject<SalesReturn>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(SalesReturn._);
    return const SchemaObject(
        ObjectType.realmObject, SalesReturn, 'SalesReturn', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('receiptItem', RealmPropertyType.object,
          optional: true, linkTarget: 'ReceiptItem'),
      SchemaProperty('sale', RealmPropertyType.object,
          optional: true, linkTarget: 'SalesModel'),
      SchemaProperty('attendant', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('count', RealmPropertyType.int, optional: true),
      SchemaProperty('productModel', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
    ]);
  }
}

class SalesSummary extends _SalesSummary
    with RealmEntity, RealmObjectBase, RealmObject {
  SalesSummary({
    int? grossProfit,
    int? totalExpense,
    int? sales,
    int? profitOnSales,
    int? badStockValue,
  }) {
    RealmObjectBase.set(this, 'grossProfit', grossProfit);
    RealmObjectBase.set(this, 'totalExpense', totalExpense);
    RealmObjectBase.set(this, 'sales', sales);
    RealmObjectBase.set(this, 'profitOnSales', profitOnSales);
    RealmObjectBase.set(this, 'badStockValue', badStockValue);
  }

  SalesSummary._();

  @override
  int? get grossProfit => RealmObjectBase.get<int>(this, 'grossProfit') as int?;
  @override
  set grossProfit(int? value) =>
      RealmObjectBase.set(this, 'grossProfit', value);

  @override
  int? get totalExpense =>
      RealmObjectBase.get<int>(this, 'totalExpense') as int?;
  @override
  set totalExpense(int? value) =>
      RealmObjectBase.set(this, 'totalExpense', value);

  @override
  int? get sales => RealmObjectBase.get<int>(this, 'sales') as int?;
  @override
  set sales(int? value) => RealmObjectBase.set(this, 'sales', value);

  @override
  int? get profitOnSales =>
      RealmObjectBase.get<int>(this, 'profitOnSales') as int?;
  @override
  set profitOnSales(int? value) =>
      RealmObjectBase.set(this, 'profitOnSales', value);

  @override
  int? get badStockValue =>
      RealmObjectBase.get<int>(this, 'badStockValue') as int?;
  @override
  set badStockValue(int? value) =>
      RealmObjectBase.set(this, 'badStockValue', value);

  @override
  Stream<RealmObjectChanges<SalesSummary>> get changes =>
      RealmObjectBase.getChanges<SalesSummary>(this);

  @override
  SalesSummary freeze() => RealmObjectBase.freezeObject<SalesSummary>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(SalesSummary._);
    return const SchemaObject(
        ObjectType.realmObject, SalesSummary, 'SalesSummary', [
      SchemaProperty('grossProfit', RealmPropertyType.int, optional: true),
      SchemaProperty('totalExpense', RealmPropertyType.int, optional: true),
      SchemaProperty('sales', RealmPropertyType.int, optional: true),
      SchemaProperty('profitOnSales', RealmPropertyType.int, optional: true),
      SchemaProperty('badStockValue', RealmPropertyType.int, optional: true),
    ]);
  }
}

class StockInCredit extends _StockInCredit
    with RealmEntity, RealmObjectBase, RealmObject {
  StockInCredit(
    ObjectId? id, {
    String? supplier,
    String? shop,
    String? attendant,
    int? balance,
    int? total,
    String? recietNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'supplier', supplier);
    RealmObjectBase.set(this, 'shop', shop);
    RealmObjectBase.set(this, 'attendant', attendant);
    RealmObjectBase.set(this, 'balance', balance);
    RealmObjectBase.set(this, 'total', total);
    RealmObjectBase.set(this, 'recietNumber', recietNumber);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  StockInCredit._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get supplier =>
      RealmObjectBase.get<String>(this, 'supplier') as String?;
  @override
  set supplier(String? value) => RealmObjectBase.set(this, 'supplier', value);

  @override
  String? get shop => RealmObjectBase.get<String>(this, 'shop') as String?;
  @override
  set shop(String? value) => RealmObjectBase.set(this, 'shop', value);

  @override
  String? get attendant =>
      RealmObjectBase.get<String>(this, 'attendant') as String?;
  @override
  set attendant(String? value) => RealmObjectBase.set(this, 'attendant', value);

  @override
  int? get balance => RealmObjectBase.get<int>(this, 'balance') as int?;
  @override
  set balance(int? value) => RealmObjectBase.set(this, 'balance', value);

  @override
  int? get total => RealmObjectBase.get<int>(this, 'total') as int?;
  @override
  set total(int? value) => RealmObjectBase.set(this, 'total', value);

  @override
  String? get recietNumber =>
      RealmObjectBase.get<String>(this, 'recietNumber') as String?;
  @override
  set recietNumber(String? value) =>
      RealmObjectBase.set(this, 'recietNumber', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<StockInCredit>> get changes =>
      RealmObjectBase.getChanges<StockInCredit>(this);

  @override
  StockInCredit freeze() => RealmObjectBase.freezeObject<StockInCredit>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(StockInCredit._);
    return const SchemaObject(
        ObjectType.realmObject, StockInCredit, 'StockInCredit', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('supplier', RealmPropertyType.string, optional: true),
      SchemaProperty('shop', RealmPropertyType.string, optional: true),
      SchemaProperty('attendant', RealmPropertyType.string, optional: true),
      SchemaProperty('balance', RealmPropertyType.int, optional: true),
      SchemaProperty('total', RealmPropertyType.int, optional: true),
      SchemaProperty('recietNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}

class StockTransferHistory extends _StockTransferHistory
    with RealmEntity, RealmObjectBase, RealmObject {
  StockTransferHistory(
    ObjectId? id, {
    Shop? from,
    UserModel? attendant,
    Shop? to,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    Iterable<String> product = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'from', from);
    RealmObjectBase.set(this, 'attendant', attendant);
    RealmObjectBase.set(this, 'to', to);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set<RealmList<String>>(
        this, 'product', RealmList<String>(product));
  }

  StockTransferHistory._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  Shop? get from => RealmObjectBase.get<Shop>(this, 'from') as Shop?;
  @override
  set from(covariant Shop? value) => RealmObjectBase.set(this, 'from', value);

  @override
  UserModel? get attendant =>
      RealmObjectBase.get<UserModel>(this, 'attendant') as UserModel?;
  @override
  set attendant(covariant UserModel? value) =>
      RealmObjectBase.set(this, 'attendant', value);

  @override
  Shop? get to => RealmObjectBase.get<Shop>(this, 'to') as Shop?;
  @override
  set to(covariant Shop? value) => RealmObjectBase.set(this, 'to', value);

  @override
  RealmList<String> get product =>
      RealmObjectBase.get<String>(this, 'product') as RealmList<String>;
  @override
  set product(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<StockTransferHistory>> get changes =>
      RealmObjectBase.getChanges<StockTransferHistory>(this);

  @override
  StockTransferHistory freeze() =>
      RealmObjectBase.freezeObject<StockTransferHistory>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(StockTransferHistory._);
    return const SchemaObject(
        ObjectType.realmObject, StockTransferHistory, 'StockTransferHistory', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('from', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('attendant', RealmPropertyType.object,
          optional: true, linkTarget: 'UserModel'),
      SchemaProperty('to', RealmPropertyType.object,
          optional: true, linkTarget: 'Shop'),
      SchemaProperty('product', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}
