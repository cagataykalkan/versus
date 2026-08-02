//
//  FirebaseTournamentWorker.swift
//  Versus
//

import FirebaseAuth
import FirebaseFirestore

final class FirebaseTournamentWorker: TournamentWorkerProtocol {
    private let firestore = Firestore.firestore()

    private var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    func createTournament(draft: TournamentCreationDraft) async throws -> String {
        Log.request("TournamentWorker.createTournament name=\(draft.name) sport=\(draft.sport.rawValue) players=\(draft.players.count)")
        guard let uid = currentUserId else {
            Log.response("TournamentWorker.createTournament failed: not authenticated")
            throw WorkerError.notAuthenticated
        }

        let playersData: [[String: Any]] = draft.players.map { player in
            switch player.kind {
            case .registered(let user):
                return ["id": user.id, "kind": PlayerKind.registered.rawValue, "displayName": player.displayName]
            case .guest:
                return ["id": player.id, "kind": PlayerKind.guest.rawValue, "displayName": player.displayName]
            }
        }
        let playerIds: [String] = draft.players.compactMap { player in
            if case .registered(let user) = player.kind { return user.id }
            return nil
        }

        let rulesData: [String: Any] = [
            "drawAllowed": draft.rules.drawAllowed,
            "rematchAllowed": draft.rules.rematchAllowed,
            "doubleRound": draft.rules.doubleRound,
            "matchFormat": draft.rules.matchFormat.rawValue,
            "pointsWin": draft.rules.pointsWin,
            "pointsDraw": draft.rules.pointsDraw,
            "pointsLoss": draft.rules.pointsLoss
        ]

        let ref = firestore.collection("tournaments").document()
        do {
            try await ref.setData([
                "ownerId": uid,
                "name": draft.name,
                "sport": draft.sport.rawValue,
                "customSportName": draft.sport == .custom ? draft.customSportName : NSNull(),
                "type": draft.type.rawValue,
                "status": TournamentStatus.active.rawValue,
                "rules": rulesData,
                "playerIds": playerIds + [uid],
                "players": playersData,
                "createdAt": FieldValue.serverTimestamp()
            ])
            Log.response("TournamentWorker.createTournament succeeded id=\(ref.documentID)")
            return ref.documentID
        } catch {
            Log.response("TournamentWorker.createTournament failed: \(error.localizedDescription)")
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    func fetchTournaments() async throws -> [Tournament] {
        Log.request("TournamentWorker.fetchTournaments")
        guard let uid = currentUserId else {
            Log.response("TournamentWorker.fetchTournaments failed: not authenticated")
            throw WorkerError.notAuthenticated
        }

        do {
            let snapshot = try await firestore.collection("tournaments")
                .whereField("playerIds", arrayContains: uid)
                .getDocuments()

            let tournaments = snapshot.documents.compactMap { Self.makeTournament(id: $0.documentID, data: $0.data()) }
                .sorted(by: { $0.createdAt > $1.createdAt })
            Log.response("TournamentWorker.fetchTournaments succeeded count=\(tournaments.count)")
            return tournaments
        } catch {
            Log.response("TournamentWorker.fetchTournaments failed: \(error.localizedDescription)")
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    private static func makeTournament(id: String, data: [String: Any]) -> Tournament? {
        guard let ownerId = data["ownerId"] as? String,
              let name = data["name"] as? String,
              let sportRaw = data["sport"] as? String,
              let sport = Sport(rawValue: sportRaw),
              let typeRaw = data["type"] as? String,
              let type = TournamentType(rawValue: typeRaw),
              let statusRaw = data["status"] as? String,
              let status = TournamentStatus(rawValue: statusRaw),
              let rulesData = data["rules"] as? [String: Any],
              let matchFormatRaw = rulesData["matchFormat"] as? String,
              let matchFormat = MatchFormat(rawValue: matchFormatRaw)
        else { return nil }

        let rules = TournamentRules(
            drawAllowed: rulesData["drawAllowed"] as? Bool ?? false,
            rematchAllowed: rulesData["rematchAllowed"] as? Bool ?? false,
            doubleRound: rulesData["doubleRound"] as? Bool ?? false,
            matchFormat: matchFormat,
            pointsWin: rulesData["pointsWin"] as? Int ?? 3,
            pointsDraw: rulesData["pointsDraw"] as? Int ?? 1,
            pointsLoss: rulesData["pointsLoss"] as? Int ?? 0
        )

        let players: [TournamentPlayer] = (data["players"] as? [[String: Any]] ?? []).compactMap { entry in
            guard let id = entry["id"] as? String,
                  let kindRaw = entry["kind"] as? String,
                  let kind = PlayerKind(rawValue: kindRaw),
                  let displayName = entry["displayName"] as? String
            else { return nil }
            return TournamentPlayer(id: id, kind: kind, displayName: displayName)
        }

        let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()

        return Tournament(
            id: id,
            ownerId: ownerId,
            name: name,
            sport: sport,
            customSportName: data["customSportName"] as? String,
            type: type,
            status: status,
            rules: rules,
            players: players,
            createdAt: createdAt
        )
    }
}
