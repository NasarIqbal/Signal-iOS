//
// Copyright 2024 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import GRDB
public import SignalRingRTC

public protocol CallLinkRecordStore {
    func fetch(rowId: Int64, tx: any DBReadTransaction) throws -> CallLinkRecord?
    func fetch(roomId: Data, tx: any DBReadTransaction) throws -> CallLinkRecord?
    func fetchOrInsert(rootKey: CallLinkRootKey, tx: any DBWriteTransaction) throws -> CallLinkRecord

    func update(_ callLinkRecord: CallLinkRecord, tx: any DBWriteTransaction) throws
    func delete(_ callLinkRecord: CallLinkRecord, tx: any DBWriteTransaction) throws

    func fetchAll(tx: any DBReadTransaction) throws -> [CallLinkRecord]
    func fetchUpcoming(earlierThan expirationTimestamp: Date?, limit: Int, tx: any DBReadTransaction) throws -> [CallLinkRecord]
    func fetchWhere(adminDeletedAtTimestampMsIsLessThan thresholdMs: UInt64, tx: any DBReadTransaction) throws -> [CallLinkRecord]
    func fetchAnyPendingRecord(tx: any DBReadTransaction) throws -> CallLinkRecord?
}

public class CallLinkRecordStoreImpl: CallLinkRecordStore {
    public init() {}

    public func fetch(rowId: Int64, tx: any DBReadTransaction) throws -> CallLinkRecord? {
        let db = tx.databaseConnection
        do {
            return try CallLinkRecord.fetchOne(db, key: rowId)
        } catch {
            throw error.grdbErrorForLogging
        }
    }

    public func fetch(roomId: Data, tx: any DBReadTransaction) throws -> CallLinkRecord? {
        let db = tx.databaseConnection
        do {
            return try CallLinkRecord.filter(Column(CallLinkRecord.CodingKeys.roomId) == roomId).fetchOne(db)
        } catch {
            throw error.grdbErrorForLogging
        }
    }

    public func fetchOrInsert(rootKey: CallLinkRootKey, tx: any DBWriteTransaction) throws -> CallLinkRecord {
        if let existingRecord = try fetch(roomId: rootKey.deriveRoomId(), tx: tx) {
            return existingRecord
        }
        return try CallLinkRecord.insertRecord(rootKey: rootKey, tx: tx)
    }

    public func update(_ callLinkRecord: CallLinkRecord, tx: any DBWriteTransaction) throws {
        let db = tx.databaseConnection
        do {
            try callLinkRecord.update(db)
        } catch {
            throw error.grdbErrorForLogging
        }
    }

    public func delete(_ callLinkRecord: CallLinkRecord, tx: any DBWriteTransaction) throws {
        let db = tx.databaseConnection
        do {
            try callLinkRecord.delete(db)
        } catch {
            throw error.grdbErrorForLogging
        }
    }

    public func fetchAll(tx: any DBReadTransaction) throws -> [CallLinkRecord] {
        guard FeatureFlags.callLinkRecordTable else {
            throw OWSGenericError("Call Links aren't yet supported.")
        }
        let db = tx.databaseConnection
        do {
            return try CallLinkRecord.fetchAll(db)
        } catch {
            throw error.grdbErrorForLogging
        }
    }

    public func fetchUpcoming(earlierThan expirationTimestamp: Date?, limit: Int, tx: any DBReadTransaction) throws -> [CallLinkRecord] {
        let db = tx.databaseConnection
        do {
            let isUpcomingColumn = Column(CallLinkRecord.CodingKeys.isUpcoming)
            let expirationColumn = Column(CallLinkRecord.CodingKeys.expiration)

            var baseQuery = CallLinkRecord.filter(isUpcomingColumn == true).order(expirationColumn.desc).limit(limit)
            if let expirationTimestamp {
                baseQuery = baseQuery.filter(expirationColumn < expirationTimestamp)
            }
            return try baseQuery.fetchAll(db)
        } catch {
            throw error.grdbErrorForLogging
        }
    }

    public func fetchWhere(adminDeletedAtTimestampMsIsLessThan thresholdMs: UInt64, tx: any DBReadTransaction) throws -> [CallLinkRecord] {
        let db = tx.databaseConnection
        do {
            return try CallLinkRecord.filter(Column(CallLinkRecord.CodingKeys.adminDeletedAtTimestampMs) < Int64(bitPattern: thresholdMs)).fetchAll(db)
        } catch {
            throw error.grdbErrorForLogging
        }
    }

    public func fetchAnyPendingRecord(tx: any DBReadTransaction) throws -> CallLinkRecord? {
        guard FeatureFlags.callLinkRecordTable else {
            return nil
        }
        let db = tx.databaseConnection
        do {
            return try CallLinkRecord.filter(Column(CallLinkRecord.CodingKeys.pendingFetchCounter) > 0).fetchOne(db)
        } catch {
            throw error.grdbErrorForLogging
        }
    }
}

#if TESTABLE_BUILD

final class MockCallLinkRecordStore: CallLinkRecordStore {
    func fetch(rowId: Int64, tx: any DBReadTransaction) throws -> CallLinkRecord? { fatalError() }
    func fetch(roomId: Data, tx: any DBReadTransaction) throws -> CallLinkRecord? { fatalError() }
    func fetchOrInsert(rootKey: CallLinkRootKey, tx: any DBWriteTransaction) throws -> CallLinkRecord { fatalError() }
    func update(_ callLinkRecord: CallLinkRecord, tx: any DBWriteTransaction) throws { fatalError() }
    func delete(_ callLinkRecord: CallLinkRecord, tx: any DBWriteTransaction) throws { fatalError() }
    func fetchAll(tx: any DBReadTransaction) throws -> [CallLinkRecord] { fatalError() }
    func fetchUpcoming(earlierThan expirationTimestamp: Date?, limit: Int, tx: any DBReadTransaction) throws -> [CallLinkRecord] { fatalError() }
    func fetchWhere(adminDeletedAtTimestampMsIsLessThan thresholdMs: UInt64, tx: any DBReadTransaction) throws -> [CallLinkRecord] { fatalError() }
    func fetchAnyPendingRecord(tx: any DBReadTransaction) throws -> CallLinkRecord? { fatalError() }
}

#endif
