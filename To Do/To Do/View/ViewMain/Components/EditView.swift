import SwiftUI

struct EditView: View {
    let todo: ModelTodoResponse
    var isDeleting: Bool = false
    var onEdit: () -> Void
    var onDelete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text(todo.title)
                .urbanistFont(fontType: .semiBold, size: 15)
                .foregroundStyle(.appBlack)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.top, 28)

            Text(todo.displayDate)
                .urbanistFont(fontType: .bold, size: 13)
                .foregroundStyle(.appGray)
                .padding(.top, 6)
                .padding(.bottom, 24)

            Button {
                onEdit()
            } label: {
                Text("Edit")
                    .urbanistFont(fontType: .semiBold, size: 14)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(Color.appBlack,
                        in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous))
            .padding(.horizontal, 24)
            .padding(.bottom, 14)

            Button {
                onDelete()
            } label: {
                if isDeleting {
                    ProgressView().tint(.appRed)
                } else {
                    Text("Delete")
                        .urbanistFont(fontType: .semiBold, size: 14)
                        .foregroundStyle(.appRed)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(Color.appWhite,
                        in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous))
            .overlay(
                RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous)
                    .stroke(Color.appRed, lineWidth: 1)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            .disabled(isDeleting)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 34)          // home indicator
        .background(Color.appWhite)
        .clipShape(
            UnevenRoundedRectangle(topLeadingRadius: 30, topTrailingRadius: 30)
        )
    }
}
