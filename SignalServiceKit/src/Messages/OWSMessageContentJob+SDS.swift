//
//  Copyright (c) 2022 Open Whisper Systems. All rights reserved.
//

import Foundation
import GRDB
import SignalCoreKit

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - Record

public struct MessageContentJobRecord: SDSRecord {
    public weak var delegate: SDSRecordDelegate?

    public var tableMetadata: SDSTableMetadata {
        OWSMessageContentJobSerializer.table
    }

    public static var databaseTableName: String {
        OWSMessageContentJobSerializer.table.tableName
    }

    public var id: Int64?

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    public let recordType: SDSRecordType
    public let uniqueId: String

    // Properties
    public let createdAt: Double
    public let envelopeData: Data
    public let plaintextData: Data?
    public let wasReceivedByUD: Bool
    public let serverDeliveryTimestamp: UInt64

    public enum CodingKeys: String, CodingKey, ColumnExpression, CaseIterable {
        case id
        case recordType
        case uniqueId
        case createdAt
        case envelopeData
        case plaintextData
        case wasReceivedByUD
        case serverDeliveryTimestamp
    }

    public static func columnName(_ column: MessageContentJobRecord.CodingKeys, fullyQualified: Bool = false) -> String {
        fullyQualified ? "\(databaseTableName).\(column.rawValue)" : column.rawValue
    }

    public func didInsert(with rowID: Int64, for column: String?) {
        guard let delegate = delegate else {
            owsFailDebug("Missing delegate.")
            return
        }
        delegate.updateRowId(rowID)
    }
}

// MARK: - Row Initializer

public extension MessageContentJobRecord {
    static var databaseSelection: [SQLSelectable] {
        CodingKeys.allCases
    }

    init(row: Row) {
        id = row[0]
        recordType = row[1]
        uniqueId = row[2]
        createdAt = row[3]
        envelopeData = row[4]
        plaintextData = row[5]
        wasReceivedByUD = row[6]
        serverDeliveryTimestamp = row[7]
    }
}

// MARK: - StringInterpolation

public extension String.StringInterpolation {
    mutating func appendInterpolation(messageContentJobColumn column: MessageContentJobRecord.CodingKeys) {
        appendLiteral(MessageContentJobRecord.columnName(column))
    }
    mutating func appendInterpolation(messageContentJobColumnFullyQualified column: MessageContentJobRecord.CodingKeys) {
        appendLiteral(MessageContentJobRecord.columnName(column, fullyQualified: true))
    }
}

// MARK: - Deserialization

// TODO: Rework metadata to not include, for example, columns, column indices.
extension OWSMessageContentJob {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func fromRecord(_ record: MessageContentJobRecord) throws -> OWSMessageContentJob {

        guard let recordId = record.id else {
            throw SDSError.invalidValue
        }

        switch record.recordType {
        case .messageContentJob:

            let uniqueId: String = record.uniqueId
            let createdAtInterval: Double = record.createdAt
            let createdAt: Date = SDSDeserialization.requiredDoubleAsDate(createdAtInterval, name: "createdAt")
            let envelopeData: Data = record.envelopeData
            let plaintextData: Data? = SDSDeserialization.optionalData(record.plaintextData, name: "plaintextData")
            let serverDeliveryTimestamp: UInt64 = record.serverDeliveryTimestamp
            let wasReceivedByUD: Bool = record.wasReceivedByUD

            return OWSMessageContentJob(grdbId: recordId,
                                        uniqueId: uniqueId,
                                        createdAt: createdAt,
                                        envelopeData: envelopeData,
                                        plaintextData: plaintextData,
                                        serverDeliveryTimestamp: serverDeliveryTimestamp,
                                        wasReceivedByUD: wasReceivedByUD)

        default:
            owsFailDebug("Unexpected record type: \(record.recordType)")
            throw SDSError.invalidValue
        }
    }
}

// MARK: - SDSModel

extension OWSMessageContentJob: SDSModel {
    public var serializer: SDSSerializer {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        switch self {
        default:
            return OWSMessageContentJobSerializer(model: self)
        }
    }

    public func asRecord() throws -> SDSRecord {
        try serializer.asRecord()
    }

    public var sdsTableName: String {
        MessageContentJobRecord.databaseTableName
    }

    public static var table: SDSTableMetadata {
        OWSMessageContentJobSerializer.table
    }
}

// MARK: - DeepCopyable

extension OWSMessageContentJob: DeepCopyable {

    public func deepCopy() throws -> AnyObject {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        guard let id = self.grdbId?.int64Value else {
            throw OWSAssertionError("Model missing grdbId.")
        }

        do {
            let modelToCopy = self
            assert(type(of: modelToCopy) == OWSMessageContentJob.self)
            let uniqueId: String = modelToCopy.uniqueId
            let createdAt: Date = modelToCopy.createdAt
            let envelopeData: Data = modelToCopy.envelopeData
            let plaintextData: Data? = modelToCopy.plaintextData
            let serverDeliveryTimestamp: UInt64 = modelToCopy.serverDeliveryTimestamp
            let wasReceivedByUD: Bool = modelToCopy.wasReceivedByUD

            return OWSMessageContentJob(grdbId: id,
                                        uniqueId: uniqueId,
                                        createdAt: createdAt,
                                        envelopeData: envelopeData,
                                        plaintextData: plaintextData,
                                        serverDeliveryTimestamp: serverDeliveryTimestamp,
                                        wasReceivedByUD: wasReceivedByUD)
        }

    }
}

// MARK: - Table Metadata

extension OWSMessageContentJobSerializer {

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    static var idColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "id", columnType: .primaryKey) }
    static var recordTypeColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "recordType", columnType: .int64) }
    static var uniqueIdColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "uniqueId", columnType: .unicodeString, isUnique: true) }
    // Properties
    static var createdAtColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "createdAt", columnType: .double) }
    static var envelopeDataColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "envelopeData", columnType: .blob) }
    static var plaintextDataColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "plaintextData", columnType: .blob, isOptional: true) }
    static var wasReceivedByUDColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "wasReceivedByUD", columnType: .int) }
    static var serverDeliveryTimestampColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "serverDeliveryTimestamp", columnType: .int64) }

    // TODO: We should decide on a naming convention for
    //       tables that store models.
    public static var table: SDSTableMetadata {
        SDSTableMetadata(collection: OWSMessageContentJob.collection(),
                         tableName: "model_OWSMessageContentJob",
                         columns: [
        idColumn,
        recordTypeColumn,
        uniqueIdColumn,
        createdAtColumn,
        envelopeDataColumn,
        plaintextDataColumn,
        wasReceivedByUDColumn,
        serverDeliveryTimestampColumn
        ])
    }
}

// MARK: - Save/Remove/Update

@objc
public extension OWSMessageContentJob {
    func anyInsert(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .insert, transaction: transaction)
    }

    // Avoid this method whenever feasible.
    //
    // If the record has previously been saved, this method does an overwriting
    // update of the corresponding row, otherwise if it's a new record, this
    // method inserts a new row.
    //
    // For performance, when possible, you should explicitly specify whether
    // you are inserting or updating rather than calling this method.
    func anyUpsert(transaction: SDSAnyWriteTransaction) {
        let isInserting: Bool
        if OWSMessageContentJob.anyFetch(uniqueId: uniqueId, transaction: transaction) != nil {
            isInserting = false
        } else {
            isInserting = true
        }
        sdsSave(saveMode: isInserting ? .insert : .update, transaction: transaction)
    }

    // This method is used by "updateWith..." methods.
    //
    // This model may be updated from many threads. We don't want to save
    // our local copy (this instance) since it may be out of date.  We also
    // want to avoid re-saving a model that has been deleted.  Therefore, we
    // use "updateWith..." methods to:
    //
    // a) Update a property of this instance.
    // b) If a copy of this model exists in the database, load an up-to-date copy,
    //    and update and save that copy.
    // b) If a copy of this model _DOES NOT_ exist in the database, do _NOT_ save
    //    this local instance.
    //
    // After "updateWith...":
    //
    // a) Any copy of this model in the database will have been updated.
    // b) The local property on this instance will always have been updated.
    // c) Other properties on this instance may be out of date.
    //
    // All mutable properties of this class have been made read-only to
    // prevent accidentally modifying them directly.
    //
    // This isn't a perfect arrangement, but in practice this will prevent
    // data loss and will resolve all known issues.
    func anyUpdate(transaction: SDSAnyWriteTransaction, block: (OWSMessageContentJob) -> Void) {

        block(self)

        guard let dbCopy = type(of: self).anyFetch(uniqueId: uniqueId,
                                                   transaction: transaction) else {
            return
        }

        // Don't apply the block twice to the same instance.
        // It's at least unnecessary and actually wrong for some blocks.
        // e.g. `block: { $0 in $0.someField++ }`
        if dbCopy !== self {
            block(dbCopy)
        }

        dbCopy.sdsSave(saveMode: .update, transaction: transaction)
    }

    // This method is an alternative to `anyUpdate(transaction:block:)` methods.
    //
    // We should generally use `anyUpdate` to ensure we're not unintentionally
    // clobbering other columns in the database when another concurrent update
    // has occured.
    //
    // There are cases when this doesn't make sense, e.g. when  we know we've
    // just loaded the model in the same transaction. In those cases it is
    // safe and faster to do a "overwriting" update
    func anyOverwritingUpdate(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .update, transaction: transaction)
    }

    func anyRemove(transaction: SDSAnyWriteTransaction) {
        sdsRemove(transaction: transaction)
    }

    func anyReload(transaction: SDSAnyReadTransaction) {
        anyReload(transaction: transaction, ignoreMissing: false)
    }

    func anyReload(transaction: SDSAnyReadTransaction, ignoreMissing: Bool) {
        guard let latestVersion = type(of: self).anyFetch(uniqueId: uniqueId, transaction: transaction) else {
            if !ignoreMissing {
                owsFailDebug("`latest` was unexpectedly nil")
            }
            return
        }

        setValuesForKeys(latestVersion.dictionaryValue)
    }
}

// MARK: - OWSMessageContentJobCursor

@objc
public class OWSMessageContentJobCursor: NSObject {
    private let transaction: GRDBReadTransaction
    private let cursor: RecordCursor<MessageContentJobRecord>?

    init(transaction: GRDBReadTransaction, cursor: RecordCursor<MessageContentJobRecord>?) {
        self.transaction = transaction
        self.cursor = cursor
    }

    public func next() throws -> OWSMessageContentJob? {
        guard let cursor = cursor else {
            return nil
        }
        guard let record = try cursor.next() else {
            return nil
        }
        return try OWSMessageContentJob.fromRecord(record)
    }

    public func all() throws -> [OWSMessageContentJob] {
        var result = [OWSMessageContentJob]()
        while true {
            guard let model = try next() else {
                break
            }
            result.append(model)
        }
        return result
    }
}

// MARK: - Obj-C Fetch

// TODO: We may eventually want to define some combination of:
//
// * fetchCursor, fetchOne, fetchAll, etc. (ala GRDB)
// * Optional "where clause" parameters for filtering.
// * Async flavors with completions.
//
// TODO: I've defined flavors that take a read transaction.
//       Or we might take a "connection" if we end up having that class.
@objc
public extension OWSMessageContentJob {
    class func grdbFetchCursor(transaction: GRDBReadTransaction) -> OWSMessageContentJobCursor {
        let database = transaction.database
        do {
            let cursor = try MessageContentJobRecord.fetchCursor(database)
            return OWSMessageContentJobCursor(transaction: transaction, cursor: cursor)
        } catch {
            owsFailDebug("Read failed: \(error)")
            return OWSMessageContentJobCursor(transaction: transaction, cursor: nil)
        }
    }

    // Fetches a single model by "unique id".
    class func anyFetch(uniqueId: String,
                        transaction: SDSAnyReadTransaction) -> OWSMessageContentJob? {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT * FROM \(MessageContentJobRecord.databaseTableName) WHERE \(messageContentJobColumn: .uniqueId) = ?"
            return grdbFetchOne(sql: sql, arguments: [uniqueId], transaction: grdbTransaction)
        }
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            block: @escaping (OWSMessageContentJob, UnsafeMutablePointer<ObjCBool>) -> Void) {
        anyEnumerate(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            batched: Bool = false,
                            block: @escaping (OWSMessageContentJob, UnsafeMutablePointer<ObjCBool>) -> Void) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerate(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            batchSize: UInt,
                            block: @escaping (OWSMessageContentJob, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let cursor = OWSMessageContentJob.grdbFetchCursor(transaction: grdbTransaction)
            Batching.loop(batchSize: batchSize,
                          loopBlock: { stop in
                                do {
                                    guard let value = try cursor.next() else {
                                        stop.pointee = true
                                        return
                                    }
                                    block(value, stop)
                                } catch let error {
                                    owsFailDebug("Couldn't fetch model: \(error)")
                                }
                              })
        }
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        anyEnumerateUniqueIds(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     batched: Bool = false,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerateUniqueIds(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     batchSize: UInt,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            grdbEnumerateUniqueIds(transaction: grdbTransaction,
                                   sql: """
                    SELECT \(messageContentJobColumn: .uniqueId)
                    FROM \(MessageContentJobRecord.databaseTableName)
                """,
                batchSize: batchSize,
                block: block)
        }
    }

    // Does not order the results.
    class func anyFetchAll(transaction: SDSAnyReadTransaction) -> [OWSMessageContentJob] {
        var result = [OWSMessageContentJob]()
        anyEnumerate(transaction: transaction) { (model, _) in
            result.append(model)
        }
        return result
    }

    // Does not order the results.
    class func anyAllUniqueIds(transaction: SDSAnyReadTransaction) -> [String] {
        var result = [String]()
        anyEnumerateUniqueIds(transaction: transaction) { (uniqueId, _) in
            result.append(uniqueId)
        }
        return result
    }

    class func anyCount(transaction: SDSAnyReadTransaction) -> UInt {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            return MessageContentJobRecord.ows_fetchCount(grdbTransaction.database)
        }
    }

    // WARNING: Do not use this method for any models which do cleanup
    //          in their anyWillRemove(), anyDidRemove() methods.
    class func anyRemoveAllWithoutInstantation(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .grdbWrite(let grdbTransaction):
            do {
                try MessageContentJobRecord.deleteAll(grdbTransaction.database)
            } catch {
                owsFailDebug("deleteAll() failed: \(error)")
            }
        }

        if ftsIndexMode != .never {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }

    class func anyRemoveAllWithInstantation(transaction: SDSAnyWriteTransaction) {
        // To avoid mutationDuringEnumerationException, we need
        // to remove the instances outside the enumeration.
        let uniqueIds = anyAllUniqueIds(transaction: transaction)

        var index: Int = 0
        Batching.loop(batchSize: Batching.kDefaultBatchSize,
                      loopBlock: { stop in
            guard index < uniqueIds.count else {
                stop.pointee = true
                return
            }
            let uniqueId = uniqueIds[index]
            index = index + 1
            guard let instance = anyFetch(uniqueId: uniqueId, transaction: transaction) else {
                owsFailDebug("Missing instance.")
                return
            }
            instance.anyRemove(transaction: transaction)
        })

        if ftsIndexMode != .never {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }

    class func anyExists(uniqueId: String,
                        transaction: SDSAnyReadTransaction) -> Bool {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT EXISTS ( SELECT 1 FROM \(MessageContentJobRecord.databaseTableName) WHERE \(messageContentJobColumn: .uniqueId) = ? )"
            let arguments: StatementArguments = [uniqueId]
            return try! Bool.fetchOne(grdbTransaction.database, sql: sql, arguments: arguments) ?? false
        }
    }
}

// MARK: - Swift Fetch

public extension OWSMessageContentJob {
    class func grdbFetchCursor(sql: String,
                               arguments: StatementArguments = StatementArguments(),
                               transaction: GRDBReadTransaction) -> OWSMessageContentJobCursor {
        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            let cursor = try MessageContentJobRecord.fetchCursor(transaction.database, sqlRequest)
            return OWSMessageContentJobCursor(transaction: transaction, cursor: cursor)
        } catch {
            Logger.verbose("sql: \(sql)")
            owsFailDebug("Read failed: \(error)")
            return OWSMessageContentJobCursor(transaction: transaction, cursor: nil)
        }
    }

    class func grdbFetchOne(sql: String,
                            arguments: StatementArguments = StatementArguments(),
                            transaction: GRDBReadTransaction) -> OWSMessageContentJob? {
        assert(sql.count > 0)

        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            guard let record = try MessageContentJobRecord.fetchOne(transaction.database, sqlRequest) else {
                return nil
            }

            return try OWSMessageContentJob.fromRecord(record)
        } catch {
            owsFailDebug("error: \(error)")
            return nil
        }
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class OWSMessageContentJobSerializer: SDSSerializer {

    private let model: OWSMessageContentJob
    public required init(model: OWSMessageContentJob) {
        self.model = model
    }

    // MARK: - Record

    func asRecord() throws -> SDSRecord {
        let id: Int64? = model.grdbId?.int64Value

        let recordType: SDSRecordType = .messageContentJob
        let uniqueId: String = model.uniqueId

        // Properties
        let createdAt: Double = archiveDate(model.createdAt)
        let envelopeData: Data = model.envelopeData
        let plaintextData: Data? = model.plaintextData
        let wasReceivedByUD: Bool = model.wasReceivedByUD
        let serverDeliveryTimestamp: UInt64 = model.serverDeliveryTimestamp

        return MessageContentJobRecord(delegate: model, id: id, recordType: recordType, uniqueId: uniqueId, createdAt: createdAt, envelopeData: envelopeData, plaintextData: plaintextData, wasReceivedByUD: wasReceivedByUD, serverDeliveryTimestamp: serverDeliveryTimestamp)
    }
}

// MARK: - Deep Copy

#if TESTABLE_BUILD
@objc
public extension OWSMessageContentJob {
    // We're not using this method at the moment,
    // but we might use it for validation of
    // other deep copy methods.
    func deepCopyUsingRecord() throws -> OWSMessageContentJob {
        guard let record = try asRecord() as? MessageContentJobRecord else {
            throw OWSAssertionError("Could not convert to record.")
        }
        return try OWSMessageContentJob.fromRecord(record)
    }
}
#endif
