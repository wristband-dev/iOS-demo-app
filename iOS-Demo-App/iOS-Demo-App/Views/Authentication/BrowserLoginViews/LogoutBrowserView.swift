import SwiftUI
import SafariServices

struct LogoutBrowserView: UIViewControllerRepresentable {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    // Function to create the SFSafariViewController instance
    func makeUIViewController(context: UIViewControllerRepresentableContext<LogoutBrowserView>) -> SFSafariViewController {
        
        // Building the URL string using the required parameters
        if let appVanityDomain = authenticationViewModel.appVanityDomain,
           let clientId = authenticationViewModel.clientId,
           let tenantDomainName = authenticationViewModel.tenantDomainName
        {
            let urlString = "https://\(tenantDomainName)-\(appVanityDomain)/api/v1/logout?client_id=\(clientId)&redirect_url=mobiledemoapp://logout"
            
            // Check if the URL is valid
            if let url = URL(string: urlString) {
                return SFSafariViewController(url: url)
            }
        }
        
        // Handle the invalid URL case by showing a blank SFSafariViewController or handling it in a better way
        let blankURL = URL(string: "about:blank")!
        let alertViewController = SFSafariViewController(url: blankURL)
        return alertViewController // Returning a blank SFSafariViewController to avoid app crash
    }
    
    // Required to conform to UIViewControllerRepresentable
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<LogoutBrowserView>) {
    }
}
