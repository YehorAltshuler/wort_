// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'citizenship_test_database.dart';

// ignore_for_file: type=lint
class $CitizenshipDatasetsTable extends CitizenshipDatasets
    with TableInfo<$CitizenshipDatasetsTable, CitizenshipDataset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitizenshipDatasetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceHashMeta = const VerificationMeta(
    'sourceHash',
  );
  @override
  late final GeneratedColumn<String> sourceHash = GeneratedColumn<String>(
    'source_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionCountMeta = const VerificationMeta(
    'questionCount',
  );
  @override
  late final GeneratedColumn<int> questionCount = GeneratedColumn<int>(
    'question_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    status,
    createdAt,
    sourceHash,
    questionCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'citizenship_datasets';
  @override
  VerificationContext validateIntegrity(
    Insertable<CitizenshipDataset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('source_hash')) {
      context.handle(
        _sourceHashMeta,
        sourceHash.isAcceptableOrUnknown(data['source_hash']!, _sourceHashMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceHashMeta);
    }
    if (data.containsKey('question_count')) {
      context.handle(
        _questionCountMeta,
        questionCount.isAcceptableOrUnknown(
          data['question_count']!,
          _questionCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CitizenshipDataset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CitizenshipDataset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      sourceHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_hash'],
      )!,
      questionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_count'],
      )!,
    );
  }

  @override
  $CitizenshipDatasetsTable createAlias(String alias) {
    return $CitizenshipDatasetsTable(attachedDatabase, alias);
  }
}

class CitizenshipDataset extends DataClass
    implements Insertable<CitizenshipDataset> {
  final String id;
  final String status;
  final DateTime createdAt;
  final String sourceHash;
  final int questionCount;
  const CitizenshipDataset({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.sourceHash,
    required this.questionCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['source_hash'] = Variable<String>(sourceHash);
    map['question_count'] = Variable<int>(questionCount);
    return map;
  }

  CitizenshipDatasetsCompanion toCompanion(bool nullToAbsent) {
    return CitizenshipDatasetsCompanion(
      id: Value(id),
      status: Value(status),
      createdAt: Value(createdAt),
      sourceHash: Value(sourceHash),
      questionCount: Value(questionCount),
    );
  }

  factory CitizenshipDataset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitizenshipDataset(
      id: serializer.fromJson<String>(json['id']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sourceHash: serializer.fromJson<String>(json['sourceHash']),
      questionCount: serializer.fromJson<int>(json['questionCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sourceHash': serializer.toJson<String>(sourceHash),
      'questionCount': serializer.toJson<int>(questionCount),
    };
  }

  CitizenshipDataset copyWith({
    String? id,
    String? status,
    DateTime? createdAt,
    String? sourceHash,
    int? questionCount,
  }) => CitizenshipDataset(
    id: id ?? this.id,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    sourceHash: sourceHash ?? this.sourceHash,
    questionCount: questionCount ?? this.questionCount,
  );
  CitizenshipDataset copyWithCompanion(CitizenshipDatasetsCompanion data) {
    return CitizenshipDataset(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sourceHash: data.sourceHash.present
          ? data.sourceHash.value
          : this.sourceHash,
      questionCount: data.questionCount.present
          ? data.questionCount.value
          : this.questionCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipDataset(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('questionCount: $questionCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, status, createdAt, sourceHash, questionCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitizenshipDataset &&
          other.id == this.id &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.sourceHash == this.sourceHash &&
          other.questionCount == this.questionCount);
}

class CitizenshipDatasetsCompanion extends UpdateCompanion<CitizenshipDataset> {
  final Value<String> id;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<String> sourceHash;
  final Value<int> questionCount;
  final Value<int> rowid;
  const CitizenshipDatasetsCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sourceHash = const Value.absent(),
    this.questionCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitizenshipDatasetsCompanion.insert({
    required String id,
    required String status,
    required DateTime createdAt,
    required String sourceHash,
    required int questionCount,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status),
       createdAt = Value(createdAt),
       sourceHash = Value(sourceHash),
       questionCount = Value(questionCount);
  static Insertable<CitizenshipDataset> custom({
    Expression<String>? id,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<String>? sourceHash,
    Expression<int>? questionCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (sourceHash != null) 'source_hash': sourceHash,
      if (questionCount != null) 'question_count': questionCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitizenshipDatasetsCompanion copyWith({
    Value<String>? id,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<String>? sourceHash,
    Value<int>? questionCount,
    Value<int>? rowid,
  }) {
    return CitizenshipDatasetsCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      sourceHash: sourceHash ?? this.sourceHash,
      questionCount: questionCount ?? this.questionCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sourceHash.present) {
      map['source_hash'] = Variable<String>(sourceHash.value);
    }
    if (questionCount.present) {
      map['question_count'] = Variable<int>(questionCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipDatasetsCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('questionCount: $questionCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitizenshipQuestionsTable extends CitizenshipQuestions
    with TableInfo<$CitizenshipQuestionsTable, CitizenshipQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitizenshipQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _datasetIdMeta = const VerificationMeta(
    'datasetId',
  );
  @override
  late final GeneratedColumn<String> datasetId = GeneratedColumn<String>(
    'dataset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numMeta = const VerificationMeta('num');
  @override
  late final GeneratedColumn<String> num = GeneratedColumn<String>(
    'num',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerAMeta = const VerificationMeta(
    'answerA',
  );
  @override
  late final GeneratedColumn<String> answerA = GeneratedColumn<String>(
    'answer_a',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerBMeta = const VerificationMeta(
    'answerB',
  );
  @override
  late final GeneratedColumn<String> answerB = GeneratedColumn<String>(
    'answer_b',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerCMeta = const VerificationMeta(
    'answerC',
  );
  @override
  late final GeneratedColumn<String> answerC = GeneratedColumn<String>(
    'answer_c',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerDMeta = const VerificationMeta(
    'answerD',
  );
  @override
  late final GeneratedColumn<String> answerD = GeneratedColumn<String>(
    'answer_d',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctAnswerMeta = const VerificationMeta(
    'correctAnswer',
  );
  @override
  late final GeneratedColumn<int> correctAnswer = GeneratedColumn<int>(
    'correct_answer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta(
    'stateCode',
  );
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaKeyMeta = const VerificationMeta(
    'mediaKey',
  );
  @override
  late final GeneratedColumn<String> mediaKey = GeneratedColumn<String>(
    'media_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageRequiredMeta = const VerificationMeta(
    'imageRequired',
  );
  @override
  late final GeneratedColumn<bool> imageRequired = GeneratedColumn<bool>(
    'image_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("image_required" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    datasetId,
    id,
    num,
    question,
    answerA,
    answerB,
    answerC,
    answerD,
    correctAnswer,
    sortOrder,
    scope,
    stateCode,
    imageUrl,
    mediaKey,
    imageRequired,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'citizenship_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CitizenshipQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dataset_id')) {
      context.handle(
        _datasetIdMeta,
        datasetId.isAcceptableOrUnknown(data['dataset_id']!, _datasetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_datasetIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('num')) {
      context.handle(
        _numMeta,
        num.isAcceptableOrUnknown(data['num']!, _numMeta),
      );
    } else if (isInserting) {
      context.missing(_numMeta);
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('answer_a')) {
      context.handle(
        _answerAMeta,
        answerA.isAcceptableOrUnknown(data['answer_a']!, _answerAMeta),
      );
    } else if (isInserting) {
      context.missing(_answerAMeta);
    }
    if (data.containsKey('answer_b')) {
      context.handle(
        _answerBMeta,
        answerB.isAcceptableOrUnknown(data['answer_b']!, _answerBMeta),
      );
    } else if (isInserting) {
      context.missing(_answerBMeta);
    }
    if (data.containsKey('answer_c')) {
      context.handle(
        _answerCMeta,
        answerC.isAcceptableOrUnknown(data['answer_c']!, _answerCMeta),
      );
    } else if (isInserting) {
      context.missing(_answerCMeta);
    }
    if (data.containsKey('answer_d')) {
      context.handle(
        _answerDMeta,
        answerD.isAcceptableOrUnknown(data['answer_d']!, _answerDMeta),
      );
    } else if (isInserting) {
      context.missing(_answerDMeta);
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
        _correctAnswerMeta,
        correctAnswer.isAcceptableOrUnknown(
          data['correct_answer']!,
          _correctAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('media_key')) {
      context.handle(
        _mediaKeyMeta,
        mediaKey.isAcceptableOrUnknown(data['media_key']!, _mediaKeyMeta),
      );
    }
    if (data.containsKey('image_required')) {
      context.handle(
        _imageRequiredMeta,
        imageRequired.isAcceptableOrUnknown(
          data['image_required']!,
          _imageRequiredMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {datasetId, id};
  @override
  CitizenshipQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CitizenshipQuestion(
      datasetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dataset_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      num: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}num'],
      )!,
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      answerA: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_a'],
      )!,
      answerB: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_b'],
      )!,
      answerC: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_c'],
      )!,
      answerD: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_d'],
      )!,
      correctAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answer'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      mediaKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_key'],
      ),
      imageRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}image_required'],
      )!,
    );
  }

  @override
  $CitizenshipQuestionsTable createAlias(String alias) {
    return $CitizenshipQuestionsTable(attachedDatabase, alias);
  }
}

class CitizenshipQuestion extends DataClass
    implements Insertable<CitizenshipQuestion> {
  final String datasetId;
  final String id;
  final String num;
  final String question;
  final String answerA;
  final String answerB;
  final String answerC;
  final String answerD;
  final int correctAnswer;
  final int sortOrder;
  final String scope;
  final String? stateCode;
  final String? imageUrl;
  final String? mediaKey;
  final bool imageRequired;
  const CitizenshipQuestion({
    required this.datasetId,
    required this.id,
    required this.num,
    required this.question,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.answerD,
    required this.correctAnswer,
    required this.sortOrder,
    required this.scope,
    this.stateCode,
    this.imageUrl,
    this.mediaKey,
    required this.imageRequired,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dataset_id'] = Variable<String>(datasetId);
    map['id'] = Variable<String>(id);
    map['num'] = Variable<String>(num);
    map['question'] = Variable<String>(question);
    map['answer_a'] = Variable<String>(answerA);
    map['answer_b'] = Variable<String>(answerB);
    map['answer_c'] = Variable<String>(answerC);
    map['answer_d'] = Variable<String>(answerD);
    map['correct_answer'] = Variable<int>(correctAnswer);
    map['sort_order'] = Variable<int>(sortOrder);
    map['scope'] = Variable<String>(scope);
    if (!nullToAbsent || stateCode != null) {
      map['state_code'] = Variable<String>(stateCode);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || mediaKey != null) {
      map['media_key'] = Variable<String>(mediaKey);
    }
    map['image_required'] = Variable<bool>(imageRequired);
    return map;
  }

  CitizenshipQuestionsCompanion toCompanion(bool nullToAbsent) {
    return CitizenshipQuestionsCompanion(
      datasetId: Value(datasetId),
      id: Value(id),
      num: Value(num),
      question: Value(question),
      answerA: Value(answerA),
      answerB: Value(answerB),
      answerC: Value(answerC),
      answerD: Value(answerD),
      correctAnswer: Value(correctAnswer),
      sortOrder: Value(sortOrder),
      scope: Value(scope),
      stateCode: stateCode == null && nullToAbsent
          ? const Value.absent()
          : Value(stateCode),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      mediaKey: mediaKey == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaKey),
      imageRequired: Value(imageRequired),
    );
  }

  factory CitizenshipQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitizenshipQuestion(
      datasetId: serializer.fromJson<String>(json['datasetId']),
      id: serializer.fromJson<String>(json['id']),
      num: serializer.fromJson<String>(json['num']),
      question: serializer.fromJson<String>(json['question']),
      answerA: serializer.fromJson<String>(json['answerA']),
      answerB: serializer.fromJson<String>(json['answerB']),
      answerC: serializer.fromJson<String>(json['answerC']),
      answerD: serializer.fromJson<String>(json['answerD']),
      correctAnswer: serializer.fromJson<int>(json['correctAnswer']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      scope: serializer.fromJson<String>(json['scope']),
      stateCode: serializer.fromJson<String?>(json['stateCode']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      mediaKey: serializer.fromJson<String?>(json['mediaKey']),
      imageRequired: serializer.fromJson<bool>(json['imageRequired']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'datasetId': serializer.toJson<String>(datasetId),
      'id': serializer.toJson<String>(id),
      'num': serializer.toJson<String>(num),
      'question': serializer.toJson<String>(question),
      'answerA': serializer.toJson<String>(answerA),
      'answerB': serializer.toJson<String>(answerB),
      'answerC': serializer.toJson<String>(answerC),
      'answerD': serializer.toJson<String>(answerD),
      'correctAnswer': serializer.toJson<int>(correctAnswer),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'scope': serializer.toJson<String>(scope),
      'stateCode': serializer.toJson<String?>(stateCode),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'mediaKey': serializer.toJson<String?>(mediaKey),
      'imageRequired': serializer.toJson<bool>(imageRequired),
    };
  }

  CitizenshipQuestion copyWith({
    String? datasetId,
    String? id,
    String? num,
    String? question,
    String? answerA,
    String? answerB,
    String? answerC,
    String? answerD,
    int? correctAnswer,
    int? sortOrder,
    String? scope,
    Value<String?> stateCode = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> mediaKey = const Value.absent(),
    bool? imageRequired,
  }) => CitizenshipQuestion(
    datasetId: datasetId ?? this.datasetId,
    id: id ?? this.id,
    num: num ?? this.num,
    question: question ?? this.question,
    answerA: answerA ?? this.answerA,
    answerB: answerB ?? this.answerB,
    answerC: answerC ?? this.answerC,
    answerD: answerD ?? this.answerD,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    sortOrder: sortOrder ?? this.sortOrder,
    scope: scope ?? this.scope,
    stateCode: stateCode.present ? stateCode.value : this.stateCode,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    mediaKey: mediaKey.present ? mediaKey.value : this.mediaKey,
    imageRequired: imageRequired ?? this.imageRequired,
  );
  CitizenshipQuestion copyWithCompanion(CitizenshipQuestionsCompanion data) {
    return CitizenshipQuestion(
      datasetId: data.datasetId.present ? data.datasetId.value : this.datasetId,
      id: data.id.present ? data.id.value : this.id,
      num: data.num.present ? data.num.value : this.num,
      question: data.question.present ? data.question.value : this.question,
      answerA: data.answerA.present ? data.answerA.value : this.answerA,
      answerB: data.answerB.present ? data.answerB.value : this.answerB,
      answerC: data.answerC.present ? data.answerC.value : this.answerC,
      answerD: data.answerD.present ? data.answerD.value : this.answerD,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      scope: data.scope.present ? data.scope.value : this.scope,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      mediaKey: data.mediaKey.present ? data.mediaKey.value : this.mediaKey,
      imageRequired: data.imageRequired.present
          ? data.imageRequired.value
          : this.imageRequired,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipQuestion(')
          ..write('datasetId: $datasetId, ')
          ..write('id: $id, ')
          ..write('num: $num, ')
          ..write('question: $question, ')
          ..write('answerA: $answerA, ')
          ..write('answerB: $answerB, ')
          ..write('answerC: $answerC, ')
          ..write('answerD: $answerD, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('scope: $scope, ')
          ..write('stateCode: $stateCode, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('mediaKey: $mediaKey, ')
          ..write('imageRequired: $imageRequired')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    datasetId,
    id,
    num,
    question,
    answerA,
    answerB,
    answerC,
    answerD,
    correctAnswer,
    sortOrder,
    scope,
    stateCode,
    imageUrl,
    mediaKey,
    imageRequired,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitizenshipQuestion &&
          other.datasetId == this.datasetId &&
          other.id == this.id &&
          other.num == this.num &&
          other.question == this.question &&
          other.answerA == this.answerA &&
          other.answerB == this.answerB &&
          other.answerC == this.answerC &&
          other.answerD == this.answerD &&
          other.correctAnswer == this.correctAnswer &&
          other.sortOrder == this.sortOrder &&
          other.scope == this.scope &&
          other.stateCode == this.stateCode &&
          other.imageUrl == this.imageUrl &&
          other.mediaKey == this.mediaKey &&
          other.imageRequired == this.imageRequired);
}

class CitizenshipQuestionsCompanion
    extends UpdateCompanion<CitizenshipQuestion> {
  final Value<String> datasetId;
  final Value<String> id;
  final Value<String> num;
  final Value<String> question;
  final Value<String> answerA;
  final Value<String> answerB;
  final Value<String> answerC;
  final Value<String> answerD;
  final Value<int> correctAnswer;
  final Value<int> sortOrder;
  final Value<String> scope;
  final Value<String?> stateCode;
  final Value<String?> imageUrl;
  final Value<String?> mediaKey;
  final Value<bool> imageRequired;
  final Value<int> rowid;
  const CitizenshipQuestionsCompanion({
    this.datasetId = const Value.absent(),
    this.id = const Value.absent(),
    this.num = const Value.absent(),
    this.question = const Value.absent(),
    this.answerA = const Value.absent(),
    this.answerB = const Value.absent(),
    this.answerC = const Value.absent(),
    this.answerD = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.scope = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.mediaKey = const Value.absent(),
    this.imageRequired = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitizenshipQuestionsCompanion.insert({
    required String datasetId,
    required String id,
    required String num,
    required String question,
    required String answerA,
    required String answerB,
    required String answerC,
    required String answerD,
    required int correctAnswer,
    required int sortOrder,
    required String scope,
    this.stateCode = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.mediaKey = const Value.absent(),
    this.imageRequired = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : datasetId = Value(datasetId),
       id = Value(id),
       num = Value(num),
       question = Value(question),
       answerA = Value(answerA),
       answerB = Value(answerB),
       answerC = Value(answerC),
       answerD = Value(answerD),
       correctAnswer = Value(correctAnswer),
       sortOrder = Value(sortOrder),
       scope = Value(scope);
  static Insertable<CitizenshipQuestion> custom({
    Expression<String>? datasetId,
    Expression<String>? id,
    Expression<String>? num,
    Expression<String>? question,
    Expression<String>? answerA,
    Expression<String>? answerB,
    Expression<String>? answerC,
    Expression<String>? answerD,
    Expression<int>? correctAnswer,
    Expression<int>? sortOrder,
    Expression<String>? scope,
    Expression<String>? stateCode,
    Expression<String>? imageUrl,
    Expression<String>? mediaKey,
    Expression<bool>? imageRequired,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (datasetId != null) 'dataset_id': datasetId,
      if (id != null) 'id': id,
      if (num != null) 'num': num,
      if (question != null) 'question': question,
      if (answerA != null) 'answer_a': answerA,
      if (answerB != null) 'answer_b': answerB,
      if (answerC != null) 'answer_c': answerC,
      if (answerD != null) 'answer_d': answerD,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (scope != null) 'scope': scope,
      if (stateCode != null) 'state_code': stateCode,
      if (imageUrl != null) 'image_url': imageUrl,
      if (mediaKey != null) 'media_key': mediaKey,
      if (imageRequired != null) 'image_required': imageRequired,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitizenshipQuestionsCompanion copyWith({
    Value<String>? datasetId,
    Value<String>? id,
    Value<String>? num,
    Value<String>? question,
    Value<String>? answerA,
    Value<String>? answerB,
    Value<String>? answerC,
    Value<String>? answerD,
    Value<int>? correctAnswer,
    Value<int>? sortOrder,
    Value<String>? scope,
    Value<String?>? stateCode,
    Value<String?>? imageUrl,
    Value<String?>? mediaKey,
    Value<bool>? imageRequired,
    Value<int>? rowid,
  }) {
    return CitizenshipQuestionsCompanion(
      datasetId: datasetId ?? this.datasetId,
      id: id ?? this.id,
      num: num ?? this.num,
      question: question ?? this.question,
      answerA: answerA ?? this.answerA,
      answerB: answerB ?? this.answerB,
      answerC: answerC ?? this.answerC,
      answerD: answerD ?? this.answerD,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      sortOrder: sortOrder ?? this.sortOrder,
      scope: scope ?? this.scope,
      stateCode: stateCode ?? this.stateCode,
      imageUrl: imageUrl ?? this.imageUrl,
      mediaKey: mediaKey ?? this.mediaKey,
      imageRequired: imageRequired ?? this.imageRequired,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (datasetId.present) {
      map['dataset_id'] = Variable<String>(datasetId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (num.present) {
      map['num'] = Variable<String>(num.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (answerA.present) {
      map['answer_a'] = Variable<String>(answerA.value);
    }
    if (answerB.present) {
      map['answer_b'] = Variable<String>(answerB.value);
    }
    if (answerC.present) {
      map['answer_c'] = Variable<String>(answerC.value);
    }
    if (answerD.present) {
      map['answer_d'] = Variable<String>(answerD.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<int>(correctAnswer.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (mediaKey.present) {
      map['media_key'] = Variable<String>(mediaKey.value);
    }
    if (imageRequired.present) {
      map['image_required'] = Variable<bool>(imageRequired.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipQuestionsCompanion(')
          ..write('datasetId: $datasetId, ')
          ..write('id: $id, ')
          ..write('num: $num, ')
          ..write('question: $question, ')
          ..write('answerA: $answerA, ')
          ..write('answerB: $answerB, ')
          ..write('answerC: $answerC, ')
          ..write('answerD: $answerD, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('scope: $scope, ')
          ..write('stateCode: $stateCode, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('mediaKey: $mediaKey, ')
          ..write('imageRequired: $imageRequired, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitizenshipMediaTable extends CitizenshipMedia
    with TableInfo<$CitizenshipMediaTable, CitizenshipMediaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitizenshipMediaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _datasetIdMeta = const VerificationMeta(
    'datasetId',
  );
  @override
  late final GeneratedColumn<String> datasetId = GeneratedColumn<String>(
    'dataset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaKeyMeta = const VerificationMeta(
    'mediaKey',
  );
  @override
  late final GeneratedColumn<String> mediaKey = GeneratedColumn<String>(
    'media_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    datasetId,
    mediaKey,
    sourceUrl,
    relativePath,
    mimeType,
    contentHash,
    status,
    lastError,
    retryCount,
    nextRetryAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'citizenship_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<CitizenshipMediaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dataset_id')) {
      context.handle(
        _datasetIdMeta,
        datasetId.isAcceptableOrUnknown(data['dataset_id']!, _datasetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_datasetIdMeta);
    }
    if (data.containsKey('media_key')) {
      context.handle(
        _mediaKeyMeta,
        mediaKey.isAcceptableOrUnknown(data['media_key']!, _mediaKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaKeyMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {datasetId, mediaKey};
  @override
  CitizenshipMediaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CitizenshipMediaData(
      datasetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dataset_id'],
      )!,
      mediaKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_key'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      relativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_path'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
    );
  }

  @override
  $CitizenshipMediaTable createAlias(String alias) {
    return $CitizenshipMediaTable(attachedDatabase, alias);
  }
}

class CitizenshipMediaData extends DataClass
    implements Insertable<CitizenshipMediaData> {
  final String datasetId;
  final String mediaKey;
  final String sourceUrl;
  final String relativePath;
  final String? mimeType;
  final String? contentHash;
  final String status;
  final String? lastError;
  final int retryCount;
  final DateTime? nextRetryAt;
  const CitizenshipMediaData({
    required this.datasetId,
    required this.mediaKey,
    required this.sourceUrl,
    required this.relativePath,
    this.mimeType,
    this.contentHash,
    required this.status,
    this.lastError,
    required this.retryCount,
    this.nextRetryAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dataset_id'] = Variable<String>(datasetId);
    map['media_key'] = Variable<String>(mediaKey);
    map['source_url'] = Variable<String>(sourceUrl);
    map['relative_path'] = Variable<String>(relativePath);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || contentHash != null) {
      map['content_hash'] = Variable<String>(contentHash);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    return map;
  }

  CitizenshipMediaCompanion toCompanion(bool nullToAbsent) {
    return CitizenshipMediaCompanion(
      datasetId: Value(datasetId),
      mediaKey: Value(mediaKey),
      sourceUrl: Value(sourceUrl),
      relativePath: Value(relativePath),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      contentHash: contentHash == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHash),
      status: Value(status),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      retryCount: Value(retryCount),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
    );
  }

  factory CitizenshipMediaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitizenshipMediaData(
      datasetId: serializer.fromJson<String>(json['datasetId']),
      mediaKey: serializer.fromJson<String>(json['mediaKey']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      contentHash: serializer.fromJson<String?>(json['contentHash']),
      status: serializer.fromJson<String>(json['status']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'datasetId': serializer.toJson<String>(datasetId),
      'mediaKey': serializer.toJson<String>(mediaKey),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'relativePath': serializer.toJson<String>(relativePath),
      'mimeType': serializer.toJson<String?>(mimeType),
      'contentHash': serializer.toJson<String?>(contentHash),
      'status': serializer.toJson<String>(status),
      'lastError': serializer.toJson<String?>(lastError),
      'retryCount': serializer.toJson<int>(retryCount),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
    };
  }

  CitizenshipMediaData copyWith({
    String? datasetId,
    String? mediaKey,
    String? sourceUrl,
    String? relativePath,
    Value<String?> mimeType = const Value.absent(),
    Value<String?> contentHash = const Value.absent(),
    String? status,
    Value<String?> lastError = const Value.absent(),
    int? retryCount,
    Value<DateTime?> nextRetryAt = const Value.absent(),
  }) => CitizenshipMediaData(
    datasetId: datasetId ?? this.datasetId,
    mediaKey: mediaKey ?? this.mediaKey,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    relativePath: relativePath ?? this.relativePath,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    contentHash: contentHash.present ? contentHash.value : this.contentHash,
    status: status ?? this.status,
    lastError: lastError.present ? lastError.value : this.lastError,
    retryCount: retryCount ?? this.retryCount,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
  );
  CitizenshipMediaData copyWithCompanion(CitizenshipMediaCompanion data) {
    return CitizenshipMediaData(
      datasetId: data.datasetId.present ? data.datasetId.value : this.datasetId,
      mediaKey: data.mediaKey.present ? data.mediaKey.value : this.mediaKey,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      status: data.status.present ? data.status.value : this.status,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipMediaData(')
          ..write('datasetId: $datasetId, ')
          ..write('mediaKey: $mediaKey, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('relativePath: $relativePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('contentHash: $contentHash, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('retryCount: $retryCount, ')
          ..write('nextRetryAt: $nextRetryAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    datasetId,
    mediaKey,
    sourceUrl,
    relativePath,
    mimeType,
    contentHash,
    status,
    lastError,
    retryCount,
    nextRetryAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitizenshipMediaData &&
          other.datasetId == this.datasetId &&
          other.mediaKey == this.mediaKey &&
          other.sourceUrl == this.sourceUrl &&
          other.relativePath == this.relativePath &&
          other.mimeType == this.mimeType &&
          other.contentHash == this.contentHash &&
          other.status == this.status &&
          other.lastError == this.lastError &&
          other.retryCount == this.retryCount &&
          other.nextRetryAt == this.nextRetryAt);
}

class CitizenshipMediaCompanion extends UpdateCompanion<CitizenshipMediaData> {
  final Value<String> datasetId;
  final Value<String> mediaKey;
  final Value<String> sourceUrl;
  final Value<String> relativePath;
  final Value<String?> mimeType;
  final Value<String?> contentHash;
  final Value<String> status;
  final Value<String?> lastError;
  final Value<int> retryCount;
  final Value<DateTime?> nextRetryAt;
  final Value<int> rowid;
  const CitizenshipMediaCompanion({
    this.datasetId = const Value.absent(),
    this.mediaKey = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitizenshipMediaCompanion.insert({
    required String datasetId,
    required String mediaKey,
    required String sourceUrl,
    required String relativePath,
    this.mimeType = const Value.absent(),
    this.contentHash = const Value.absent(),
    required String status,
    this.lastError = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : datasetId = Value(datasetId),
       mediaKey = Value(mediaKey),
       sourceUrl = Value(sourceUrl),
       relativePath = Value(relativePath),
       status = Value(status);
  static Insertable<CitizenshipMediaData> custom({
    Expression<String>? datasetId,
    Expression<String>? mediaKey,
    Expression<String>? sourceUrl,
    Expression<String>? relativePath,
    Expression<String>? mimeType,
    Expression<String>? contentHash,
    Expression<String>? status,
    Expression<String>? lastError,
    Expression<int>? retryCount,
    Expression<DateTime>? nextRetryAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (datasetId != null) 'dataset_id': datasetId,
      if (mediaKey != null) 'media_key': mediaKey,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (relativePath != null) 'relative_path': relativePath,
      if (mimeType != null) 'mime_type': mimeType,
      if (contentHash != null) 'content_hash': contentHash,
      if (status != null) 'status': status,
      if (lastError != null) 'last_error': lastError,
      if (retryCount != null) 'retry_count': retryCount,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitizenshipMediaCompanion copyWith({
    Value<String>? datasetId,
    Value<String>? mediaKey,
    Value<String>? sourceUrl,
    Value<String>? relativePath,
    Value<String?>? mimeType,
    Value<String?>? contentHash,
    Value<String>? status,
    Value<String?>? lastError,
    Value<int>? retryCount,
    Value<DateTime?>? nextRetryAt,
    Value<int>? rowid,
  }) {
    return CitizenshipMediaCompanion(
      datasetId: datasetId ?? this.datasetId,
      mediaKey: mediaKey ?? this.mediaKey,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      relativePath: relativePath ?? this.relativePath,
      mimeType: mimeType ?? this.mimeType,
      contentHash: contentHash ?? this.contentHash,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      retryCount: retryCount ?? this.retryCount,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (datasetId.present) {
      map['dataset_id'] = Variable<String>(datasetId.value);
    }
    if (mediaKey.present) {
      map['media_key'] = Variable<String>(mediaKey.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipMediaCompanion(')
          ..write('datasetId: $datasetId, ')
          ..write('mediaKey: $mediaKey, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('relativePath: $relativePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('contentHash: $contentHash, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('retryCount: $retryCount, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitizenshipQuestionImagesTable extends CitizenshipQuestionImages
    with TableInfo<$CitizenshipQuestionImagesTable, CitizenshipQuestionImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitizenshipQuestionImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _datasetIdMeta = const VerificationMeta(
    'datasetId',
  );
  @override
  late final GeneratedColumn<String> datasetId = GeneratedColumn<String>(
    'dataset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaKeyMeta = const VerificationMeta(
    'mediaKey',
  );
  @override
  late final GeneratedColumn<String> mediaKey = GeneratedColumn<String>(
    'media_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    datasetId,
    questionId,
    mediaKey,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'citizenship_question_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<CitizenshipQuestionImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dataset_id')) {
      context.handle(
        _datasetIdMeta,
        datasetId.isAcceptableOrUnknown(data['dataset_id']!, _datasetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_datasetIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('media_key')) {
      context.handle(
        _mediaKeyMeta,
        mediaKey.isAcceptableOrUnknown(data['media_key']!, _mediaKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaKeyMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {datasetId, questionId, mediaKey};
  @override
  CitizenshipQuestionImage map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CitizenshipQuestionImage(
      datasetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dataset_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      mediaKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_key'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $CitizenshipQuestionImagesTable createAlias(String alias) {
    return $CitizenshipQuestionImagesTable(attachedDatabase, alias);
  }
}

class CitizenshipQuestionImage extends DataClass
    implements Insertable<CitizenshipQuestionImage> {
  final String datasetId;
  final String questionId;
  final String mediaKey;
  final int position;
  const CitizenshipQuestionImage({
    required this.datasetId,
    required this.questionId,
    required this.mediaKey,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dataset_id'] = Variable<String>(datasetId);
    map['question_id'] = Variable<String>(questionId);
    map['media_key'] = Variable<String>(mediaKey);
    map['position'] = Variable<int>(position);
    return map;
  }

  CitizenshipQuestionImagesCompanion toCompanion(bool nullToAbsent) {
    return CitizenshipQuestionImagesCompanion(
      datasetId: Value(datasetId),
      questionId: Value(questionId),
      mediaKey: Value(mediaKey),
      position: Value(position),
    );
  }

  factory CitizenshipQuestionImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitizenshipQuestionImage(
      datasetId: serializer.fromJson<String>(json['datasetId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      mediaKey: serializer.fromJson<String>(json['mediaKey']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'datasetId': serializer.toJson<String>(datasetId),
      'questionId': serializer.toJson<String>(questionId),
      'mediaKey': serializer.toJson<String>(mediaKey),
      'position': serializer.toJson<int>(position),
    };
  }

  CitizenshipQuestionImage copyWith({
    String? datasetId,
    String? questionId,
    String? mediaKey,
    int? position,
  }) => CitizenshipQuestionImage(
    datasetId: datasetId ?? this.datasetId,
    questionId: questionId ?? this.questionId,
    mediaKey: mediaKey ?? this.mediaKey,
    position: position ?? this.position,
  );
  CitizenshipQuestionImage copyWithCompanion(
    CitizenshipQuestionImagesCompanion data,
  ) {
    return CitizenshipQuestionImage(
      datasetId: data.datasetId.present ? data.datasetId.value : this.datasetId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      mediaKey: data.mediaKey.present ? data.mediaKey.value : this.mediaKey,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipQuestionImage(')
          ..write('datasetId: $datasetId, ')
          ..write('questionId: $questionId, ')
          ..write('mediaKey: $mediaKey, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(datasetId, questionId, mediaKey, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitizenshipQuestionImage &&
          other.datasetId == this.datasetId &&
          other.questionId == this.questionId &&
          other.mediaKey == this.mediaKey &&
          other.position == this.position);
}

class CitizenshipQuestionImagesCompanion
    extends UpdateCompanion<CitizenshipQuestionImage> {
  final Value<String> datasetId;
  final Value<String> questionId;
  final Value<String> mediaKey;
  final Value<int> position;
  final Value<int> rowid;
  const CitizenshipQuestionImagesCompanion({
    this.datasetId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.mediaKey = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitizenshipQuestionImagesCompanion.insert({
    required String datasetId,
    required String questionId,
    required String mediaKey,
    required int position,
    this.rowid = const Value.absent(),
  }) : datasetId = Value(datasetId),
       questionId = Value(questionId),
       mediaKey = Value(mediaKey),
       position = Value(position);
  static Insertable<CitizenshipQuestionImage> custom({
    Expression<String>? datasetId,
    Expression<String>? questionId,
    Expression<String>? mediaKey,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (datasetId != null) 'dataset_id': datasetId,
      if (questionId != null) 'question_id': questionId,
      if (mediaKey != null) 'media_key': mediaKey,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitizenshipQuestionImagesCompanion copyWith({
    Value<String>? datasetId,
    Value<String>? questionId,
    Value<String>? mediaKey,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return CitizenshipQuestionImagesCompanion(
      datasetId: datasetId ?? this.datasetId,
      questionId: questionId ?? this.questionId,
      mediaKey: mediaKey ?? this.mediaKey,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (datasetId.present) {
      map['dataset_id'] = Variable<String>(datasetId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (mediaKey.present) {
      map['media_key'] = Variable<String>(mediaKey.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipQuestionImagesCompanion(')
          ..write('datasetId: $datasetId, ')
          ..write('questionId: $questionId, ')
          ..write('mediaKey: $mediaKey, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitizenshipSyncMetadataTable extends CitizenshipSyncMetadata
    with TableInfo<$CitizenshipSyncMetadataTable, CitizenshipSyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitizenshipSyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _singletonMeta = const VerificationMeta(
    'singleton',
  );
  @override
  late final GeneratedColumn<int> singleton = GeneratedColumn<int>(
    'singleton',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lastCheckAttemptAtMeta =
      const VerificationMeta('lastCheckAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastCheckAttemptAt =
      GeneratedColumn<DateTime>(
        'last_check_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSuccessfulCheckAtMeta =
      const VerificationMeta('lastSuccessfulCheckAt');
  @override
  late final GeneratedColumn<DateTime> lastSuccessfulCheckAt =
      GeneratedColumn<DateTime>(
        'last_successful_check_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSuccessfulUpdateAtMeta =
      const VerificationMeta('lastSuccessfulUpdateAt');
  @override
  late final GeneratedColumn<DateTime> lastSuccessfulUpdateAt =
      GeneratedColumn<DateTime>(
        'last_successful_update_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<String> lastModified = GeneratedColumn<String>(
    'last_modified',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jsonHashMeta = const VerificationMeta(
    'jsonHash',
  );
  @override
  late final GeneratedColumn<String> jsonHash = GeneratedColumn<String>(
    'json_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionCountMeta = const VerificationMeta(
    'questionCount',
  );
  @override
  late final GeneratedColumn<int> questionCount = GeneratedColumn<int>(
    'question_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consecutiveFailuresMeta =
      const VerificationMeta('consecutiveFailures');
  @override
  late final GeneratedColumn<int> consecutiveFailures = GeneratedColumn<int>(
    'consecutive_failures',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAutomaticAttemptAtMeta =
      const VerificationMeta('nextAutomaticAttemptAt');
  @override
  late final GeneratedColumn<DateTime> nextAutomaticAttemptAt =
      GeneratedColumn<DateTime>(
        'next_automatic_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    singleton,
    lastCheckAttemptAt,
    lastSuccessfulCheckAt,
    lastSuccessfulUpdateAt,
    etag,
    lastModified,
    jsonHash,
    questionCount,
    lastError,
    consecutiveFailures,
    nextAutomaticAttemptAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'citizenship_sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<CitizenshipSyncMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('singleton')) {
      context.handle(
        _singletonMeta,
        singleton.isAcceptableOrUnknown(data['singleton']!, _singletonMeta),
      );
    }
    if (data.containsKey('last_check_attempt_at')) {
      context.handle(
        _lastCheckAttemptAtMeta,
        lastCheckAttemptAt.isAcceptableOrUnknown(
          data['last_check_attempt_at']!,
          _lastCheckAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_successful_check_at')) {
      context.handle(
        _lastSuccessfulCheckAtMeta,
        lastSuccessfulCheckAt.isAcceptableOrUnknown(
          data['last_successful_check_at']!,
          _lastSuccessfulCheckAtMeta,
        ),
      );
    }
    if (data.containsKey('last_successful_update_at')) {
      context.handle(
        _lastSuccessfulUpdateAtMeta,
        lastSuccessfulUpdateAt.isAcceptableOrUnknown(
          data['last_successful_update_at']!,
          _lastSuccessfulUpdateAtMeta,
        ),
      );
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('json_hash')) {
      context.handle(
        _jsonHashMeta,
        jsonHash.isAcceptableOrUnknown(data['json_hash']!, _jsonHashMeta),
      );
    }
    if (data.containsKey('question_count')) {
      context.handle(
        _questionCountMeta,
        questionCount.isAcceptableOrUnknown(
          data['question_count']!,
          _questionCountMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('consecutive_failures')) {
      context.handle(
        _consecutiveFailuresMeta,
        consecutiveFailures.isAcceptableOrUnknown(
          data['consecutive_failures']!,
          _consecutiveFailuresMeta,
        ),
      );
    }
    if (data.containsKey('next_automatic_attempt_at')) {
      context.handle(
        _nextAutomaticAttemptAtMeta,
        nextAutomaticAttemptAt.isAcceptableOrUnknown(
          data['next_automatic_attempt_at']!,
          _nextAutomaticAttemptAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {singleton};
  @override
  CitizenshipSyncMetadataData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CitizenshipSyncMetadataData(
      singleton: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}singleton'],
      )!,
      lastCheckAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_check_attempt_at'],
      ),
      lastSuccessfulCheckAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_successful_check_at'],
      ),
      lastSuccessfulUpdateAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_successful_update_at'],
      ),
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_modified'],
      ),
      jsonHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json_hash'],
      ),
      questionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      consecutiveFailures: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consecutive_failures'],
      )!,
      nextAutomaticAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_automatic_attempt_at'],
      ),
    );
  }

  @override
  $CitizenshipSyncMetadataTable createAlias(String alias) {
    return $CitizenshipSyncMetadataTable(attachedDatabase, alias);
  }
}

class CitizenshipSyncMetadataData extends DataClass
    implements Insertable<CitizenshipSyncMetadataData> {
  final int singleton;
  final DateTime? lastCheckAttemptAt;
  final DateTime? lastSuccessfulCheckAt;
  final DateTime? lastSuccessfulUpdateAt;
  final String? etag;
  final String? lastModified;
  final String? jsonHash;
  final int questionCount;
  final String? lastError;
  final int consecutiveFailures;
  final DateTime? nextAutomaticAttemptAt;
  const CitizenshipSyncMetadataData({
    required this.singleton,
    this.lastCheckAttemptAt,
    this.lastSuccessfulCheckAt,
    this.lastSuccessfulUpdateAt,
    this.etag,
    this.lastModified,
    this.jsonHash,
    required this.questionCount,
    this.lastError,
    required this.consecutiveFailures,
    this.nextAutomaticAttemptAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['singleton'] = Variable<int>(singleton);
    if (!nullToAbsent || lastCheckAttemptAt != null) {
      map['last_check_attempt_at'] = Variable<DateTime>(lastCheckAttemptAt);
    }
    if (!nullToAbsent || lastSuccessfulCheckAt != null) {
      map['last_successful_check_at'] = Variable<DateTime>(
        lastSuccessfulCheckAt,
      );
    }
    if (!nullToAbsent || lastSuccessfulUpdateAt != null) {
      map['last_successful_update_at'] = Variable<DateTime>(
        lastSuccessfulUpdateAt,
      );
    }
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || lastModified != null) {
      map['last_modified'] = Variable<String>(lastModified);
    }
    if (!nullToAbsent || jsonHash != null) {
      map['json_hash'] = Variable<String>(jsonHash);
    }
    map['question_count'] = Variable<int>(questionCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['consecutive_failures'] = Variable<int>(consecutiveFailures);
    if (!nullToAbsent || nextAutomaticAttemptAt != null) {
      map['next_automatic_attempt_at'] = Variable<DateTime>(
        nextAutomaticAttemptAt,
      );
    }
    return map;
  }

  CitizenshipSyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return CitizenshipSyncMetadataCompanion(
      singleton: Value(singleton),
      lastCheckAttemptAt: lastCheckAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckAttemptAt),
      lastSuccessfulCheckAt: lastSuccessfulCheckAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessfulCheckAt),
      lastSuccessfulUpdateAt: lastSuccessfulUpdateAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessfulUpdateAt),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      lastModified: lastModified == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModified),
      jsonHash: jsonHash == null && nullToAbsent
          ? const Value.absent()
          : Value(jsonHash),
      questionCount: Value(questionCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      consecutiveFailures: Value(consecutiveFailures),
      nextAutomaticAttemptAt: nextAutomaticAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAutomaticAttemptAt),
    );
  }

  factory CitizenshipSyncMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitizenshipSyncMetadataData(
      singleton: serializer.fromJson<int>(json['singleton']),
      lastCheckAttemptAt: serializer.fromJson<DateTime?>(
        json['lastCheckAttemptAt'],
      ),
      lastSuccessfulCheckAt: serializer.fromJson<DateTime?>(
        json['lastSuccessfulCheckAt'],
      ),
      lastSuccessfulUpdateAt: serializer.fromJson<DateTime?>(
        json['lastSuccessfulUpdateAt'],
      ),
      etag: serializer.fromJson<String?>(json['etag']),
      lastModified: serializer.fromJson<String?>(json['lastModified']),
      jsonHash: serializer.fromJson<String?>(json['jsonHash']),
      questionCount: serializer.fromJson<int>(json['questionCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      consecutiveFailures: serializer.fromJson<int>(
        json['consecutiveFailures'],
      ),
      nextAutomaticAttemptAt: serializer.fromJson<DateTime?>(
        json['nextAutomaticAttemptAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'singleton': serializer.toJson<int>(singleton),
      'lastCheckAttemptAt': serializer.toJson<DateTime?>(lastCheckAttemptAt),
      'lastSuccessfulCheckAt': serializer.toJson<DateTime?>(
        lastSuccessfulCheckAt,
      ),
      'lastSuccessfulUpdateAt': serializer.toJson<DateTime?>(
        lastSuccessfulUpdateAt,
      ),
      'etag': serializer.toJson<String?>(etag),
      'lastModified': serializer.toJson<String?>(lastModified),
      'jsonHash': serializer.toJson<String?>(jsonHash),
      'questionCount': serializer.toJson<int>(questionCount),
      'lastError': serializer.toJson<String?>(lastError),
      'consecutiveFailures': serializer.toJson<int>(consecutiveFailures),
      'nextAutomaticAttemptAt': serializer.toJson<DateTime?>(
        nextAutomaticAttemptAt,
      ),
    };
  }

  CitizenshipSyncMetadataData copyWith({
    int? singleton,
    Value<DateTime?> lastCheckAttemptAt = const Value.absent(),
    Value<DateTime?> lastSuccessfulCheckAt = const Value.absent(),
    Value<DateTime?> lastSuccessfulUpdateAt = const Value.absent(),
    Value<String?> etag = const Value.absent(),
    Value<String?> lastModified = const Value.absent(),
    Value<String?> jsonHash = const Value.absent(),
    int? questionCount,
    Value<String?> lastError = const Value.absent(),
    int? consecutiveFailures,
    Value<DateTime?> nextAutomaticAttemptAt = const Value.absent(),
  }) => CitizenshipSyncMetadataData(
    singleton: singleton ?? this.singleton,
    lastCheckAttemptAt: lastCheckAttemptAt.present
        ? lastCheckAttemptAt.value
        : this.lastCheckAttemptAt,
    lastSuccessfulCheckAt: lastSuccessfulCheckAt.present
        ? lastSuccessfulCheckAt.value
        : this.lastSuccessfulCheckAt,
    lastSuccessfulUpdateAt: lastSuccessfulUpdateAt.present
        ? lastSuccessfulUpdateAt.value
        : this.lastSuccessfulUpdateAt,
    etag: etag.present ? etag.value : this.etag,
    lastModified: lastModified.present ? lastModified.value : this.lastModified,
    jsonHash: jsonHash.present ? jsonHash.value : this.jsonHash,
    questionCount: questionCount ?? this.questionCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    consecutiveFailures: consecutiveFailures ?? this.consecutiveFailures,
    nextAutomaticAttemptAt: nextAutomaticAttemptAt.present
        ? nextAutomaticAttemptAt.value
        : this.nextAutomaticAttemptAt,
  );
  CitizenshipSyncMetadataData copyWithCompanion(
    CitizenshipSyncMetadataCompanion data,
  ) {
    return CitizenshipSyncMetadataData(
      singleton: data.singleton.present ? data.singleton.value : this.singleton,
      lastCheckAttemptAt: data.lastCheckAttemptAt.present
          ? data.lastCheckAttemptAt.value
          : this.lastCheckAttemptAt,
      lastSuccessfulCheckAt: data.lastSuccessfulCheckAt.present
          ? data.lastSuccessfulCheckAt.value
          : this.lastSuccessfulCheckAt,
      lastSuccessfulUpdateAt: data.lastSuccessfulUpdateAt.present
          ? data.lastSuccessfulUpdateAt.value
          : this.lastSuccessfulUpdateAt,
      etag: data.etag.present ? data.etag.value : this.etag,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      jsonHash: data.jsonHash.present ? data.jsonHash.value : this.jsonHash,
      questionCount: data.questionCount.present
          ? data.questionCount.value
          : this.questionCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      consecutiveFailures: data.consecutiveFailures.present
          ? data.consecutiveFailures.value
          : this.consecutiveFailures,
      nextAutomaticAttemptAt: data.nextAutomaticAttemptAt.present
          ? data.nextAutomaticAttemptAt.value
          : this.nextAutomaticAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipSyncMetadataData(')
          ..write('singleton: $singleton, ')
          ..write('lastCheckAttemptAt: $lastCheckAttemptAt, ')
          ..write('lastSuccessfulCheckAt: $lastSuccessfulCheckAt, ')
          ..write('lastSuccessfulUpdateAt: $lastSuccessfulUpdateAt, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('jsonHash: $jsonHash, ')
          ..write('questionCount: $questionCount, ')
          ..write('lastError: $lastError, ')
          ..write('consecutiveFailures: $consecutiveFailures, ')
          ..write('nextAutomaticAttemptAt: $nextAutomaticAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    singleton,
    lastCheckAttemptAt,
    lastSuccessfulCheckAt,
    lastSuccessfulUpdateAt,
    etag,
    lastModified,
    jsonHash,
    questionCount,
    lastError,
    consecutiveFailures,
    nextAutomaticAttemptAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitizenshipSyncMetadataData &&
          other.singleton == this.singleton &&
          other.lastCheckAttemptAt == this.lastCheckAttemptAt &&
          other.lastSuccessfulCheckAt == this.lastSuccessfulCheckAt &&
          other.lastSuccessfulUpdateAt == this.lastSuccessfulUpdateAt &&
          other.etag == this.etag &&
          other.lastModified == this.lastModified &&
          other.jsonHash == this.jsonHash &&
          other.questionCount == this.questionCount &&
          other.lastError == this.lastError &&
          other.consecutiveFailures == this.consecutiveFailures &&
          other.nextAutomaticAttemptAt == this.nextAutomaticAttemptAt);
}

class CitizenshipSyncMetadataCompanion
    extends UpdateCompanion<CitizenshipSyncMetadataData> {
  final Value<int> singleton;
  final Value<DateTime?> lastCheckAttemptAt;
  final Value<DateTime?> lastSuccessfulCheckAt;
  final Value<DateTime?> lastSuccessfulUpdateAt;
  final Value<String?> etag;
  final Value<String?> lastModified;
  final Value<String?> jsonHash;
  final Value<int> questionCount;
  final Value<String?> lastError;
  final Value<int> consecutiveFailures;
  final Value<DateTime?> nextAutomaticAttemptAt;
  const CitizenshipSyncMetadataCompanion({
    this.singleton = const Value.absent(),
    this.lastCheckAttemptAt = const Value.absent(),
    this.lastSuccessfulCheckAt = const Value.absent(),
    this.lastSuccessfulUpdateAt = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.jsonHash = const Value.absent(),
    this.questionCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.consecutiveFailures = const Value.absent(),
    this.nextAutomaticAttemptAt = const Value.absent(),
  });
  CitizenshipSyncMetadataCompanion.insert({
    this.singleton = const Value.absent(),
    this.lastCheckAttemptAt = const Value.absent(),
    this.lastSuccessfulCheckAt = const Value.absent(),
    this.lastSuccessfulUpdateAt = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.jsonHash = const Value.absent(),
    this.questionCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.consecutiveFailures = const Value.absent(),
    this.nextAutomaticAttemptAt = const Value.absent(),
  });
  static Insertable<CitizenshipSyncMetadataData> custom({
    Expression<int>? singleton,
    Expression<DateTime>? lastCheckAttemptAt,
    Expression<DateTime>? lastSuccessfulCheckAt,
    Expression<DateTime>? lastSuccessfulUpdateAt,
    Expression<String>? etag,
    Expression<String>? lastModified,
    Expression<String>? jsonHash,
    Expression<int>? questionCount,
    Expression<String>? lastError,
    Expression<int>? consecutiveFailures,
    Expression<DateTime>? nextAutomaticAttemptAt,
  }) {
    return RawValuesInsertable({
      if (singleton != null) 'singleton': singleton,
      if (lastCheckAttemptAt != null)
        'last_check_attempt_at': lastCheckAttemptAt,
      if (lastSuccessfulCheckAt != null)
        'last_successful_check_at': lastSuccessfulCheckAt,
      if (lastSuccessfulUpdateAt != null)
        'last_successful_update_at': lastSuccessfulUpdateAt,
      if (etag != null) 'etag': etag,
      if (lastModified != null) 'last_modified': lastModified,
      if (jsonHash != null) 'json_hash': jsonHash,
      if (questionCount != null) 'question_count': questionCount,
      if (lastError != null) 'last_error': lastError,
      if (consecutiveFailures != null)
        'consecutive_failures': consecutiveFailures,
      if (nextAutomaticAttemptAt != null)
        'next_automatic_attempt_at': nextAutomaticAttemptAt,
    });
  }

  CitizenshipSyncMetadataCompanion copyWith({
    Value<int>? singleton,
    Value<DateTime?>? lastCheckAttemptAt,
    Value<DateTime?>? lastSuccessfulCheckAt,
    Value<DateTime?>? lastSuccessfulUpdateAt,
    Value<String?>? etag,
    Value<String?>? lastModified,
    Value<String?>? jsonHash,
    Value<int>? questionCount,
    Value<String?>? lastError,
    Value<int>? consecutiveFailures,
    Value<DateTime?>? nextAutomaticAttemptAt,
  }) {
    return CitizenshipSyncMetadataCompanion(
      singleton: singleton ?? this.singleton,
      lastCheckAttemptAt: lastCheckAttemptAt ?? this.lastCheckAttemptAt,
      lastSuccessfulCheckAt:
          lastSuccessfulCheckAt ?? this.lastSuccessfulCheckAt,
      lastSuccessfulUpdateAt:
          lastSuccessfulUpdateAt ?? this.lastSuccessfulUpdateAt,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      jsonHash: jsonHash ?? this.jsonHash,
      questionCount: questionCount ?? this.questionCount,
      lastError: lastError ?? this.lastError,
      consecutiveFailures: consecutiveFailures ?? this.consecutiveFailures,
      nextAutomaticAttemptAt:
          nextAutomaticAttemptAt ?? this.nextAutomaticAttemptAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (singleton.present) {
      map['singleton'] = Variable<int>(singleton.value);
    }
    if (lastCheckAttemptAt.present) {
      map['last_check_attempt_at'] = Variable<DateTime>(
        lastCheckAttemptAt.value,
      );
    }
    if (lastSuccessfulCheckAt.present) {
      map['last_successful_check_at'] = Variable<DateTime>(
        lastSuccessfulCheckAt.value,
      );
    }
    if (lastSuccessfulUpdateAt.present) {
      map['last_successful_update_at'] = Variable<DateTime>(
        lastSuccessfulUpdateAt.value,
      );
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<String>(lastModified.value);
    }
    if (jsonHash.present) {
      map['json_hash'] = Variable<String>(jsonHash.value);
    }
    if (questionCount.present) {
      map['question_count'] = Variable<int>(questionCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (consecutiveFailures.present) {
      map['consecutive_failures'] = Variable<int>(consecutiveFailures.value);
    }
    if (nextAutomaticAttemptAt.present) {
      map['next_automatic_attempt_at'] = Variable<DateTime>(
        nextAutomaticAttemptAt.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipSyncMetadataCompanion(')
          ..write('singleton: $singleton, ')
          ..write('lastCheckAttemptAt: $lastCheckAttemptAt, ')
          ..write('lastSuccessfulCheckAt: $lastSuccessfulCheckAt, ')
          ..write('lastSuccessfulUpdateAt: $lastSuccessfulUpdateAt, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('jsonHash: $jsonHash, ')
          ..write('questionCount: $questionCount, ')
          ..write('lastError: $lastError, ')
          ..write('consecutiveFailures: $consecutiveFailures, ')
          ..write('nextAutomaticAttemptAt: $nextAutomaticAttemptAt')
          ..write(')'))
        .toString();
  }
}

class $CitizenshipProgressTable extends CitizenshipProgress
    with TableInfo<$CitizenshipProgressTable, CitizenshipProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitizenshipProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _incorrectMeta = const VerificationMeta(
    'incorrect',
  );
  @override
  late final GeneratedColumn<int> incorrect = GeneratedColumn<int>(
    'incorrect',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSelectedAnswerMeta =
      const VerificationMeta('lastSelectedAnswer');
  @override
  late final GeneratedColumn<int> lastSelectedAnswer = GeneratedColumn<int>(
    'last_selected_answer',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastAnsweredAtMeta = const VerificationMeta(
    'lastAnsweredAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAnsweredAt =
      GeneratedColumn<DateTime>(
        'last_answered_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isMasteredMeta = const VerificationMeta(
    'isMastered',
  );
  @override
  late final GeneratedColumn<bool> isMastered = GeneratedColumn<bool>(
    'is_mastered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_mastered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    questionId,
    attempts,
    correct,
    incorrect,
    lastSelectedAnswer,
    lastAnsweredAt,
    isFavorite,
    isMastered,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'citizenship_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<CitizenshipProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    }
    if (data.containsKey('incorrect')) {
      context.handle(
        _incorrectMeta,
        incorrect.isAcceptableOrUnknown(data['incorrect']!, _incorrectMeta),
      );
    }
    if (data.containsKey('last_selected_answer')) {
      context.handle(
        _lastSelectedAnswerMeta,
        lastSelectedAnswer.isAcceptableOrUnknown(
          data['last_selected_answer']!,
          _lastSelectedAnswerMeta,
        ),
      );
    }
    if (data.containsKey('last_answered_at')) {
      context.handle(
        _lastAnsweredAtMeta,
        lastAnsweredAt.isAcceptableOrUnknown(
          data['last_answered_at']!,
          _lastAnsweredAtMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_mastered')) {
      context.handle(
        _isMasteredMeta,
        isMastered.isAcceptableOrUnknown(data['is_mastered']!, _isMasteredMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questionId};
  @override
  CitizenshipProgressData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CitizenshipProgressData(
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct'],
      )!,
      incorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}incorrect'],
      )!,
      lastSelectedAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_selected_answer'],
      ),
      lastAnsweredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_answered_at'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      isMastered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_mastered'],
      )!,
    );
  }

  @override
  $CitizenshipProgressTable createAlias(String alias) {
    return $CitizenshipProgressTable(attachedDatabase, alias);
  }
}

class CitizenshipProgressData extends DataClass
    implements Insertable<CitizenshipProgressData> {
  final String questionId;
  final int attempts;
  final int correct;
  final int incorrect;
  final int? lastSelectedAnswer;
  final DateTime? lastAnsweredAt;
  final bool isFavorite;
  final bool isMastered;
  const CitizenshipProgressData({
    required this.questionId,
    required this.attempts,
    required this.correct,
    required this.incorrect,
    this.lastSelectedAnswer,
    this.lastAnsweredAt,
    required this.isFavorite,
    required this.isMastered,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['question_id'] = Variable<String>(questionId);
    map['attempts'] = Variable<int>(attempts);
    map['correct'] = Variable<int>(correct);
    map['incorrect'] = Variable<int>(incorrect);
    if (!nullToAbsent || lastSelectedAnswer != null) {
      map['last_selected_answer'] = Variable<int>(lastSelectedAnswer);
    }
    if (!nullToAbsent || lastAnsweredAt != null) {
      map['last_answered_at'] = Variable<DateTime>(lastAnsweredAt);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_mastered'] = Variable<bool>(isMastered);
    return map;
  }

  CitizenshipProgressCompanion toCompanion(bool nullToAbsent) {
    return CitizenshipProgressCompanion(
      questionId: Value(questionId),
      attempts: Value(attempts),
      correct: Value(correct),
      incorrect: Value(incorrect),
      lastSelectedAnswer: lastSelectedAnswer == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSelectedAnswer),
      lastAnsweredAt: lastAnsweredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAnsweredAt),
      isFavorite: Value(isFavorite),
      isMastered: Value(isMastered),
    );
  }

  factory CitizenshipProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitizenshipProgressData(
      questionId: serializer.fromJson<String>(json['questionId']),
      attempts: serializer.fromJson<int>(json['attempts']),
      correct: serializer.fromJson<int>(json['correct']),
      incorrect: serializer.fromJson<int>(json['incorrect']),
      lastSelectedAnswer: serializer.fromJson<int?>(json['lastSelectedAnswer']),
      lastAnsweredAt: serializer.fromJson<DateTime?>(json['lastAnsweredAt']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isMastered: serializer.fromJson<bool>(json['isMastered']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questionId': serializer.toJson<String>(questionId),
      'attempts': serializer.toJson<int>(attempts),
      'correct': serializer.toJson<int>(correct),
      'incorrect': serializer.toJson<int>(incorrect),
      'lastSelectedAnswer': serializer.toJson<int?>(lastSelectedAnswer),
      'lastAnsweredAt': serializer.toJson<DateTime?>(lastAnsweredAt),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isMastered': serializer.toJson<bool>(isMastered),
    };
  }

  CitizenshipProgressData copyWith({
    String? questionId,
    int? attempts,
    int? correct,
    int? incorrect,
    Value<int?> lastSelectedAnswer = const Value.absent(),
    Value<DateTime?> lastAnsweredAt = const Value.absent(),
    bool? isFavorite,
    bool? isMastered,
  }) => CitizenshipProgressData(
    questionId: questionId ?? this.questionId,
    attempts: attempts ?? this.attempts,
    correct: correct ?? this.correct,
    incorrect: incorrect ?? this.incorrect,
    lastSelectedAnswer: lastSelectedAnswer.present
        ? lastSelectedAnswer.value
        : this.lastSelectedAnswer,
    lastAnsweredAt: lastAnsweredAt.present
        ? lastAnsweredAt.value
        : this.lastAnsweredAt,
    isFavorite: isFavorite ?? this.isFavorite,
    isMastered: isMastered ?? this.isMastered,
  );
  CitizenshipProgressData copyWithCompanion(CitizenshipProgressCompanion data) {
    return CitizenshipProgressData(
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      correct: data.correct.present ? data.correct.value : this.correct,
      incorrect: data.incorrect.present ? data.incorrect.value : this.incorrect,
      lastSelectedAnswer: data.lastSelectedAnswer.present
          ? data.lastSelectedAnswer.value
          : this.lastSelectedAnswer,
      lastAnsweredAt: data.lastAnsweredAt.present
          ? data.lastAnsweredAt.value
          : this.lastAnsweredAt,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      isMastered: data.isMastered.present
          ? data.isMastered.value
          : this.isMastered,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipProgressData(')
          ..write('questionId: $questionId, ')
          ..write('attempts: $attempts, ')
          ..write('correct: $correct, ')
          ..write('incorrect: $incorrect, ')
          ..write('lastSelectedAnswer: $lastSelectedAnswer, ')
          ..write('lastAnsweredAt: $lastAnsweredAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isMastered: $isMastered')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    questionId,
    attempts,
    correct,
    incorrect,
    lastSelectedAnswer,
    lastAnsweredAt,
    isFavorite,
    isMastered,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitizenshipProgressData &&
          other.questionId == this.questionId &&
          other.attempts == this.attempts &&
          other.correct == this.correct &&
          other.incorrect == this.incorrect &&
          other.lastSelectedAnswer == this.lastSelectedAnswer &&
          other.lastAnsweredAt == this.lastAnsweredAt &&
          other.isFavorite == this.isFavorite &&
          other.isMastered == this.isMastered);
}

class CitizenshipProgressCompanion
    extends UpdateCompanion<CitizenshipProgressData> {
  final Value<String> questionId;
  final Value<int> attempts;
  final Value<int> correct;
  final Value<int> incorrect;
  final Value<int?> lastSelectedAnswer;
  final Value<DateTime?> lastAnsweredAt;
  final Value<bool> isFavorite;
  final Value<bool> isMastered;
  final Value<int> rowid;
  const CitizenshipProgressCompanion({
    this.questionId = const Value.absent(),
    this.attempts = const Value.absent(),
    this.correct = const Value.absent(),
    this.incorrect = const Value.absent(),
    this.lastSelectedAnswer = const Value.absent(),
    this.lastAnsweredAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isMastered = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitizenshipProgressCompanion.insert({
    required String questionId,
    this.attempts = const Value.absent(),
    this.correct = const Value.absent(),
    this.incorrect = const Value.absent(),
    this.lastSelectedAnswer = const Value.absent(),
    this.lastAnsweredAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isMastered = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : questionId = Value(questionId);
  static Insertable<CitizenshipProgressData> custom({
    Expression<String>? questionId,
    Expression<int>? attempts,
    Expression<int>? correct,
    Expression<int>? incorrect,
    Expression<int>? lastSelectedAnswer,
    Expression<DateTime>? lastAnsweredAt,
    Expression<bool>? isFavorite,
    Expression<bool>? isMastered,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questionId != null) 'question_id': questionId,
      if (attempts != null) 'attempts': attempts,
      if (correct != null) 'correct': correct,
      if (incorrect != null) 'incorrect': incorrect,
      if (lastSelectedAnswer != null)
        'last_selected_answer': lastSelectedAnswer,
      if (lastAnsweredAt != null) 'last_answered_at': lastAnsweredAt,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isMastered != null) 'is_mastered': isMastered,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitizenshipProgressCompanion copyWith({
    Value<String>? questionId,
    Value<int>? attempts,
    Value<int>? correct,
    Value<int>? incorrect,
    Value<int?>? lastSelectedAnswer,
    Value<DateTime?>? lastAnsweredAt,
    Value<bool>? isFavorite,
    Value<bool>? isMastered,
    Value<int>? rowid,
  }) {
    return CitizenshipProgressCompanion(
      questionId: questionId ?? this.questionId,
      attempts: attempts ?? this.attempts,
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
      lastSelectedAnswer: lastSelectedAnswer ?? this.lastSelectedAnswer,
      lastAnsweredAt: lastAnsweredAt ?? this.lastAnsweredAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isMastered: isMastered ?? this.isMastered,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (incorrect.present) {
      map['incorrect'] = Variable<int>(incorrect.value);
    }
    if (lastSelectedAnswer.present) {
      map['last_selected_answer'] = Variable<int>(lastSelectedAnswer.value);
    }
    if (lastAnsweredAt.present) {
      map['last_answered_at'] = Variable<DateTime>(lastAnsweredAt.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isMastered.present) {
      map['is_mastered'] = Variable<bool>(isMastered.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipProgressCompanion(')
          ..write('questionId: $questionId, ')
          ..write('attempts: $attempts, ')
          ..write('correct: $correct, ')
          ..write('incorrect: $incorrect, ')
          ..write('lastSelectedAnswer: $lastSelectedAnswer, ')
          ..write('lastAnsweredAt: $lastAnsweredAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isMastered: $isMastered, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitizenshipExamSessionsTable extends CitizenshipExamSessions
    with TableInfo<$CitizenshipExamSessionsTable, CitizenshipExamSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitizenshipExamSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta(
    'stateCode',
  );
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionIdsJsonMeta = const VerificationMeta(
    'questionIdsJson',
  );
  @override
  late final GeneratedColumn<String> questionIdsJson = GeneratedColumn<String>(
    'question_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('exam'),
  );
  static const VerificationMeta _currentIndexMeta = const VerificationMeta(
    'currentIndex',
  );
  @override
  late final GeneratedColumn<int> currentIndex = GeneratedColumn<int>(
    'current_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passedLifeInGermanyMeta =
      const VerificationMeta('passedLifeInGermany');
  @override
  late final GeneratedColumn<bool> passedLifeInGermany = GeneratedColumn<bool>(
    'passed_life_in_germany',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("passed_life_in_germany" IN (0, 1))',
    ),
  );
  static const VerificationMeta _passedCitizenshipMeta = const VerificationMeta(
    'passedCitizenship',
  );
  @override
  late final GeneratedColumn<bool> passedCitizenship = GeneratedColumn<bool>(
    'passed_citizenship',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("passed_citizenship" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stateCode,
    startedAt,
    completedAt,
    questionIdsJson,
    mode,
    currentIndex,
    correctCount,
    passedLifeInGermany,
    passedCitizenship,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'citizenship_exam_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CitizenshipExamSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_stateCodeMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('question_ids_json')) {
      context.handle(
        _questionIdsJsonMeta,
        questionIdsJson.isAcceptableOrUnknown(
          data['question_ids_json']!,
          _questionIdsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionIdsJsonMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('current_index')) {
      context.handle(
        _currentIndexMeta,
        currentIndex.isAcceptableOrUnknown(
          data['current_index']!,
          _currentIndexMeta,
        ),
      );
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    }
    if (data.containsKey('passed_life_in_germany')) {
      context.handle(
        _passedLifeInGermanyMeta,
        passedLifeInGermany.isAcceptableOrUnknown(
          data['passed_life_in_germany']!,
          _passedLifeInGermanyMeta,
        ),
      );
    }
    if (data.containsKey('passed_citizenship')) {
      context.handle(
        _passedCitizenshipMeta,
        passedCitizenship.isAcceptableOrUnknown(
          data['passed_citizenship']!,
          _passedCitizenshipMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CitizenshipExamSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CitizenshipExamSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      questionIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_ids_json'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      currentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_index'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      ),
      passedLifeInGermany: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}passed_life_in_germany'],
      ),
      passedCitizenship: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}passed_citizenship'],
      ),
    );
  }

  @override
  $CitizenshipExamSessionsTable createAlias(String alias) {
    return $CitizenshipExamSessionsTable(attachedDatabase, alias);
  }
}

class CitizenshipExamSession extends DataClass
    implements Insertable<CitizenshipExamSession> {
  final String id;
  final String stateCode;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String questionIdsJson;
  final String mode;
  final int currentIndex;
  final int? correctCount;
  final bool? passedLifeInGermany;
  final bool? passedCitizenship;
  const CitizenshipExamSession({
    required this.id,
    required this.stateCode,
    required this.startedAt,
    this.completedAt,
    required this.questionIdsJson,
    required this.mode,
    required this.currentIndex,
    this.correctCount,
    this.passedLifeInGermany,
    this.passedCitizenship,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['state_code'] = Variable<String>(stateCode);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['question_ids_json'] = Variable<String>(questionIdsJson);
    map['mode'] = Variable<String>(mode);
    map['current_index'] = Variable<int>(currentIndex);
    if (!nullToAbsent || correctCount != null) {
      map['correct_count'] = Variable<int>(correctCount);
    }
    if (!nullToAbsent || passedLifeInGermany != null) {
      map['passed_life_in_germany'] = Variable<bool>(passedLifeInGermany);
    }
    if (!nullToAbsent || passedCitizenship != null) {
      map['passed_citizenship'] = Variable<bool>(passedCitizenship);
    }
    return map;
  }

  CitizenshipExamSessionsCompanion toCompanion(bool nullToAbsent) {
    return CitizenshipExamSessionsCompanion(
      id: Value(id),
      stateCode: Value(stateCode),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      questionIdsJson: Value(questionIdsJson),
      mode: Value(mode),
      currentIndex: Value(currentIndex),
      correctCount: correctCount == null && nullToAbsent
          ? const Value.absent()
          : Value(correctCount),
      passedLifeInGermany: passedLifeInGermany == null && nullToAbsent
          ? const Value.absent()
          : Value(passedLifeInGermany),
      passedCitizenship: passedCitizenship == null && nullToAbsent
          ? const Value.absent()
          : Value(passedCitizenship),
    );
  }

  factory CitizenshipExamSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitizenshipExamSession(
      id: serializer.fromJson<String>(json['id']),
      stateCode: serializer.fromJson<String>(json['stateCode']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      questionIdsJson: serializer.fromJson<String>(json['questionIdsJson']),
      mode: serializer.fromJson<String>(json['mode']),
      currentIndex: serializer.fromJson<int>(json['currentIndex']),
      correctCount: serializer.fromJson<int?>(json['correctCount']),
      passedLifeInGermany: serializer.fromJson<bool?>(
        json['passedLifeInGermany'],
      ),
      passedCitizenship: serializer.fromJson<bool?>(json['passedCitizenship']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'stateCode': serializer.toJson<String>(stateCode),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'questionIdsJson': serializer.toJson<String>(questionIdsJson),
      'mode': serializer.toJson<String>(mode),
      'currentIndex': serializer.toJson<int>(currentIndex),
      'correctCount': serializer.toJson<int?>(correctCount),
      'passedLifeInGermany': serializer.toJson<bool?>(passedLifeInGermany),
      'passedCitizenship': serializer.toJson<bool?>(passedCitizenship),
    };
  }

  CitizenshipExamSession copyWith({
    String? id,
    String? stateCode,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    String? questionIdsJson,
    String? mode,
    int? currentIndex,
    Value<int?> correctCount = const Value.absent(),
    Value<bool?> passedLifeInGermany = const Value.absent(),
    Value<bool?> passedCitizenship = const Value.absent(),
  }) => CitizenshipExamSession(
    id: id ?? this.id,
    stateCode: stateCode ?? this.stateCode,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    questionIdsJson: questionIdsJson ?? this.questionIdsJson,
    mode: mode ?? this.mode,
    currentIndex: currentIndex ?? this.currentIndex,
    correctCount: correctCount.present ? correctCount.value : this.correctCount,
    passedLifeInGermany: passedLifeInGermany.present
        ? passedLifeInGermany.value
        : this.passedLifeInGermany,
    passedCitizenship: passedCitizenship.present
        ? passedCitizenship.value
        : this.passedCitizenship,
  );
  CitizenshipExamSession copyWithCompanion(
    CitizenshipExamSessionsCompanion data,
  ) {
    return CitizenshipExamSession(
      id: data.id.present ? data.id.value : this.id,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      questionIdsJson: data.questionIdsJson.present
          ? data.questionIdsJson.value
          : this.questionIdsJson,
      mode: data.mode.present ? data.mode.value : this.mode,
      currentIndex: data.currentIndex.present
          ? data.currentIndex.value
          : this.currentIndex,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      passedLifeInGermany: data.passedLifeInGermany.present
          ? data.passedLifeInGermany.value
          : this.passedLifeInGermany,
      passedCitizenship: data.passedCitizenship.present
          ? data.passedCitizenship.value
          : this.passedCitizenship,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipExamSession(')
          ..write('id: $id, ')
          ..write('stateCode: $stateCode, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('questionIdsJson: $questionIdsJson, ')
          ..write('mode: $mode, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('correctCount: $correctCount, ')
          ..write('passedLifeInGermany: $passedLifeInGermany, ')
          ..write('passedCitizenship: $passedCitizenship')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    stateCode,
    startedAt,
    completedAt,
    questionIdsJson,
    mode,
    currentIndex,
    correctCount,
    passedLifeInGermany,
    passedCitizenship,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitizenshipExamSession &&
          other.id == this.id &&
          other.stateCode == this.stateCode &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.questionIdsJson == this.questionIdsJson &&
          other.mode == this.mode &&
          other.currentIndex == this.currentIndex &&
          other.correctCount == this.correctCount &&
          other.passedLifeInGermany == this.passedLifeInGermany &&
          other.passedCitizenship == this.passedCitizenship);
}

class CitizenshipExamSessionsCompanion
    extends UpdateCompanion<CitizenshipExamSession> {
  final Value<String> id;
  final Value<String> stateCode;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String> questionIdsJson;
  final Value<String> mode;
  final Value<int> currentIndex;
  final Value<int?> correctCount;
  final Value<bool?> passedLifeInGermany;
  final Value<bool?> passedCitizenship;
  final Value<int> rowid;
  const CitizenshipExamSessionsCompanion({
    this.id = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.questionIdsJson = const Value.absent(),
    this.mode = const Value.absent(),
    this.currentIndex = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.passedLifeInGermany = const Value.absent(),
    this.passedCitizenship = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitizenshipExamSessionsCompanion.insert({
    required String id,
    required String stateCode,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    required String questionIdsJson,
    this.mode = const Value.absent(),
    this.currentIndex = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.passedLifeInGermany = const Value.absent(),
    this.passedCitizenship = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       stateCode = Value(stateCode),
       startedAt = Value(startedAt),
       questionIdsJson = Value(questionIdsJson);
  static Insertable<CitizenshipExamSession> custom({
    Expression<String>? id,
    Expression<String>? stateCode,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? questionIdsJson,
    Expression<String>? mode,
    Expression<int>? currentIndex,
    Expression<int>? correctCount,
    Expression<bool>? passedLifeInGermany,
    Expression<bool>? passedCitizenship,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stateCode != null) 'state_code': stateCode,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (questionIdsJson != null) 'question_ids_json': questionIdsJson,
      if (mode != null) 'mode': mode,
      if (currentIndex != null) 'current_index': currentIndex,
      if (correctCount != null) 'correct_count': correctCount,
      if (passedLifeInGermany != null)
        'passed_life_in_germany': passedLifeInGermany,
      if (passedCitizenship != null) 'passed_citizenship': passedCitizenship,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitizenshipExamSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? stateCode,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<String>? questionIdsJson,
    Value<String>? mode,
    Value<int>? currentIndex,
    Value<int?>? correctCount,
    Value<bool?>? passedLifeInGermany,
    Value<bool?>? passedCitizenship,
    Value<int>? rowid,
  }) {
    return CitizenshipExamSessionsCompanion(
      id: id ?? this.id,
      stateCode: stateCode ?? this.stateCode,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      questionIdsJson: questionIdsJson ?? this.questionIdsJson,
      mode: mode ?? this.mode,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      passedLifeInGermany: passedLifeInGermany ?? this.passedLifeInGermany,
      passedCitizenship: passedCitizenship ?? this.passedCitizenship,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (questionIdsJson.present) {
      map['question_ids_json'] = Variable<String>(questionIdsJson.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (currentIndex.present) {
      map['current_index'] = Variable<int>(currentIndex.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (passedLifeInGermany.present) {
      map['passed_life_in_germany'] = Variable<bool>(passedLifeInGermany.value);
    }
    if (passedCitizenship.present) {
      map['passed_citizenship'] = Variable<bool>(passedCitizenship.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipExamSessionsCompanion(')
          ..write('id: $id, ')
          ..write('stateCode: $stateCode, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('questionIdsJson: $questionIdsJson, ')
          ..write('mode: $mode, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('correctCount: $correctCount, ')
          ..write('passedLifeInGermany: $passedLifeInGermany, ')
          ..write('passedCitizenship: $passedCitizenship, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitizenshipExamAnswersTable extends CitizenshipExamAnswers
    with TableInfo<$CitizenshipExamAnswersTable, CitizenshipExamAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitizenshipExamAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedAnswerMeta = const VerificationMeta(
    'selectedAnswer',
  );
  @override
  late final GeneratedColumn<int> selectedAnswer = GeneratedColumn<int>(
    'selected_answer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    questionId,
    selectedAnswer,
    isCorrect,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'citizenship_exam_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CitizenshipExamAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('selected_answer')) {
      context.handle(
        _selectedAnswerMeta,
        selectedAnswer.isAcceptableOrUnknown(
          data['selected_answer']!,
          _selectedAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedAnswerMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId, questionId};
  @override
  CitizenshipExamAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CitizenshipExamAnswer(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      selectedAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_answer'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
    );
  }

  @override
  $CitizenshipExamAnswersTable createAlias(String alias) {
    return $CitizenshipExamAnswersTable(attachedDatabase, alias);
  }
}

class CitizenshipExamAnswer extends DataClass
    implements Insertable<CitizenshipExamAnswer> {
  final String sessionId;
  final String questionId;
  final int selectedAnswer;
  final bool isCorrect;
  const CitizenshipExamAnswer({
    required this.sessionId,
    required this.questionId,
    required this.selectedAnswer,
    required this.isCorrect,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['question_id'] = Variable<String>(questionId);
    map['selected_answer'] = Variable<int>(selectedAnswer);
    map['is_correct'] = Variable<bool>(isCorrect);
    return map;
  }

  CitizenshipExamAnswersCompanion toCompanion(bool nullToAbsent) {
    return CitizenshipExamAnswersCompanion(
      sessionId: Value(sessionId),
      questionId: Value(questionId),
      selectedAnswer: Value(selectedAnswer),
      isCorrect: Value(isCorrect),
    );
  }

  factory CitizenshipExamAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CitizenshipExamAnswer(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      selectedAnswer: serializer.fromJson<int>(json['selectedAnswer']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'questionId': serializer.toJson<String>(questionId),
      'selectedAnswer': serializer.toJson<int>(selectedAnswer),
      'isCorrect': serializer.toJson<bool>(isCorrect),
    };
  }

  CitizenshipExamAnswer copyWith({
    String? sessionId,
    String? questionId,
    int? selectedAnswer,
    bool? isCorrect,
  }) => CitizenshipExamAnswer(
    sessionId: sessionId ?? this.sessionId,
    questionId: questionId ?? this.questionId,
    selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    isCorrect: isCorrect ?? this.isCorrect,
  );
  CitizenshipExamAnswer copyWithCompanion(
    CitizenshipExamAnswersCompanion data,
  ) {
    return CitizenshipExamAnswer(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      selectedAnswer: data.selectedAnswer.present
          ? data.selectedAnswer.value
          : this.selectedAnswer,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipExamAnswer(')
          ..write('sessionId: $sessionId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sessionId, questionId, selectedAnswer, isCorrect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CitizenshipExamAnswer &&
          other.sessionId == this.sessionId &&
          other.questionId == this.questionId &&
          other.selectedAnswer == this.selectedAnswer &&
          other.isCorrect == this.isCorrect);
}

class CitizenshipExamAnswersCompanion
    extends UpdateCompanion<CitizenshipExamAnswer> {
  final Value<String> sessionId;
  final Value<String> questionId;
  final Value<int> selectedAnswer;
  final Value<bool> isCorrect;
  final Value<int> rowid;
  const CitizenshipExamAnswersCompanion({
    this.sessionId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.selectedAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitizenshipExamAnswersCompanion.insert({
    required String sessionId,
    required String questionId,
    required int selectedAnswer,
    required bool isCorrect,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       questionId = Value(questionId),
       selectedAnswer = Value(selectedAnswer),
       isCorrect = Value(isCorrect);
  static Insertable<CitizenshipExamAnswer> custom({
    Expression<String>? sessionId,
    Expression<String>? questionId,
    Expression<int>? selectedAnswer,
    Expression<bool>? isCorrect,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (questionId != null) 'question_id': questionId,
      if (selectedAnswer != null) 'selected_answer': selectedAnswer,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitizenshipExamAnswersCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? questionId,
    Value<int>? selectedAnswer,
    Value<bool>? isCorrect,
    Value<int>? rowid,
  }) {
    return CitizenshipExamAnswersCompanion(
      sessionId: sessionId ?? this.sessionId,
      questionId: questionId ?? this.questionId,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (selectedAnswer.present) {
      map['selected_answer'] = Variable<int>(selectedAnswer.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitizenshipExamAnswersCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CitizenshipTestDatabase extends GeneratedDatabase {
  _$CitizenshipTestDatabase(QueryExecutor e) : super(e);
  $CitizenshipTestDatabaseManager get managers =>
      $CitizenshipTestDatabaseManager(this);
  late final $CitizenshipDatasetsTable citizenshipDatasets =
      $CitizenshipDatasetsTable(this);
  late final $CitizenshipQuestionsTable citizenshipQuestions =
      $CitizenshipQuestionsTable(this);
  late final $CitizenshipMediaTable citizenshipMedia = $CitizenshipMediaTable(
    this,
  );
  late final $CitizenshipQuestionImagesTable citizenshipQuestionImages =
      $CitizenshipQuestionImagesTable(this);
  late final $CitizenshipSyncMetadataTable citizenshipSyncMetadata =
      $CitizenshipSyncMetadataTable(this);
  late final $CitizenshipProgressTable citizenshipProgress =
      $CitizenshipProgressTable(this);
  late final $CitizenshipExamSessionsTable citizenshipExamSessions =
      $CitizenshipExamSessionsTable(this);
  late final $CitizenshipExamAnswersTable citizenshipExamAnswers =
      $CitizenshipExamAnswersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    citizenshipDatasets,
    citizenshipQuestions,
    citizenshipMedia,
    citizenshipQuestionImages,
    citizenshipSyncMetadata,
    citizenshipProgress,
    citizenshipExamSessions,
    citizenshipExamAnswers,
  ];
}

typedef $$CitizenshipDatasetsTableCreateCompanionBuilder =
    CitizenshipDatasetsCompanion Function({
      required String id,
      required String status,
      required DateTime createdAt,
      required String sourceHash,
      required int questionCount,
      Value<int> rowid,
    });
typedef $$CitizenshipDatasetsTableUpdateCompanionBuilder =
    CitizenshipDatasetsCompanion Function({
      Value<String> id,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<String> sourceHash,
      Value<int> questionCount,
      Value<int> rowid,
    });

class $$CitizenshipDatasetsTableFilterComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipDatasetsTable> {
  $$CitizenshipDatasetsTableFilterComposer({
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

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CitizenshipDatasetsTableOrderingComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipDatasetsTable> {
  $$CitizenshipDatasetsTableOrderingComposer({
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CitizenshipDatasetsTableAnnotationComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipDatasetsTable> {
  $$CitizenshipDatasetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => column,
  );

  GeneratedColumn<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => column,
  );
}

class $$CitizenshipDatasetsTableTableManager
    extends
        RootTableManager<
          _$CitizenshipTestDatabase,
          $CitizenshipDatasetsTable,
          CitizenshipDataset,
          $$CitizenshipDatasetsTableFilterComposer,
          $$CitizenshipDatasetsTableOrderingComposer,
          $$CitizenshipDatasetsTableAnnotationComposer,
          $$CitizenshipDatasetsTableCreateCompanionBuilder,
          $$CitizenshipDatasetsTableUpdateCompanionBuilder,
          (
            CitizenshipDataset,
            BaseReferences<
              _$CitizenshipTestDatabase,
              $CitizenshipDatasetsTable,
              CitizenshipDataset
            >,
          ),
          CitizenshipDataset,
          PrefetchHooks Function()
        > {
  $$CitizenshipDatasetsTableTableManager(
    _$CitizenshipTestDatabase db,
    $CitizenshipDatasetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitizenshipDatasetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CitizenshipDatasetsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CitizenshipDatasetsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> sourceHash = const Value.absent(),
                Value<int> questionCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipDatasetsCompanion(
                id: id,
                status: status,
                createdAt: createdAt,
                sourceHash: sourceHash,
                questionCount: questionCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String status,
                required DateTime createdAt,
                required String sourceHash,
                required int questionCount,
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipDatasetsCompanion.insert(
                id: id,
                status: status,
                createdAt: createdAt,
                sourceHash: sourceHash,
                questionCount: questionCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CitizenshipDatasetsTableProcessedTableManager =
    ProcessedTableManager<
      _$CitizenshipTestDatabase,
      $CitizenshipDatasetsTable,
      CitizenshipDataset,
      $$CitizenshipDatasetsTableFilterComposer,
      $$CitizenshipDatasetsTableOrderingComposer,
      $$CitizenshipDatasetsTableAnnotationComposer,
      $$CitizenshipDatasetsTableCreateCompanionBuilder,
      $$CitizenshipDatasetsTableUpdateCompanionBuilder,
      (
        CitizenshipDataset,
        BaseReferences<
          _$CitizenshipTestDatabase,
          $CitizenshipDatasetsTable,
          CitizenshipDataset
        >,
      ),
      CitizenshipDataset,
      PrefetchHooks Function()
    >;
typedef $$CitizenshipQuestionsTableCreateCompanionBuilder =
    CitizenshipQuestionsCompanion Function({
      required String datasetId,
      required String id,
      required String num,
      required String question,
      required String answerA,
      required String answerB,
      required String answerC,
      required String answerD,
      required int correctAnswer,
      required int sortOrder,
      required String scope,
      Value<String?> stateCode,
      Value<String?> imageUrl,
      Value<String?> mediaKey,
      Value<bool> imageRequired,
      Value<int> rowid,
    });
typedef $$CitizenshipQuestionsTableUpdateCompanionBuilder =
    CitizenshipQuestionsCompanion Function({
      Value<String> datasetId,
      Value<String> id,
      Value<String> num,
      Value<String> question,
      Value<String> answerA,
      Value<String> answerB,
      Value<String> answerC,
      Value<String> answerD,
      Value<int> correctAnswer,
      Value<int> sortOrder,
      Value<String> scope,
      Value<String?> stateCode,
      Value<String?> imageUrl,
      Value<String?> mediaKey,
      Value<bool> imageRequired,
      Value<int> rowid,
    });

class $$CitizenshipQuestionsTableFilterComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipQuestionsTable> {
  $$CitizenshipQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get datasetId => $composableBuilder(
    column: $table.datasetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get num => $composableBuilder(
    column: $table.num,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerA => $composableBuilder(
    column: $table.answerA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerB => $composableBuilder(
    column: $table.answerB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerC => $composableBuilder(
    column: $table.answerC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerD => $composableBuilder(
    column: $table.answerD,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaKey => $composableBuilder(
    column: $table.mediaKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get imageRequired => $composableBuilder(
    column: $table.imageRequired,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CitizenshipQuestionsTableOrderingComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipQuestionsTable> {
  $$CitizenshipQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get datasetId => $composableBuilder(
    column: $table.datasetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get num => $composableBuilder(
    column: $table.num,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerA => $composableBuilder(
    column: $table.answerA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerB => $composableBuilder(
    column: $table.answerB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerC => $composableBuilder(
    column: $table.answerC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerD => $composableBuilder(
    column: $table.answerD,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaKey => $composableBuilder(
    column: $table.mediaKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get imageRequired => $composableBuilder(
    column: $table.imageRequired,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CitizenshipQuestionsTableAnnotationComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipQuestionsTable> {
  $$CitizenshipQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get datasetId =>
      $composableBuilder(column: $table.datasetId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get num =>
      $composableBuilder(column: $table.num, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get answerA =>
      $composableBuilder(column: $table.answerA, builder: (column) => column);

  GeneratedColumn<String> get answerB =>
      $composableBuilder(column: $table.answerB, builder: (column) => column);

  GeneratedColumn<String> get answerC =>
      $composableBuilder(column: $table.answerC, builder: (column) => column);

  GeneratedColumn<String> get answerD =>
      $composableBuilder(column: $table.answerD, builder: (column) => column);

  GeneratedColumn<int> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get mediaKey =>
      $composableBuilder(column: $table.mediaKey, builder: (column) => column);

  GeneratedColumn<bool> get imageRequired => $composableBuilder(
    column: $table.imageRequired,
    builder: (column) => column,
  );
}

class $$CitizenshipQuestionsTableTableManager
    extends
        RootTableManager<
          _$CitizenshipTestDatabase,
          $CitizenshipQuestionsTable,
          CitizenshipQuestion,
          $$CitizenshipQuestionsTableFilterComposer,
          $$CitizenshipQuestionsTableOrderingComposer,
          $$CitizenshipQuestionsTableAnnotationComposer,
          $$CitizenshipQuestionsTableCreateCompanionBuilder,
          $$CitizenshipQuestionsTableUpdateCompanionBuilder,
          (
            CitizenshipQuestion,
            BaseReferences<
              _$CitizenshipTestDatabase,
              $CitizenshipQuestionsTable,
              CitizenshipQuestion
            >,
          ),
          CitizenshipQuestion,
          PrefetchHooks Function()
        > {
  $$CitizenshipQuestionsTableTableManager(
    _$CitizenshipTestDatabase db,
    $CitizenshipQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitizenshipQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CitizenshipQuestionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CitizenshipQuestionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> datasetId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> num = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<String> answerA = const Value.absent(),
                Value<String> answerB = const Value.absent(),
                Value<String> answerC = const Value.absent(),
                Value<String> answerD = const Value.absent(),
                Value<int> correctAnswer = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> mediaKey = const Value.absent(),
                Value<bool> imageRequired = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipQuestionsCompanion(
                datasetId: datasetId,
                id: id,
                num: num,
                question: question,
                answerA: answerA,
                answerB: answerB,
                answerC: answerC,
                answerD: answerD,
                correctAnswer: correctAnswer,
                sortOrder: sortOrder,
                scope: scope,
                stateCode: stateCode,
                imageUrl: imageUrl,
                mediaKey: mediaKey,
                imageRequired: imageRequired,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String datasetId,
                required String id,
                required String num,
                required String question,
                required String answerA,
                required String answerB,
                required String answerC,
                required String answerD,
                required int correctAnswer,
                required int sortOrder,
                required String scope,
                Value<String?> stateCode = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> mediaKey = const Value.absent(),
                Value<bool> imageRequired = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipQuestionsCompanion.insert(
                datasetId: datasetId,
                id: id,
                num: num,
                question: question,
                answerA: answerA,
                answerB: answerB,
                answerC: answerC,
                answerD: answerD,
                correctAnswer: correctAnswer,
                sortOrder: sortOrder,
                scope: scope,
                stateCode: stateCode,
                imageUrl: imageUrl,
                mediaKey: mediaKey,
                imageRequired: imageRequired,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CitizenshipQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$CitizenshipTestDatabase,
      $CitizenshipQuestionsTable,
      CitizenshipQuestion,
      $$CitizenshipQuestionsTableFilterComposer,
      $$CitizenshipQuestionsTableOrderingComposer,
      $$CitizenshipQuestionsTableAnnotationComposer,
      $$CitizenshipQuestionsTableCreateCompanionBuilder,
      $$CitizenshipQuestionsTableUpdateCompanionBuilder,
      (
        CitizenshipQuestion,
        BaseReferences<
          _$CitizenshipTestDatabase,
          $CitizenshipQuestionsTable,
          CitizenshipQuestion
        >,
      ),
      CitizenshipQuestion,
      PrefetchHooks Function()
    >;
typedef $$CitizenshipMediaTableCreateCompanionBuilder =
    CitizenshipMediaCompanion Function({
      required String datasetId,
      required String mediaKey,
      required String sourceUrl,
      required String relativePath,
      Value<String?> mimeType,
      Value<String?> contentHash,
      required String status,
      Value<String?> lastError,
      Value<int> retryCount,
      Value<DateTime?> nextRetryAt,
      Value<int> rowid,
    });
typedef $$CitizenshipMediaTableUpdateCompanionBuilder =
    CitizenshipMediaCompanion Function({
      Value<String> datasetId,
      Value<String> mediaKey,
      Value<String> sourceUrl,
      Value<String> relativePath,
      Value<String?> mimeType,
      Value<String?> contentHash,
      Value<String> status,
      Value<String?> lastError,
      Value<int> retryCount,
      Value<DateTime?> nextRetryAt,
      Value<int> rowid,
    });

class $$CitizenshipMediaTableFilterComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipMediaTable> {
  $$CitizenshipMediaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get datasetId => $composableBuilder(
    column: $table.datasetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaKey => $composableBuilder(
    column: $table.mediaKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CitizenshipMediaTableOrderingComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipMediaTable> {
  $$CitizenshipMediaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get datasetId => $composableBuilder(
    column: $table.datasetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaKey => $composableBuilder(
    column: $table.mediaKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CitizenshipMediaTableAnnotationComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipMediaTable> {
  $$CitizenshipMediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get datasetId =>
      $composableBuilder(column: $table.datasetId, builder: (column) => column);

  GeneratedColumn<String> get mediaKey =>
      $composableBuilder(column: $table.mediaKey, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );
}

class $$CitizenshipMediaTableTableManager
    extends
        RootTableManager<
          _$CitizenshipTestDatabase,
          $CitizenshipMediaTable,
          CitizenshipMediaData,
          $$CitizenshipMediaTableFilterComposer,
          $$CitizenshipMediaTableOrderingComposer,
          $$CitizenshipMediaTableAnnotationComposer,
          $$CitizenshipMediaTableCreateCompanionBuilder,
          $$CitizenshipMediaTableUpdateCompanionBuilder,
          (
            CitizenshipMediaData,
            BaseReferences<
              _$CitizenshipTestDatabase,
              $CitizenshipMediaTable,
              CitizenshipMediaData
            >,
          ),
          CitizenshipMediaData,
          PrefetchHooks Function()
        > {
  $$CitizenshipMediaTableTableManager(
    _$CitizenshipTestDatabase db,
    $CitizenshipMediaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitizenshipMediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CitizenshipMediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CitizenshipMediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> datasetId = const Value.absent(),
                Value<String> mediaKey = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<String?> contentHash = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipMediaCompanion(
                datasetId: datasetId,
                mediaKey: mediaKey,
                sourceUrl: sourceUrl,
                relativePath: relativePath,
                mimeType: mimeType,
                contentHash: contentHash,
                status: status,
                lastError: lastError,
                retryCount: retryCount,
                nextRetryAt: nextRetryAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String datasetId,
                required String mediaKey,
                required String sourceUrl,
                required String relativePath,
                Value<String?> mimeType = const Value.absent(),
                Value<String?> contentHash = const Value.absent(),
                required String status,
                Value<String?> lastError = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipMediaCompanion.insert(
                datasetId: datasetId,
                mediaKey: mediaKey,
                sourceUrl: sourceUrl,
                relativePath: relativePath,
                mimeType: mimeType,
                contentHash: contentHash,
                status: status,
                lastError: lastError,
                retryCount: retryCount,
                nextRetryAt: nextRetryAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CitizenshipMediaTableProcessedTableManager =
    ProcessedTableManager<
      _$CitizenshipTestDatabase,
      $CitizenshipMediaTable,
      CitizenshipMediaData,
      $$CitizenshipMediaTableFilterComposer,
      $$CitizenshipMediaTableOrderingComposer,
      $$CitizenshipMediaTableAnnotationComposer,
      $$CitizenshipMediaTableCreateCompanionBuilder,
      $$CitizenshipMediaTableUpdateCompanionBuilder,
      (
        CitizenshipMediaData,
        BaseReferences<
          _$CitizenshipTestDatabase,
          $CitizenshipMediaTable,
          CitizenshipMediaData
        >,
      ),
      CitizenshipMediaData,
      PrefetchHooks Function()
    >;
typedef $$CitizenshipQuestionImagesTableCreateCompanionBuilder =
    CitizenshipQuestionImagesCompanion Function({
      required String datasetId,
      required String questionId,
      required String mediaKey,
      required int position,
      Value<int> rowid,
    });
typedef $$CitizenshipQuestionImagesTableUpdateCompanionBuilder =
    CitizenshipQuestionImagesCompanion Function({
      Value<String> datasetId,
      Value<String> questionId,
      Value<String> mediaKey,
      Value<int> position,
      Value<int> rowid,
    });

class $$CitizenshipQuestionImagesTableFilterComposer
    extends
        Composer<_$CitizenshipTestDatabase, $CitizenshipQuestionImagesTable> {
  $$CitizenshipQuestionImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get datasetId => $composableBuilder(
    column: $table.datasetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaKey => $composableBuilder(
    column: $table.mediaKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CitizenshipQuestionImagesTableOrderingComposer
    extends
        Composer<_$CitizenshipTestDatabase, $CitizenshipQuestionImagesTable> {
  $$CitizenshipQuestionImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get datasetId => $composableBuilder(
    column: $table.datasetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaKey => $composableBuilder(
    column: $table.mediaKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CitizenshipQuestionImagesTableAnnotationComposer
    extends
        Composer<_$CitizenshipTestDatabase, $CitizenshipQuestionImagesTable> {
  $$CitizenshipQuestionImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get datasetId =>
      $composableBuilder(column: $table.datasetId, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaKey =>
      $composableBuilder(column: $table.mediaKey, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$CitizenshipQuestionImagesTableTableManager
    extends
        RootTableManager<
          _$CitizenshipTestDatabase,
          $CitizenshipQuestionImagesTable,
          CitizenshipQuestionImage,
          $$CitizenshipQuestionImagesTableFilterComposer,
          $$CitizenshipQuestionImagesTableOrderingComposer,
          $$CitizenshipQuestionImagesTableAnnotationComposer,
          $$CitizenshipQuestionImagesTableCreateCompanionBuilder,
          $$CitizenshipQuestionImagesTableUpdateCompanionBuilder,
          (
            CitizenshipQuestionImage,
            BaseReferences<
              _$CitizenshipTestDatabase,
              $CitizenshipQuestionImagesTable,
              CitizenshipQuestionImage
            >,
          ),
          CitizenshipQuestionImage,
          PrefetchHooks Function()
        > {
  $$CitizenshipQuestionImagesTableTableManager(
    _$CitizenshipTestDatabase db,
    $CitizenshipQuestionImagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitizenshipQuestionImagesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CitizenshipQuestionImagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CitizenshipQuestionImagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> datasetId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<String> mediaKey = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipQuestionImagesCompanion(
                datasetId: datasetId,
                questionId: questionId,
                mediaKey: mediaKey,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String datasetId,
                required String questionId,
                required String mediaKey,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipQuestionImagesCompanion.insert(
                datasetId: datasetId,
                questionId: questionId,
                mediaKey: mediaKey,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CitizenshipQuestionImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$CitizenshipTestDatabase,
      $CitizenshipQuestionImagesTable,
      CitizenshipQuestionImage,
      $$CitizenshipQuestionImagesTableFilterComposer,
      $$CitizenshipQuestionImagesTableOrderingComposer,
      $$CitizenshipQuestionImagesTableAnnotationComposer,
      $$CitizenshipQuestionImagesTableCreateCompanionBuilder,
      $$CitizenshipQuestionImagesTableUpdateCompanionBuilder,
      (
        CitizenshipQuestionImage,
        BaseReferences<
          _$CitizenshipTestDatabase,
          $CitizenshipQuestionImagesTable,
          CitizenshipQuestionImage
        >,
      ),
      CitizenshipQuestionImage,
      PrefetchHooks Function()
    >;
typedef $$CitizenshipSyncMetadataTableCreateCompanionBuilder =
    CitizenshipSyncMetadataCompanion Function({
      Value<int> singleton,
      Value<DateTime?> lastCheckAttemptAt,
      Value<DateTime?> lastSuccessfulCheckAt,
      Value<DateTime?> lastSuccessfulUpdateAt,
      Value<String?> etag,
      Value<String?> lastModified,
      Value<String?> jsonHash,
      Value<int> questionCount,
      Value<String?> lastError,
      Value<int> consecutiveFailures,
      Value<DateTime?> nextAutomaticAttemptAt,
    });
typedef $$CitizenshipSyncMetadataTableUpdateCompanionBuilder =
    CitizenshipSyncMetadataCompanion Function({
      Value<int> singleton,
      Value<DateTime?> lastCheckAttemptAt,
      Value<DateTime?> lastSuccessfulCheckAt,
      Value<DateTime?> lastSuccessfulUpdateAt,
      Value<String?> etag,
      Value<String?> lastModified,
      Value<String?> jsonHash,
      Value<int> questionCount,
      Value<String?> lastError,
      Value<int> consecutiveFailures,
      Value<DateTime?> nextAutomaticAttemptAt,
    });

class $$CitizenshipSyncMetadataTableFilterComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipSyncMetadataTable> {
  $$CitizenshipSyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get singleton => $composableBuilder(
    column: $table.singleton,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCheckAttemptAt => $composableBuilder(
    column: $table.lastCheckAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessfulCheckAt => $composableBuilder(
    column: $table.lastSuccessfulCheckAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessfulUpdateAt => $composableBuilder(
    column: $table.lastSuccessfulUpdateAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jsonHash => $composableBuilder(
    column: $table.jsonHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consecutiveFailures => $composableBuilder(
    column: $table.consecutiveFailures,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAutomaticAttemptAt => $composableBuilder(
    column: $table.nextAutomaticAttemptAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CitizenshipSyncMetadataTableOrderingComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipSyncMetadataTable> {
  $$CitizenshipSyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get singleton => $composableBuilder(
    column: $table.singleton,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCheckAttemptAt => $composableBuilder(
    column: $table.lastCheckAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessfulCheckAt => $composableBuilder(
    column: $table.lastSuccessfulCheckAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessfulUpdateAt => $composableBuilder(
    column: $table.lastSuccessfulUpdateAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jsonHash => $composableBuilder(
    column: $table.jsonHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consecutiveFailures => $composableBuilder(
    column: $table.consecutiveFailures,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAutomaticAttemptAt => $composableBuilder(
    column: $table.nextAutomaticAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CitizenshipSyncMetadataTableAnnotationComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipSyncMetadataTable> {
  $$CitizenshipSyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get singleton =>
      $composableBuilder(column: $table.singleton, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCheckAttemptAt => $composableBuilder(
    column: $table.lastCheckAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSuccessfulCheckAt => $composableBuilder(
    column: $table.lastSuccessfulCheckAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSuccessfulUpdateAt => $composableBuilder(
    column: $table.lastSuccessfulUpdateAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jsonHash =>
      $composableBuilder(column: $table.jsonHash, builder: (column) => column);

  GeneratedColumn<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get consecutiveFailures => $composableBuilder(
    column: $table.consecutiveFailures,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextAutomaticAttemptAt => $composableBuilder(
    column: $table.nextAutomaticAttemptAt,
    builder: (column) => column,
  );
}

class $$CitizenshipSyncMetadataTableTableManager
    extends
        RootTableManager<
          _$CitizenshipTestDatabase,
          $CitizenshipSyncMetadataTable,
          CitizenshipSyncMetadataData,
          $$CitizenshipSyncMetadataTableFilterComposer,
          $$CitizenshipSyncMetadataTableOrderingComposer,
          $$CitizenshipSyncMetadataTableAnnotationComposer,
          $$CitizenshipSyncMetadataTableCreateCompanionBuilder,
          $$CitizenshipSyncMetadataTableUpdateCompanionBuilder,
          (
            CitizenshipSyncMetadataData,
            BaseReferences<
              _$CitizenshipTestDatabase,
              $CitizenshipSyncMetadataTable,
              CitizenshipSyncMetadataData
            >,
          ),
          CitizenshipSyncMetadataData,
          PrefetchHooks Function()
        > {
  $$CitizenshipSyncMetadataTableTableManager(
    _$CitizenshipTestDatabase db,
    $CitizenshipSyncMetadataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitizenshipSyncMetadataTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CitizenshipSyncMetadataTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CitizenshipSyncMetadataTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> singleton = const Value.absent(),
                Value<DateTime?> lastCheckAttemptAt = const Value.absent(),
                Value<DateTime?> lastSuccessfulCheckAt = const Value.absent(),
                Value<DateTime?> lastSuccessfulUpdateAt = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<String?> lastModified = const Value.absent(),
                Value<String?> jsonHash = const Value.absent(),
                Value<int> questionCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> consecutiveFailures = const Value.absent(),
                Value<DateTime?> nextAutomaticAttemptAt = const Value.absent(),
              }) => CitizenshipSyncMetadataCompanion(
                singleton: singleton,
                lastCheckAttemptAt: lastCheckAttemptAt,
                lastSuccessfulCheckAt: lastSuccessfulCheckAt,
                lastSuccessfulUpdateAt: lastSuccessfulUpdateAt,
                etag: etag,
                lastModified: lastModified,
                jsonHash: jsonHash,
                questionCount: questionCount,
                lastError: lastError,
                consecutiveFailures: consecutiveFailures,
                nextAutomaticAttemptAt: nextAutomaticAttemptAt,
              ),
          createCompanionCallback:
              ({
                Value<int> singleton = const Value.absent(),
                Value<DateTime?> lastCheckAttemptAt = const Value.absent(),
                Value<DateTime?> lastSuccessfulCheckAt = const Value.absent(),
                Value<DateTime?> lastSuccessfulUpdateAt = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<String?> lastModified = const Value.absent(),
                Value<String?> jsonHash = const Value.absent(),
                Value<int> questionCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> consecutiveFailures = const Value.absent(),
                Value<DateTime?> nextAutomaticAttemptAt = const Value.absent(),
              }) => CitizenshipSyncMetadataCompanion.insert(
                singleton: singleton,
                lastCheckAttemptAt: lastCheckAttemptAt,
                lastSuccessfulCheckAt: lastSuccessfulCheckAt,
                lastSuccessfulUpdateAt: lastSuccessfulUpdateAt,
                etag: etag,
                lastModified: lastModified,
                jsonHash: jsonHash,
                questionCount: questionCount,
                lastError: lastError,
                consecutiveFailures: consecutiveFailures,
                nextAutomaticAttemptAt: nextAutomaticAttemptAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CitizenshipSyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$CitizenshipTestDatabase,
      $CitizenshipSyncMetadataTable,
      CitizenshipSyncMetadataData,
      $$CitizenshipSyncMetadataTableFilterComposer,
      $$CitizenshipSyncMetadataTableOrderingComposer,
      $$CitizenshipSyncMetadataTableAnnotationComposer,
      $$CitizenshipSyncMetadataTableCreateCompanionBuilder,
      $$CitizenshipSyncMetadataTableUpdateCompanionBuilder,
      (
        CitizenshipSyncMetadataData,
        BaseReferences<
          _$CitizenshipTestDatabase,
          $CitizenshipSyncMetadataTable,
          CitizenshipSyncMetadataData
        >,
      ),
      CitizenshipSyncMetadataData,
      PrefetchHooks Function()
    >;
typedef $$CitizenshipProgressTableCreateCompanionBuilder =
    CitizenshipProgressCompanion Function({
      required String questionId,
      Value<int> attempts,
      Value<int> correct,
      Value<int> incorrect,
      Value<int?> lastSelectedAnswer,
      Value<DateTime?> lastAnsweredAt,
      Value<bool> isFavorite,
      Value<bool> isMastered,
      Value<int> rowid,
    });
typedef $$CitizenshipProgressTableUpdateCompanionBuilder =
    CitizenshipProgressCompanion Function({
      Value<String> questionId,
      Value<int> attempts,
      Value<int> correct,
      Value<int> incorrect,
      Value<int?> lastSelectedAnswer,
      Value<DateTime?> lastAnsweredAt,
      Value<bool> isFavorite,
      Value<bool> isMastered,
      Value<int> rowid,
    });

class $$CitizenshipProgressTableFilterComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipProgressTable> {
  $$CitizenshipProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incorrect => $composableBuilder(
    column: $table.incorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSelectedAnswer => $composableBuilder(
    column: $table.lastSelectedAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAnsweredAt => $composableBuilder(
    column: $table.lastAnsweredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CitizenshipProgressTableOrderingComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipProgressTable> {
  $$CitizenshipProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incorrect => $composableBuilder(
    column: $table.incorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSelectedAnswer => $composableBuilder(
    column: $table.lastSelectedAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAnsweredAt => $composableBuilder(
    column: $table.lastAnsweredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CitizenshipProgressTableAnnotationComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipProgressTable> {
  $$CitizenshipProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get incorrect =>
      $composableBuilder(column: $table.incorrect, builder: (column) => column);

  GeneratedColumn<int> get lastSelectedAnswer => $composableBuilder(
    column: $table.lastSelectedAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAnsweredAt => $composableBuilder(
    column: $table.lastAnsweredAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => column,
  );
}

class $$CitizenshipProgressTableTableManager
    extends
        RootTableManager<
          _$CitizenshipTestDatabase,
          $CitizenshipProgressTable,
          CitizenshipProgressData,
          $$CitizenshipProgressTableFilterComposer,
          $$CitizenshipProgressTableOrderingComposer,
          $$CitizenshipProgressTableAnnotationComposer,
          $$CitizenshipProgressTableCreateCompanionBuilder,
          $$CitizenshipProgressTableUpdateCompanionBuilder,
          (
            CitizenshipProgressData,
            BaseReferences<
              _$CitizenshipTestDatabase,
              $CitizenshipProgressTable,
              CitizenshipProgressData
            >,
          ),
          CitizenshipProgressData,
          PrefetchHooks Function()
        > {
  $$CitizenshipProgressTableTableManager(
    _$CitizenshipTestDatabase db,
    $CitizenshipProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitizenshipProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CitizenshipProgressTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CitizenshipProgressTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> questionId = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<int> incorrect = const Value.absent(),
                Value<int?> lastSelectedAnswer = const Value.absent(),
                Value<DateTime?> lastAnsweredAt = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isMastered = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipProgressCompanion(
                questionId: questionId,
                attempts: attempts,
                correct: correct,
                incorrect: incorrect,
                lastSelectedAnswer: lastSelectedAnswer,
                lastAnsweredAt: lastAnsweredAt,
                isFavorite: isFavorite,
                isMastered: isMastered,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String questionId,
                Value<int> attempts = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<int> incorrect = const Value.absent(),
                Value<int?> lastSelectedAnswer = const Value.absent(),
                Value<DateTime?> lastAnsweredAt = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isMastered = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipProgressCompanion.insert(
                questionId: questionId,
                attempts: attempts,
                correct: correct,
                incorrect: incorrect,
                lastSelectedAnswer: lastSelectedAnswer,
                lastAnsweredAt: lastAnsweredAt,
                isFavorite: isFavorite,
                isMastered: isMastered,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CitizenshipProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$CitizenshipTestDatabase,
      $CitizenshipProgressTable,
      CitizenshipProgressData,
      $$CitizenshipProgressTableFilterComposer,
      $$CitizenshipProgressTableOrderingComposer,
      $$CitizenshipProgressTableAnnotationComposer,
      $$CitizenshipProgressTableCreateCompanionBuilder,
      $$CitizenshipProgressTableUpdateCompanionBuilder,
      (
        CitizenshipProgressData,
        BaseReferences<
          _$CitizenshipTestDatabase,
          $CitizenshipProgressTable,
          CitizenshipProgressData
        >,
      ),
      CitizenshipProgressData,
      PrefetchHooks Function()
    >;
typedef $$CitizenshipExamSessionsTableCreateCompanionBuilder =
    CitizenshipExamSessionsCompanion Function({
      required String id,
      required String stateCode,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      required String questionIdsJson,
      Value<String> mode,
      Value<int> currentIndex,
      Value<int?> correctCount,
      Value<bool?> passedLifeInGermany,
      Value<bool?> passedCitizenship,
      Value<int> rowid,
    });
typedef $$CitizenshipExamSessionsTableUpdateCompanionBuilder =
    CitizenshipExamSessionsCompanion Function({
      Value<String> id,
      Value<String> stateCode,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<String> questionIdsJson,
      Value<String> mode,
      Value<int> currentIndex,
      Value<int?> correctCount,
      Value<bool?> passedLifeInGermany,
      Value<bool?> passedCitizenship,
      Value<int> rowid,
    });

class $$CitizenshipExamSessionsTableFilterComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipExamSessionsTable> {
  $$CitizenshipExamSessionsTableFilterComposer({
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

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionIdsJson => $composableBuilder(
    column: $table.questionIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get passedLifeInGermany => $composableBuilder(
    column: $table.passedLifeInGermany,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get passedCitizenship => $composableBuilder(
    column: $table.passedCitizenship,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CitizenshipExamSessionsTableOrderingComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipExamSessionsTable> {
  $$CitizenshipExamSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionIdsJson => $composableBuilder(
    column: $table.questionIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get passedLifeInGermany => $composableBuilder(
    column: $table.passedLifeInGermany,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get passedCitizenship => $composableBuilder(
    column: $table.passedCitizenship,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CitizenshipExamSessionsTableAnnotationComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipExamSessionsTable> {
  $$CitizenshipExamSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionIdsJson => $composableBuilder(
    column: $table.questionIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get passedLifeInGermany => $composableBuilder(
    column: $table.passedLifeInGermany,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get passedCitizenship => $composableBuilder(
    column: $table.passedCitizenship,
    builder: (column) => column,
  );
}

class $$CitizenshipExamSessionsTableTableManager
    extends
        RootTableManager<
          _$CitizenshipTestDatabase,
          $CitizenshipExamSessionsTable,
          CitizenshipExamSession,
          $$CitizenshipExamSessionsTableFilterComposer,
          $$CitizenshipExamSessionsTableOrderingComposer,
          $$CitizenshipExamSessionsTableAnnotationComposer,
          $$CitizenshipExamSessionsTableCreateCompanionBuilder,
          $$CitizenshipExamSessionsTableUpdateCompanionBuilder,
          (
            CitizenshipExamSession,
            BaseReferences<
              _$CitizenshipTestDatabase,
              $CitizenshipExamSessionsTable,
              CitizenshipExamSession
            >,
          ),
          CitizenshipExamSession,
          PrefetchHooks Function()
        > {
  $$CitizenshipExamSessionsTableTableManager(
    _$CitizenshipTestDatabase db,
    $CitizenshipExamSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitizenshipExamSessionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CitizenshipExamSessionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CitizenshipExamSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> stateCode = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String> questionIdsJson = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int> currentIndex = const Value.absent(),
                Value<int?> correctCount = const Value.absent(),
                Value<bool?> passedLifeInGermany = const Value.absent(),
                Value<bool?> passedCitizenship = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipExamSessionsCompanion(
                id: id,
                stateCode: stateCode,
                startedAt: startedAt,
                completedAt: completedAt,
                questionIdsJson: questionIdsJson,
                mode: mode,
                currentIndex: currentIndex,
                correctCount: correctCount,
                passedLifeInGermany: passedLifeInGermany,
                passedCitizenship: passedCitizenship,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String stateCode,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                required String questionIdsJson,
                Value<String> mode = const Value.absent(),
                Value<int> currentIndex = const Value.absent(),
                Value<int?> correctCount = const Value.absent(),
                Value<bool?> passedLifeInGermany = const Value.absent(),
                Value<bool?> passedCitizenship = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipExamSessionsCompanion.insert(
                id: id,
                stateCode: stateCode,
                startedAt: startedAt,
                completedAt: completedAt,
                questionIdsJson: questionIdsJson,
                mode: mode,
                currentIndex: currentIndex,
                correctCount: correctCount,
                passedLifeInGermany: passedLifeInGermany,
                passedCitizenship: passedCitizenship,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CitizenshipExamSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$CitizenshipTestDatabase,
      $CitizenshipExamSessionsTable,
      CitizenshipExamSession,
      $$CitizenshipExamSessionsTableFilterComposer,
      $$CitizenshipExamSessionsTableOrderingComposer,
      $$CitizenshipExamSessionsTableAnnotationComposer,
      $$CitizenshipExamSessionsTableCreateCompanionBuilder,
      $$CitizenshipExamSessionsTableUpdateCompanionBuilder,
      (
        CitizenshipExamSession,
        BaseReferences<
          _$CitizenshipTestDatabase,
          $CitizenshipExamSessionsTable,
          CitizenshipExamSession
        >,
      ),
      CitizenshipExamSession,
      PrefetchHooks Function()
    >;
typedef $$CitizenshipExamAnswersTableCreateCompanionBuilder =
    CitizenshipExamAnswersCompanion Function({
      required String sessionId,
      required String questionId,
      required int selectedAnswer,
      required bool isCorrect,
      Value<int> rowid,
    });
typedef $$CitizenshipExamAnswersTableUpdateCompanionBuilder =
    CitizenshipExamAnswersCompanion Function({
      Value<String> sessionId,
      Value<String> questionId,
      Value<int> selectedAnswer,
      Value<bool> isCorrect,
      Value<int> rowid,
    });

class $$CitizenshipExamAnswersTableFilterComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipExamAnswersTable> {
  $$CitizenshipExamAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CitizenshipExamAnswersTableOrderingComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipExamAnswersTable> {
  $$CitizenshipExamAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CitizenshipExamAnswersTableAnnotationComposer
    extends Composer<_$CitizenshipTestDatabase, $CitizenshipExamAnswersTable> {
  $$CitizenshipExamAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);
}

class $$CitizenshipExamAnswersTableTableManager
    extends
        RootTableManager<
          _$CitizenshipTestDatabase,
          $CitizenshipExamAnswersTable,
          CitizenshipExamAnswer,
          $$CitizenshipExamAnswersTableFilterComposer,
          $$CitizenshipExamAnswersTableOrderingComposer,
          $$CitizenshipExamAnswersTableAnnotationComposer,
          $$CitizenshipExamAnswersTableCreateCompanionBuilder,
          $$CitizenshipExamAnswersTableUpdateCompanionBuilder,
          (
            CitizenshipExamAnswer,
            BaseReferences<
              _$CitizenshipTestDatabase,
              $CitizenshipExamAnswersTable,
              CitizenshipExamAnswer
            >,
          ),
          CitizenshipExamAnswer,
          PrefetchHooks Function()
        > {
  $$CitizenshipExamAnswersTableTableManager(
    _$CitizenshipTestDatabase db,
    $CitizenshipExamAnswersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitizenshipExamAnswersTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CitizenshipExamAnswersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CitizenshipExamAnswersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<int> selectedAnswer = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipExamAnswersCompanion(
                sessionId: sessionId,
                questionId: questionId,
                selectedAnswer: selectedAnswer,
                isCorrect: isCorrect,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String questionId,
                required int selectedAnswer,
                required bool isCorrect,
                Value<int> rowid = const Value.absent(),
              }) => CitizenshipExamAnswersCompanion.insert(
                sessionId: sessionId,
                questionId: questionId,
                selectedAnswer: selectedAnswer,
                isCorrect: isCorrect,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CitizenshipExamAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$CitizenshipTestDatabase,
      $CitizenshipExamAnswersTable,
      CitizenshipExamAnswer,
      $$CitizenshipExamAnswersTableFilterComposer,
      $$CitizenshipExamAnswersTableOrderingComposer,
      $$CitizenshipExamAnswersTableAnnotationComposer,
      $$CitizenshipExamAnswersTableCreateCompanionBuilder,
      $$CitizenshipExamAnswersTableUpdateCompanionBuilder,
      (
        CitizenshipExamAnswer,
        BaseReferences<
          _$CitizenshipTestDatabase,
          $CitizenshipExamAnswersTable,
          CitizenshipExamAnswer
        >,
      ),
      CitizenshipExamAnswer,
      PrefetchHooks Function()
    >;

class $CitizenshipTestDatabaseManager {
  final _$CitizenshipTestDatabase _db;
  $CitizenshipTestDatabaseManager(this._db);
  $$CitizenshipDatasetsTableTableManager get citizenshipDatasets =>
      $$CitizenshipDatasetsTableTableManager(_db, _db.citizenshipDatasets);
  $$CitizenshipQuestionsTableTableManager get citizenshipQuestions =>
      $$CitizenshipQuestionsTableTableManager(_db, _db.citizenshipQuestions);
  $$CitizenshipMediaTableTableManager get citizenshipMedia =>
      $$CitizenshipMediaTableTableManager(_db, _db.citizenshipMedia);
  $$CitizenshipQuestionImagesTableTableManager get citizenshipQuestionImages =>
      $$CitizenshipQuestionImagesTableTableManager(
        _db,
        _db.citizenshipQuestionImages,
      );
  $$CitizenshipSyncMetadataTableTableManager get citizenshipSyncMetadata =>
      $$CitizenshipSyncMetadataTableTableManager(
        _db,
        _db.citizenshipSyncMetadata,
      );
  $$CitizenshipProgressTableTableManager get citizenshipProgress =>
      $$CitizenshipProgressTableTableManager(_db, _db.citizenshipProgress);
  $$CitizenshipExamSessionsTableTableManager get citizenshipExamSessions =>
      $$CitizenshipExamSessionsTableTableManager(
        _db,
        _db.citizenshipExamSessions,
      );
  $$CitizenshipExamAnswersTableTableManager get citizenshipExamAnswers =>
      $$CitizenshipExamAnswersTableTableManager(
        _db,
        _db.citizenshipExamAnswers,
      );
}
