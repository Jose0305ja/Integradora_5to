import SwiftUI

struct EditUserSheet: View {
    let userId: String
    var onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var localization: LocalizationManager

    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedRole: RoleModel?
    @State private var roles: [RoleModel] = []
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false

    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.tertiaryColor)
            }

            Spacer()

            Text("Editar usuario")
                .font(.headline)
                .foregroundColor(.tertiaryColor)

            Spacer()

            Button("Guardar") { saveChanges() }
                .disabled(username.isEmpty || firstName.isEmpty || lastName.isEmpty || selectedRole == nil)
                .foregroundColor(.tertiaryColor)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 4)
        .background(Color.primaryColor)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.primaryColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    header

                    ScrollView {
                        VStack(spacing: 20) {
                            SectionContainer(title: "Información") {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Nombre de usuario")
                                        .font(.caption)
                                        .foregroundColor(.tertiaryColor)
                                    TextField("Usuario", text: $username)
                                        .padding(10)
                                        .background(Color.fourthColor)
                                        .cornerRadius(8)
                                        .foregroundColor(.primary)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Nombre")
                                        .font(.caption)
                                        .foregroundColor(.tertiaryColor)
                                    TextField("Nombre", text: $firstName)
                                        .padding(10)
                                        .background(Color.fourthColor)
                                        .cornerRadius(8)
                                        .foregroundColor(.primary)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Apellido")
                                        .font(.caption)
                                        .foregroundColor(.tertiaryColor)
                                    TextField("Apellido", text: $lastName)
                                        .padding(10)
                                        .background(Color.fourthColor)
                                        .cornerRadius(8)
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.vertical, 4)
                            .foregroundColor(.tertiaryColor)

                            SectionContainer(title: "Rol") {
                                Picker("Rol", selection: $selectedRole) {
                                    ForEach(roles, id: \.self) { role in
                                        Text(role.name).tag(role as RoleModel?)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }
                        .padding()
                        .foregroundColor(.tertiaryColor)
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { fetchDetails() }
        .alert("Cambios guardados", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {
                dismiss()
                onSave()
            }
        }
        .alert("Ocurrió un error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    private func fetchDetails() {
        UserService.shared.fetchUserDetails(id: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let u = response.user
                    username = u.username
                    firstName = u.first_name
                    lastName = u.last_name
                    roles = response.roles
                    selectedRole = response.roles.first(where: { $0.id == u.role.id })
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    private func saveChanges() {
        guard let role = selectedRole else { return }
        let update = UpdateUserModel(username: username, first_name: firstName, last_name: lastName, role_id: role.id)
        UserService.shared.updateUser(id: userId, user: update) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    showSuccessAlert = true
                case .failure(let error):
                    print(error)
                    showErrorAlert = true
                }
            }
        }
    }
}
