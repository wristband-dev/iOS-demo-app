import SwiftUI
import SafariServices

struct TenantLoginBrowserView: UIViewControllerRepresentable {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    // Function to create the SFSafariViewController instance
    func makeUIViewController(context: UIViewControllerRepresentableContext<TenantLoginBrowserView>) -> SFSafariViewController {
        
        // Building the URL string using the required parameters
        if let appVanityDomain = authenticationViewModel.appVanityDomain,
           let clientId = authenticationViewModel.clientId,
           let codeChallenge = authenticationViewModel.codeChallenge,
           let tenantDomainName = authenticationViewModel.tenantDomainName,
           let state = authenticationViewModel.state,
           let nonce = authenticationViewModel.nonce
            {
            
            var urlString = "https://\(tenantDomainName)-\(appVanityDomain)/api/v1/oauth2/authorize?client_id=\(clientId)&response_type=code&redirect_uri=mobiledemoapp%3A%2F%2Fcallback&state=\(state)&nonce=\(nonce)&scope=roles+openid+offline_access+profile+email+phone&code_challenge=\(codeChallenge)&code_challenge_method=S256"
            
            if let tenantId = authenticationViewModel.tenantId {
                urlString.append("&login_hint=\(tenantId)")
            }
            
            // Check if the URL is valid
            if let url = URL(string: urlString) {
                // If URL is valid, return a SFSafariViewController with the URL
                return SFSafariViewController(url: url)
            }
        }
        
        // Handle the invalid URL case by showing a blank SFSafariViewController or handling it in a better way
        let blankURL = URL(string: "about:blank")!
        let alertViewController = SFSafariViewController(url: blankURL)
        return alertViewController // Returning a blank SFSafariViewController to avoid app crash
    }
    
    // Required to conform to UIViewControllerRepresentable
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<TenantLoginBrowserView>) {
    }
}
