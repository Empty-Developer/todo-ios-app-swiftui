import Foundation
import SwiftUI

// MARK: Modified Calendar Dialog Box With TextField Interaction
struct DataPickerTextField: View {
    public var placeholder: String
    
    @Binding public var date: Date?
    
    @State private var isPresented = false
    @State private var draftDate = Date()
    
    private static let dataFormatter: DateFormatter = {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy/MM/dd"
        return dataFormatter
    }()
    
    private var text: String {
        guard let selectedDate = self.date else { return self.placeholder }
        return Self.dataFormatter.string(from: selectedDate)
    }
    
    // MARK: Properties Сommon Сomponent
    var body: some View {
        Button {
            self.draftDate = self.date ?? Date()
            self.setPresented(true)
        } label: {
            HStack {
                Text(self.text)
                    .foregroundStyle(self.date == nil ? Color.appWhiteGray : Color.appBlack)
                    .urbanistFont(fontType: .regular, size: 16)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: self.$isPresented) {
            DataPickerModal(date: self.$draftDate) {
                self.date = self.draftDate
                self.setPresented(false)
            }
        }
    }
    
    private func setPresented(_ value: Bool) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            self.isPresented = value
        }
    }
}

private struct DataPickerModal: View {
    @Binding var date: Date
    var onDone: () -> Void
    
    @State private var appeared = false
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(self.appeared ? 0.4 : 0)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                DatePicker("", selection: self.$date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                
                // MARK: Accessory View
                Button(action: self.onDone) {
                    Text("Done")
                        .urbanistFont(fontType: .semiBold, size: 14)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.appBlack, in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous)
                )
            }
            .tint(.appBlack)
            .padding(20)
            .frame(maxWidth: 380)
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 4))
            .padding(.horizontal, 16)
            .scaleEffect(self.appeared ? 1 : 0.92)
            .opacity(self.appeared ? 1 : 0)
        }
        .presentationBackground(.clear)
        .onAppear {
            withAnimation(.easeOut(duration: 0.2)) {
                self.appeared = true
            }
        }
    }
}
