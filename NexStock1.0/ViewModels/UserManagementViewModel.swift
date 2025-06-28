import Foundation

class UserManagementViewModel: ObservableObject {
    @Published var users: [UserTableModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func fetchUsers() {
        guard !isLoading else { return }
        isLoading = true
        UserService.shared.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let users):
                    self.users = users
                    self.errorMessage = nil
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.users = []
                }
            }
        }
    }
}
