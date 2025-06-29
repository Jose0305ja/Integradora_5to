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
                    print("[UserManagementVM] received users: \(users.count)")
                    if users.isEmpty {
                        print("[UserManagementVM] user array is empty")
                    }
                    self.users = users
                    self.errorMessage = nil
                case .failure(let error):
                    print("[UserManagementVM] error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.users = []
                }
            }
        }
    }

    func deleteUser(id: String) {
        UserService.shared.deleteUser(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.users.removeAll { $0.id == id }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func fetchUserDetails(id: String, completion: @escaping (UserDetailsResponse?) -> Void) {
        guard !isLoading else { return }
        isLoading = true
        UserService.shared.fetchUserDetails(id: id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            }
        }
    }
}
