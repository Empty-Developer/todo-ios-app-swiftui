import SwiftUI

struct ViewAddedItem: View {

    @Environment(\.dismiss) private var dismiss

    var todoVM: ViewModelTodo
    var editing: ModelTodoResponse? = nil

    @State private var selectTitle: String = ""
    @State private var selectDataInput: Date?

    private var isEditMode: Bool { editing != nil }

    private var isButtonDisabled: Bool {
        selectTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || selectDataInput == nil
        || todoVM.isSaving
    }

    var body: some View {
        VStack {
            // MARK: Header bar
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(.arrowLeft)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                Text(isEditMode ? "Edit item" : "Add a new item")
                    .urbanistFont(fontType: .semiBold, size: 17)
                    .foregroundStyle(.appBlack)

                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 89)
            .padding(.top, 51)
            .background(Color.appLighWhite)

            VStack {
                HStack {
                    Text("Title")
                    Spacer()
                }

                HStack {
                    TextField("Do something great", text: $selectTitle)
                        .urbanistFont(fontType: .regular, size: 16)
                        .foregroundStyle(Color.appBlack)
                }
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(Color.appLighWhite, in: RoundedRectangle(cornerSize: CGSize(width: 6, height: 6)))
                .overlay(
                    RoundedRectangle(cornerSize: CGSize(width: 6, height: 6))
                        .stroke(Color.appWhiteBlue, lineWidth: 1)
                )
                .padding(.bottom, 24)

                HStack {
                    Text("Due date")
                    Spacer()
                }

                HStack {
                    DataPickerTextField(placeholder: "Select Data", date: self.$selectDataInput)
                }
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(Color.appLighWhite, in: RoundedRectangle(cornerSize: CGSize(width: 6, height: 6)))
                .overlay(
                    RoundedRectangle(cornerSize: CGSize(width: 6, height: 6))
                        .stroke(Color.appWhiteBlue, lineWidth: 1)
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)

            Spacer()

            if let error = todoVM.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .padding(.bottom, 8)
            }

            // MARK: Button
            VStack {
                Button {
                    Task {
                        guard let date = selectDataInput else { return }
                        let success: Bool
                        if let editing {
                            success = await todoVM.updateTodo(editing, title: selectTitle, date: date)
                        } else {
                            success = await todoVM.addTodo(title: selectTitle, date: date)
                        }
                        if success { dismiss() }
                    }
                } label: {
                    if todoVM.isSaving {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(isEditMode ? "Save" : "Add")
                            .urbanistFont(fontType: .semiBold, size: 14)
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(isButtonDisabled ? Color.appWhiteGray : Color.appBlack,
                            in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous))
                .padding(.horizontal, 24)
                .disabled(isButtonDisabled)
            }
            .padding(.bottom, 35)
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.appWhite)
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.light)
        .onAppear {
            guard let editing else { return }
            selectTitle = editing.title
            selectDataInput = ModelTodoResponse.isoFormatter.date(from: editing.date)
        }
    }
}

#Preview {
    ViewAddedItem(todoVM: ViewModelTodo())
}
