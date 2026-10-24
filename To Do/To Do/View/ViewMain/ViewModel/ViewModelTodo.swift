import SwiftUI
import Observation

@MainActor
@Observable
final class ViewModelTodo {

    var todos: [ModelTodoResponse] = []
    var isLoadingTodos = false
    var isSaving = false
    var isDeleting = false
    var isUnauthorized = false
    var errorMessage: String?
    var searchText = ""
    var sortAscending = true
    var editingTodo: ModelTodoResponse?

    private(set) var token: String?
    private let service = ItemService()

    // MARK: - Списки

    private var searched: [ModelTodoResponse] {
        let q = searchText.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return todos }
        return todos.filter { $0.title.localizedCaseInsensitiveContains(q) }
    }

    private func sorted(_ list: [ModelTodoResponse]) -> [ModelTodoResponse] {
        list.sorted {
            sortAscending ? $0.dateValue < $1.dateValue : $0.dateValue > $1.dateValue
        }
    }

    var activeTodos: [ModelTodoResponse] {
        sorted(searched.filter { !$0.isCheck })
    }

    var completedTodos: [ModelTodoResponse] {
        sorted(searched.filter { $0.isCheck })
    }

    var isEmpty: Bool { todos.isEmpty }

    func toggleSort() { sortAscending.toggle() }

    // MARK: - Загрузка
    func loadTodos(token: String?) async {
        self.token = token
        errorMessage = nil
        isUnauthorized = false
        isLoadingTodos = true
        defer { isLoadingTodos = false }

        guard let token else {
            todos = []
            errorMessage = "Нет токена — войдите заново"
            return
        }

        do {
            todos = try await service.fetchTodos(token: token)
        } catch ItemError.unauthorized {
            isUnauthorized = true
            errorMessage = "Сессия истекла — войдите заново"
        } catch {
            print("TODO LOAD ERROR:", error)
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Создание
    func addTodo(title: String, date: Date) async -> Bool {
        guard let token else {
            errorMessage = "Нет токена — войдите заново"
            return false
        }

        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Введите название"
            return false
        }

        errorMessage = nil
        isSaving = true
        defer { isSaving = false }

        do {
            if let created = try await service.createTodo(title: trimmed, date: date, token: token) {
                todos.insert(created, at: 0)
            } else {
                todos = try await service.fetchTodos(token: token)
            }
            return true
        } catch {
            print("TODO CREATE ERROR:", error)
            errorMessage = error.localizedDescription
            return false
        }
    }

    // MARK: - Редактирование (PUT)
    func updateTodo(_ todo: ModelTodoResponse, title: String, date: Date) async -> Bool {
        guard let token else {
            errorMessage = "Нет токена — войдите заново"
            return false
        }

        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Введите название"
            return false
        }

        errorMessage = nil
        isSaving = true
        defer { isSaving = false }

        do {
            if let updated = try await service.updateTodo(
                id: todo.id, title: trimmed, date: date,
                isCheck: todo.isCheck, token: token
            ) {
                replace(updated)
            } else if let i = todos.firstIndex(where: { $0.id == todo.id }) {
                todos[i].title = trimmed
                todos[i].date = ModelTodoResponse.isoString(from: date)
            }
            return true
        } catch {
            print("TODO UPDATE ERROR:", error)
            errorMessage = error.localizedDescription
            return false
        }
    }

    // MARK: - Галочка: читаем актуальное значение
    func isChecked(_ todo: ModelTodoResponse) -> Bool {
        todos.first(where: { $0.id == todo.id })?.isCheck ?? todo.isCheck
    }

    /// Вызывается из Binding: сначала меняем локально (синхронно), потом PATCH
    func setChecked(_ todo: ModelTodoResponse, to newValue: Bool) {
        guard let i = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        let old = todos[i].isCheck
        guard old != newValue else { return }

        todos[i].isCheck = newValue   // оптимистично, сразу

        Task {
            await pushCheck(todo, to: newValue, rollback: old)
        }
    }

    private func pushCheck(_ todo: ModelTodoResponse, to newValue: Bool, rollback: Bool) async {
        guard let token else {
            restore(todo, to: rollback)
            errorMessage = "Нет токена — войдите заново"
            return
        }

        do {
            try await service.patchCheck(id: todo.id, isCheck: newValue, token: token)
            // локальное значение уже верное — ответ сервера НЕ применяем,
            // иначе строка дёргается
        } catch ItemError.unauthorized {
            restore(todo, to: rollback)
            isUnauthorized = true
            errorMessage = "Сессия истекла — войдите заново"
        } catch {
            restore(todo, to: rollback)
            print("TODO PATCH ERROR:", error)
            errorMessage = error.localizedDescription
        }
    }

    private func restore(_ todo: ModelTodoResponse, to value: Bool) {
        if let i = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[i].isCheck = value
        }
    }

    // MARK: - Удаление
    func delete(_ todo: ModelTodoResponse) async {
        guard let token else {
            errorMessage = "Нет токена — войдите заново"
            return
        }

        errorMessage = nil
        isDeleting = true
        defer { isDeleting = false }

        do {
            try await service.deleteTodo(id: todo.id, token: token)
            todos.removeAll { $0.id == todo.id }
            editingTodo = nil
        } catch {
            print("TODO DELETE ERROR:", error)
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Helpers
    private func replace(_ item: ModelTodoResponse) {
        if let i = todos.firstIndex(where: { $0.id == item.id }) {
            todos[i] = item
        } else {
            todos.insert(item, at: 0)
        }
    }

    func openMenu(_ todo: ModelTodoResponse) {
        withAnimation(.easeInOut(duration: 0.2)) { editingTodo = todo }
    }

    func closeMenu() {
        withAnimation(.easeInOut(duration: 0.2)) { editingTodo = nil }
    }

    func reset() {
        todos = []
        searchText = ""
        errorMessage = nil
        editingTodo = nil
    }
}
