import SwiftUI

struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var noteTitle: String = ""
    @State private var noteContent: String = ""

    private let noteStorage = NoteStorage()

    var body: some View {
        VStack {
            // Input fields
            Text("Title:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

            TextEditor(text: $noteTitle)
                .frame(height: 50)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)

            Text("Content:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

            TextEditor(text: $noteContent)
                .frame(height: 50)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)

            // Buttons
            HStack {
                Button(action: {
                    if !noteTitle.isEmpty && !noteContent.isEmpty {
                        let newNote = Note(id: UUID(), title: noteTitle, content: noteContent)
                        noteStorage.saveNote(newNote)
                        notes = noteStorage.getAllNotes()
                        noteTitle = ""
                        noteContent = ""
                    }
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                }

                Button(action: {
                    noteStorage.deleteLatestNote()
                    notes = noteStorage.getAllNotes()
                }) {
                    Text("Delete Latest")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.red))
                }
            }
            .padding(.horizontal)

            // Notes Section
            Text("Saved Notes:")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                .padding(.leading)

            if notes.isEmpty {
                Text("No notes saved")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(Array(notes.reversed().enumerated()), id: \.element.id) { (index, note) in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(index + 1). \(note.title)")
                                .font(.headline)
                            Text(note.content)
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .onAppear {
            notes = noteStorage.getAllNotes()
        }
    }
}
