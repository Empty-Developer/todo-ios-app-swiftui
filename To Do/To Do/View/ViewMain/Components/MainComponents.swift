import SwiftUI

// MARK: Header
struct HeaderBarView: View {
    var todoVM: ViewModelTodo
    var onLogout: () -> Void = {}

    var body: some View {
        HStack(spacing: 16) {
            Text("To do app")
                .urbanistFont(fontType: .semiBold, size: 17)
                .foregroundStyle(.appBlack)

            Spacer()

            NavigationLink {
                ViewAddedItem(todoVM: todoVM)
            } label: {
                HStack(spacing: 6) {
                    Text("Add item")
                        .urbanistFont(fontType: .semiBold, size: 14)
                        .foregroundStyle(.appBlack)
                    Image(.iconPlus)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: 89)
        .padding(.top, 51)
        .background(Color.appLighWhite)
    }
}

// MARK: Search + Sort
struct SearchBarView: View {
    @Binding var searchText: String
    var sortAscending: Bool = true
    var onSort: () -> Void = {}

    var body: some View {
        HStack {
            Image(.search)
                .resizable()
                .frame(width: 23, height: 23)

            TextField("Search here", text: $searchText)
                .urbanistFont(fontType: .medium, size: 13)

            Spacer()

            Button(action: onSort) {
                HStack(spacing: 4) {
                    Text("Sort by date")
                        .urbanistFont(fontType: .medium, size: 13)
                        .foregroundStyle(Color.appGray)
                    Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.appGray)
                }
            }
            .padding(.vertical, 24)
        }
        .padding(.horizontal, 24)
        .border(width: 1, edges: [.bottom], color: .appWhiteBlue)
    }
}

// MARK: one task
struct TodoRowView: View {
    let todo: ModelTodoResponse
    @Binding var isOn: Bool
    var onMore: () -> Void

    var body: some View {
        VStack {
            HStack {
                Toggle(todo.title, isOn: $isOn)
                    .urbanistFont(fontType: .semiBold, size: 18)
                    .toggleStyle(CheckboxToggleStyle())

                Spacer()

                Button(action: onMore) {
                    Image(.more2Line)
                        .resizable()
                        .frame(width: 18, height: 18)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 1)

            HStack {
                Text(todo.displayDate)
                    .urbanistFont(fontType: .bold, size: 13)
                    .foregroundStyle(.appGray)
                    .padding(.bottom, 16)
                Spacer()
            }
            .padding(.horizontal, 60)
        }
        .border(width: 1, edges: [.bottom], color: .appWhiteBlue)
    }
}

// MARK: "Completed" badge
struct CompletedHeaderView: View {
    var body: some View {
        HStack {
            Text("Completed")
                .urbanistFont(fontType: .medium, size: 12)
                .foregroundStyle(.appGray)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .background(Color.appLighWhite)
    }
}

// MARK: Empty State
struct EmptyStateView: View {
    var todoVM: ViewModelTodo

    var body: some View {
        VStack {
            Image(.mainImg)
            Text("No to do item here.\nCreate one!")
                .urbanistFont(fontType: .semiBold, size: 15)
                .multilineTextAlignment(.center)
                .foregroundStyle(.appGray)
                .frame(width: 141, height: 48)

            NavigationLink {
                ViewAddedItem(todoVM: todoVM)
            } label: {
                Text("Add a to do")
                    .urbanistFont(fontType: .semiBold, size: 14)
                    .foregroundStyle(.white)
            }
            .frame(width: 220, height: 48)
            .background(Color.appBlack,
                        in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous))
            .padding(.top, 40)
        }
    }
}
