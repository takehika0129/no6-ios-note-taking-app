import Foundation

class NoteStorage {
    private static let notesKey = "notesKey"
    private let defaults = UserDefaults.standard

    func saveNote(_ note: Note) {
        var notes = getAllNotes()
        notes.append(note)
        if let encoded = try? JSONEncoder().encode(notes) {
            defaults.set(encoded, forKey: NoteStorage.notesKey)
        }
    }

    func getAllNotes() -> [Note] {
        guard let savedData = defaults.data(forKey: NoteStorage.notesKey),
              let notes = try? JSONDecoder().decode([Note].self, from: savedData) else {
            return []
        }
        return notes
    }

    func deleteLatestNote() {
        var notes = getAllNotes()
        if !notes.isEmpty {
            notes.removeLast()
            if let encoded = try? JSONEncoder().encode(notes) {
                defaults.set(encoded, forKey: NoteStorage.notesKey)
            }
        }
    }
}
