// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OwnedProductsTable extends OwnedProducts
    with TableInfo<$OwnedProductsTable, OwnedProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnedProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interestRateMeta = const VerificationMeta(
    'interestRate',
  );
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
    'interest_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    amount,
    balance,
    interestRate,
    startDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'owned_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<OwnedProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
        _interestRateMeta,
        interestRate.isAcceptableOrUnknown(
          data['interest_rate']!,
          _interestRateMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OwnedProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnedProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      ),
      interestRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}interest_rate'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
    );
  }

  @override
  $OwnedProductsTable createAlias(String alias) {
    return $OwnedProductsTable(attachedDatabase, alias);
  }
}

class OwnedProduct extends DataClass implements Insertable<OwnedProduct> {
  final int id;
  final String name;
  final String type;
  final double? amount;
  final double? balance;
  final double? interestRate;
  final DateTime startDate;
  const OwnedProduct({
    required this.id,
    required this.name,
    required this.type,
    this.amount,
    this.balance,
    this.interestRate,
    required this.startDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || balance != null) {
      map['balance'] = Variable<double>(balance);
    }
    if (!nullToAbsent || interestRate != null) {
      map['interest_rate'] = Variable<double>(interestRate);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    return map;
  }

  OwnedProductsCompanion toCompanion(bool nullToAbsent) {
    return OwnedProductsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      balance: balance == null && nullToAbsent
          ? const Value.absent()
          : Value(balance),
      interestRate: interestRate == null && nullToAbsent
          ? const Value.absent()
          : Value(interestRate),
      startDate: Value(startDate),
    );
  }

  factory OwnedProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OwnedProduct(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double?>(json['amount']),
      balance: serializer.fromJson<double?>(json['balance']),
      interestRate: serializer.fromJson<double?>(json['interestRate']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double?>(amount),
      'balance': serializer.toJson<double?>(balance),
      'interestRate': serializer.toJson<double?>(interestRate),
      'startDate': serializer.toJson<DateTime>(startDate),
    };
  }

  OwnedProduct copyWith({
    int? id,
    String? name,
    String? type,
    Value<double?> amount = const Value.absent(),
    Value<double?> balance = const Value.absent(),
    Value<double?> interestRate = const Value.absent(),
    DateTime? startDate,
  }) => OwnedProduct(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    amount: amount.present ? amount.value : this.amount,
    balance: balance.present ? balance.value : this.balance,
    interestRate: interestRate.present ? interestRate.value : this.interestRate,
    startDate: startDate ?? this.startDate,
  );
  OwnedProduct copyWithCompanion(OwnedProductsCompanion data) {
    return OwnedProduct(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      balance: data.balance.present ? data.balance.value : this.balance,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OwnedProduct(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('balance: $balance, ')
          ..write('interestRate: $interestRate, ')
          ..write('startDate: $startDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, type, amount, balance, interestRate, startDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnedProduct &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.balance == this.balance &&
          other.interestRate == this.interestRate &&
          other.startDate == this.startDate);
}

class OwnedProductsCompanion extends UpdateCompanion<OwnedProduct> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<double?> amount;
  final Value<double?> balance;
  final Value<double?> interestRate;
  final Value<DateTime> startDate;
  const OwnedProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.balance = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.startDate = const Value.absent(),
  });
  OwnedProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.amount = const Value.absent(),
    this.balance = const Value.absent(),
    this.interestRate = const Value.absent(),
    required DateTime startDate,
  }) : name = Value(name),
       type = Value(type),
       startDate = Value(startDate);
  static Insertable<OwnedProduct> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<double>? balance,
    Expression<double>? interestRate,
    Expression<DateTime>? startDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (balance != null) 'balance': balance,
      if (interestRate != null) 'interest_rate': interestRate,
      if (startDate != null) 'start_date': startDate,
    });
  }

  OwnedProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<double?>? amount,
    Value<double?>? balance,
    Value<double?>? interestRate,
    Value<DateTime>? startDate,
  }) {
    return OwnedProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      balance: balance ?? this.balance,
      interestRate: interestRate ?? this.interestRate,
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnedProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('balance: $balance, ')
          ..write('interestRate: $interestRate, ')
          ..write('startDate: $startDate')
          ..write(')'))
        .toString();
  }
}

class $LifeEventsTable extends LifeEvents
    with TableInfo<$LifeEventsTable, LifeEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LifeEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FinancialEventType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FinancialEventType>($LifeEventsTable.$convertertype);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<TodoItem>, String>
  selectedTodos = GeneratedColumn<String>(
    'selected_todos',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<TodoItem>>($LifeEventsTable.$converterselectedTodos);
  @override
  late final GeneratedColumnWithTypeConverter<List<Guide>, String> guides =
      GeneratedColumn<String>(
        'guides',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<Guide>>($LifeEventsTable.$converterguides);
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<double> budget = GeneratedColumn<double>(
    'budget',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _depositAmountMeta = const VerificationMeta(
    'depositAmount',
  );
  @override
  late final GeneratedColumn<double> depositAmount = GeneratedColumn<double>(
    'deposit_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    type,
    date,
    location,
    selectedTodos,
    guides,
    budget,
    depositAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'life_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<LifeEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('budget')) {
      context.handle(
        _budgetMeta,
        budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta),
      );
    }
    if (data.containsKey('deposit_amount')) {
      context.handle(
        _depositAmountMeta,
        depositAmount.isAcceptableOrUnknown(
          data['deposit_amount']!,
          _depositAmountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LifeEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LifeEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: $LifeEventsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      selectedTodos: $LifeEventsTable.$converterselectedTodos.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}selected_todos'],
        )!,
      ),
      guides: $LifeEventsTable.$converterguides.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}guides'],
        )!,
      ),
      budget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}budget'],
      ),
      depositAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}deposit_amount'],
      ),
    );
  }

  @override
  $LifeEventsTable createAlias(String alias) {
    return $LifeEventsTable(attachedDatabase, alias);
  }

  static TypeConverter<FinancialEventType, String> $convertertype =
      const FinancialEventTypeConverter();
  static TypeConverter<List<TodoItem>, String> $converterselectedTodos =
      const ListTodoConverter();
  static TypeConverter<List<Guide>, String> $converterguides =
      const ListGuideConverter();
}

class LifeEvent extends DataClass implements Insertable<LifeEvent> {
  final String id;
  final String title;
  final FinancialEventType type;
  final DateTime date;
  final String location;
  final List<TodoItem> selectedTodos;
  final List<Guide> guides;
  final double? budget;
  final double? depositAmount;
  const LifeEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.location,
    required this.selectedTodos,
    required this.guides,
    this.budget,
    this.depositAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    {
      map['type'] = Variable<String>(
        $LifeEventsTable.$convertertype.toSql(type),
      );
    }
    map['date'] = Variable<DateTime>(date);
    map['location'] = Variable<String>(location);
    {
      map['selected_todos'] = Variable<String>(
        $LifeEventsTable.$converterselectedTodos.toSql(selectedTodos),
      );
    }
    {
      map['guides'] = Variable<String>(
        $LifeEventsTable.$converterguides.toSql(guides),
      );
    }
    if (!nullToAbsent || budget != null) {
      map['budget'] = Variable<double>(budget);
    }
    if (!nullToAbsent || depositAmount != null) {
      map['deposit_amount'] = Variable<double>(depositAmount);
    }
    return map;
  }

  LifeEventsCompanion toCompanion(bool nullToAbsent) {
    return LifeEventsCompanion(
      id: Value(id),
      title: Value(title),
      type: Value(type),
      date: Value(date),
      location: Value(location),
      selectedTodos: Value(selectedTodos),
      guides: Value(guides),
      budget: budget == null && nullToAbsent
          ? const Value.absent()
          : Value(budget),
      depositAmount: depositAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(depositAmount),
    );
  }

  factory LifeEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LifeEvent(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<FinancialEventType>(json['type']),
      date: serializer.fromJson<DateTime>(json['date']),
      location: serializer.fromJson<String>(json['location']),
      selectedTodos: serializer.fromJson<List<TodoItem>>(json['selectedTodos']),
      guides: serializer.fromJson<List<Guide>>(json['guides']),
      budget: serializer.fromJson<double?>(json['budget']),
      depositAmount: serializer.fromJson<double?>(json['depositAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<FinancialEventType>(type),
      'date': serializer.toJson<DateTime>(date),
      'location': serializer.toJson<String>(location),
      'selectedTodos': serializer.toJson<List<TodoItem>>(selectedTodos),
      'guides': serializer.toJson<List<Guide>>(guides),
      'budget': serializer.toJson<double?>(budget),
      'depositAmount': serializer.toJson<double?>(depositAmount),
    };
  }

  LifeEvent copyWith({
    String? id,
    String? title,
    FinancialEventType? type,
    DateTime? date,
    String? location,
    List<TodoItem>? selectedTodos,
    List<Guide>? guides,
    Value<double?> budget = const Value.absent(),
    Value<double?> depositAmount = const Value.absent(),
  }) => LifeEvent(
    id: id ?? this.id,
    title: title ?? this.title,
    type: type ?? this.type,
    date: date ?? this.date,
    location: location ?? this.location,
    selectedTodos: selectedTodos ?? this.selectedTodos,
    guides: guides ?? this.guides,
    budget: budget.present ? budget.value : this.budget,
    depositAmount: depositAmount.present
        ? depositAmount.value
        : this.depositAmount,
  );
  LifeEvent copyWithCompanion(LifeEventsCompanion data) {
    return LifeEvent(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      location: data.location.present ? data.location.value : this.location,
      selectedTodos: data.selectedTodos.present
          ? data.selectedTodos.value
          : this.selectedTodos,
      guides: data.guides.present ? data.guides.value : this.guides,
      budget: data.budget.present ? data.budget.value : this.budget,
      depositAmount: data.depositAmount.present
          ? data.depositAmount.value
          : this.depositAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LifeEvent(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('location: $location, ')
          ..write('selectedTodos: $selectedTodos, ')
          ..write('guides: $guides, ')
          ..write('budget: $budget, ')
          ..write('depositAmount: $depositAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    type,
    date,
    location,
    selectedTodos,
    guides,
    budget,
    depositAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LifeEvent &&
          other.id == this.id &&
          other.title == this.title &&
          other.type == this.type &&
          other.date == this.date &&
          other.location == this.location &&
          other.selectedTodos == this.selectedTodos &&
          other.guides == this.guides &&
          other.budget == this.budget &&
          other.depositAmount == this.depositAmount);
}

class LifeEventsCompanion extends UpdateCompanion<LifeEvent> {
  final Value<String> id;
  final Value<String> title;
  final Value<FinancialEventType> type;
  final Value<DateTime> date;
  final Value<String> location;
  final Value<List<TodoItem>> selectedTodos;
  final Value<List<Guide>> guides;
  final Value<double?> budget;
  final Value<double?> depositAmount;
  final Value<int> rowid;
  const LifeEventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.location = const Value.absent(),
    this.selectedTodos = const Value.absent(),
    this.guides = const Value.absent(),
    this.budget = const Value.absent(),
    this.depositAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LifeEventsCompanion.insert({
    required String id,
    required String title,
    required FinancialEventType type,
    required DateTime date,
    required String location,
    required List<TodoItem> selectedTodos,
    required List<Guide> guides,
    this.budget = const Value.absent(),
    this.depositAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       type = Value(type),
       date = Value(date),
       location = Value(location),
       selectedTodos = Value(selectedTodos),
       guides = Value(guides);
  static Insertable<LifeEvent> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? type,
    Expression<DateTime>? date,
    Expression<String>? location,
    Expression<String>? selectedTodos,
    Expression<String>? guides,
    Expression<double>? budget,
    Expression<double>? depositAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (location != null) 'location': location,
      if (selectedTodos != null) 'selected_todos': selectedTodos,
      if (guides != null) 'guides': guides,
      if (budget != null) 'budget': budget,
      if (depositAmount != null) 'deposit_amount': depositAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LifeEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<FinancialEventType>? type,
    Value<DateTime>? date,
    Value<String>? location,
    Value<List<TodoItem>>? selectedTodos,
    Value<List<Guide>>? guides,
    Value<double?>? budget,
    Value<double?>? depositAmount,
    Value<int>? rowid,
  }) {
    return LifeEventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      location: location ?? this.location,
      selectedTodos: selectedTodos ?? this.selectedTodos,
      guides: guides ?? this.guides,
      budget: budget ?? this.budget,
      depositAmount: depositAmount ?? this.depositAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $LifeEventsTable.$convertertype.toSql(type.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (selectedTodos.present) {
      map['selected_todos'] = Variable<String>(
        $LifeEventsTable.$converterselectedTodos.toSql(selectedTodos.value),
      );
    }
    if (guides.present) {
      map['guides'] = Variable<String>(
        $LifeEventsTable.$converterguides.toSql(guides.value),
      );
    }
    if (budget.present) {
      map['budget'] = Variable<double>(budget.value);
    }
    if (depositAmount.present) {
      map['deposit_amount'] = Variable<double>(depositAmount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LifeEventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('location: $location, ')
          ..write('selectedTodos: $selectedTodos, ')
          ..write('guides: $guides, ')
          ..write('budget: $budget, ')
          ..write('depositAmount: $depositAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OwnedProductsTable ownedProducts = $OwnedProductsTable(this);
  late final $LifeEventsTable lifeEvents = $LifeEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    ownedProducts,
    lifeEvents,
  ];
}

typedef $$OwnedProductsTableCreateCompanionBuilder =
    OwnedProductsCompanion Function({
      Value<int> id,
      required String name,
      required String type,
      Value<double?> amount,
      Value<double?> balance,
      Value<double?> interestRate,
      required DateTime startDate,
    });
typedef $$OwnedProductsTableUpdateCompanionBuilder =
    OwnedProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<double?> amount,
      Value<double?> balance,
      Value<double?> interestRate,
      Value<DateTime> startDate,
    });

class $$OwnedProductsTableFilterComposer
    extends Composer<_$AppDatabase, $OwnedProductsTable> {
  $$OwnedProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OwnedProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnedProductsTable> {
  $$OwnedProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnedProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnedProductsTable> {
  $$OwnedProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);
}

class $$OwnedProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnedProductsTable,
          OwnedProduct,
          $$OwnedProductsTableFilterComposer,
          $$OwnedProductsTableOrderingComposer,
          $$OwnedProductsTableAnnotationComposer,
          $$OwnedProductsTableCreateCompanionBuilder,
          $$OwnedProductsTableUpdateCompanionBuilder,
          (
            OwnedProduct,
            BaseReferences<_$AppDatabase, $OwnedProductsTable, OwnedProduct>,
          ),
          OwnedProduct,
          PrefetchHooks Function()
        > {
  $$OwnedProductsTableTableManager(_$AppDatabase db, $OwnedProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OwnedProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OwnedProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OwnedProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<double?> balance = const Value.absent(),
                Value<double?> interestRate = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
              }) => OwnedProductsCompanion(
                id: id,
                name: name,
                type: type,
                amount: amount,
                balance: balance,
                interestRate: interestRate,
                startDate: startDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String type,
                Value<double?> amount = const Value.absent(),
                Value<double?> balance = const Value.absent(),
                Value<double?> interestRate = const Value.absent(),
                required DateTime startDate,
              }) => OwnedProductsCompanion.insert(
                id: id,
                name: name,
                type: type,
                amount: amount,
                balance: balance,
                interestRate: interestRate,
                startDate: startDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OwnedProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnedProductsTable,
      OwnedProduct,
      $$OwnedProductsTableFilterComposer,
      $$OwnedProductsTableOrderingComposer,
      $$OwnedProductsTableAnnotationComposer,
      $$OwnedProductsTableCreateCompanionBuilder,
      $$OwnedProductsTableUpdateCompanionBuilder,
      (
        OwnedProduct,
        BaseReferences<_$AppDatabase, $OwnedProductsTable, OwnedProduct>,
      ),
      OwnedProduct,
      PrefetchHooks Function()
    >;
typedef $$LifeEventsTableCreateCompanionBuilder =
    LifeEventsCompanion Function({
      required String id,
      required String title,
      required FinancialEventType type,
      required DateTime date,
      required String location,
      required List<TodoItem> selectedTodos,
      required List<Guide> guides,
      Value<double?> budget,
      Value<double?> depositAmount,
      Value<int> rowid,
    });
typedef $$LifeEventsTableUpdateCompanionBuilder =
    LifeEventsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<FinancialEventType> type,
      Value<DateTime> date,
      Value<String> location,
      Value<List<TodoItem>> selectedTodos,
      Value<List<Guide>> guides,
      Value<double?> budget,
      Value<double?> depositAmount,
      Value<int> rowid,
    });

class $$LifeEventsTableFilterComposer
    extends Composer<_$AppDatabase, $LifeEventsTable> {
  $$LifeEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FinancialEventType, FinancialEventType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<TodoItem>, List<TodoItem>, String>
  get selectedTodos => $composableBuilder(
    column: $table.selectedTodos,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Guide>, List<Guide>, String> get guides =>
      $composableBuilder(
        column: $table.guides,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get depositAmount => $composableBuilder(
    column: $table.depositAmount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LifeEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $LifeEventsTable> {
  $$LifeEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedTodos => $composableBuilder(
    column: $table.selectedTodos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guides => $composableBuilder(
    column: $table.guides,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get depositAmount => $composableBuilder(
    column: $table.depositAmount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LifeEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LifeEventsTable> {
  $$LifeEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FinancialEventType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<TodoItem>, String> get selectedTodos =>
      $composableBuilder(
        column: $table.selectedTodos,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<Guide>, String> get guides =>
      $composableBuilder(column: $table.guides, builder: (column) => column);

  GeneratedColumn<double> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumn<double> get depositAmount => $composableBuilder(
    column: $table.depositAmount,
    builder: (column) => column,
  );
}

class $$LifeEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LifeEventsTable,
          LifeEvent,
          $$LifeEventsTableFilterComposer,
          $$LifeEventsTableOrderingComposer,
          $$LifeEventsTableAnnotationComposer,
          $$LifeEventsTableCreateCompanionBuilder,
          $$LifeEventsTableUpdateCompanionBuilder,
          (
            LifeEvent,
            BaseReferences<_$AppDatabase, $LifeEventsTable, LifeEvent>,
          ),
          LifeEvent,
          PrefetchHooks Function()
        > {
  $$LifeEventsTableTableManager(_$AppDatabase db, $LifeEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LifeEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LifeEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LifeEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<FinancialEventType> type = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<List<TodoItem>> selectedTodos = const Value.absent(),
                Value<List<Guide>> guides = const Value.absent(),
                Value<double?> budget = const Value.absent(),
                Value<double?> depositAmount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LifeEventsCompanion(
                id: id,
                title: title,
                type: type,
                date: date,
                location: location,
                selectedTodos: selectedTodos,
                guides: guides,
                budget: budget,
                depositAmount: depositAmount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required FinancialEventType type,
                required DateTime date,
                required String location,
                required List<TodoItem> selectedTodos,
                required List<Guide> guides,
                Value<double?> budget = const Value.absent(),
                Value<double?> depositAmount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LifeEventsCompanion.insert(
                id: id,
                title: title,
                type: type,
                date: date,
                location: location,
                selectedTodos: selectedTodos,
                guides: guides,
                budget: budget,
                depositAmount: depositAmount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LifeEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LifeEventsTable,
      LifeEvent,
      $$LifeEventsTableFilterComposer,
      $$LifeEventsTableOrderingComposer,
      $$LifeEventsTableAnnotationComposer,
      $$LifeEventsTableCreateCompanionBuilder,
      $$LifeEventsTableUpdateCompanionBuilder,
      (LifeEvent, BaseReferences<_$AppDatabase, $LifeEventsTable, LifeEvent>),
      LifeEvent,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OwnedProductsTableTableManager get ownedProducts =>
      $$OwnedProductsTableTableManager(_db, _db.ownedProducts);
  $$LifeEventsTableTableManager get lifeEvents =>
      $$LifeEventsTableTableManager(_db, _db.lifeEvents);
}
