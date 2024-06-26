import SwiftUI

struct ContentView: View {
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            InvoicesView()
        }
        .onAppear {
            Task {
                if let token = await authenticationViewModel.getToken(), let appVanityDomain = authenticationViewModel.appVanityDomain {
                    authenticationViewModel.tenantId = await usersViewModel.loadCurrentUser(appVanityDomain: appVanityDomain, token: token)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                
            }
            if usersViewModel.isAdmin {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: "Admin") {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                            .foregroundColor(CustomColors.invoBlue)
                    }
                    
                }
            }
            if usersViewModel.currentUser != nil {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: "Settings") {
                        Image(systemName: "gear")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                            .foregroundColor(CustomColors.invoBlue)
                    }
                    
                }
            }
        }
        .navigationDestination(for: String.self) { destination in
            if let currentUser = usersViewModel.currentUser {
                if destination == "Settings" {
                    SettingsView(currentUser: currentUser)
                } else if destination == "Admin" {
                    AdminView()
                }
            }
        }
    }
}


struct Contentview_Previews: PreviewProvider {
    static var previews: some View {
        let authenticationViewModel = AuthenticationViewModel()
        let usersViewModel = UsersViewModel()
        
        usersViewModel.currentUser = User(id: "1", appId: "1", email: "fddiferd@gmail.com", emailVerified: true, givenName: "Donato", familyName: "DiFerdinando", middleName: "", nickname: nil, pictureUrl: nil, gender: nil, birthdate: nil, locale: "US", timezone: nil, identityProviderName: nil, tenantId: nil, updatedAt: nil)
        usersViewModel.isAdmin = true
        
        return NavigationStack {
            ContentView()
                .environmentObject(authenticationViewModel)
                .environmentObject(usersViewModel)
        }
    }
}
