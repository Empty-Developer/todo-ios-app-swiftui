import SwiftUI

struct ViewMain: View {
    @Bindable var viewModel: ViewModelAuth
    @State private var todoVM = ViewModelTodo()
    @State private var itemToEdit: ModelTodoResponse?

    var body: some View {
        if !viewModel.authenticated {
            ViewAuth(viewModel: viewModel)
        } else {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        HeaderBarView(todoVM: todoVM, onLogout: { viewModel.logout() })
                        content
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea(edges: .top)
                    .background(Color.appWhite)

                    if let editing = todoVM.editingTodo {
                        Color.black.opacity(0.35)
                            .ignoresSafeArea()
                            .transition(.opacity)
                            .onTapGesture { todoVM.closeMenu() }
                        VStack(spacing: 0) {
                            Spacer(minLength: 0)
                            EditView(
                                todo: editing,
                                isDeleting: todoVM.isDeleting,
                                onEdit: {
                                    todoVM.closeMenu()
                                    itemToEdit = editing
                                },
                                onDelete: {
                                    Task { await todoVM.delete(editing) }
                                }
                            )
                        }
                        .ignoresSafeArea(edges: .bottom)
                        .transition(.move(edge: .bottom))
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: todoVM.editingTodo)
                .navigationDestination(item: $itemToEdit) { todo in
                    ViewAddedItem(todoVM: todoVM, editing: todo)
                }
            }
            .preferredColorScheme(.light)
            .task {
                await todoVM.loadTodos(token: viewModel.accessToken)
                if todoVM.isUnauthorized { viewModel.handleUnauthorized() }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if todoVM.isLoadingTodos {
            Spacer()
            ProgressView("Loading...")
            Spacer()

        } else if todoVM.isEmpty {
            Spacer()
            EmptyStateView(todoVM: todoVM)
            Spacer()

        } else {
            SearchBarView(
                searchText: $todoVM.searchText,
                sortAscending: todoVM.sortAscending,
                onSort: { todoVM.toggleSort() }
            )

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(todoVM.activeTodos) { todo in
                        TodoRowView(
                            todo: todo,
                            isOn: Binding(
                                get: { todoVM.isChecked(todo) },
                                set: { todoVM.setChecked(todo, to: $0) }
                            ),
                            onMore: { todoVM.openMenu(todo) }
                        )
                        .id("active-\(todo.id)")
                    }

                    if !todoVM.completedTodos.isEmpty {
                        CompletedHeaderView()

                        ForEach(todoVM.completedTodos) { todo in
                            TodoRowView(
                                todo: todo,
                                isOn: Binding(
                                    get: { todoVM.isChecked(todo) },
                                    set: { todoVM.setChecked(todo, to: $0) }
                                ),
                                onMore: { todoVM.openMenu(todo) }
                            )
                            .id("done-\(todo.id)")
                        }
                    }
                }
                .padding(.bottom, 24)
            }
        }

        if let error = todoVM.errorMessage {
            Text(error)
                .font(.caption)
                .foregroundStyle(.red)
                .padding(.horizontal, 24)
                .padding(.top, 8)
        }
    }
}

#Preview {
    ViewMain(viewModel: ViewModelAuth())
}
