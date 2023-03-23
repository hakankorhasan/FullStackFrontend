//
//  TabBarView.swift
//  fullstack-iosApp
//
//  Created by Hakan Körhasan on 22.03.2023.
//

import SwiftUI
import LBTATools

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingController = UIHostingController(rootView: TabBarView())
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

struct UIViewControllerWrapperView<T: LBTAListCell<U>, U>: UIViewControllerRepresentable where T: UICollectionViewCell {
    typealias UIViewControllerType = LBTAListController<T, U>
    
    let controller: LBTAListController<T, U>
    
    func makeUIViewController(context: Context) -> LBTAListController<T, U> {
        return controller
    }
    
    func updateUIViewController(_ uiViewController: LBTAListController<T, U>, context: Context) {}
}


struct TabBarView: View {
    
    @State var selectedTab = "Home"
    
    let tabs = ["Home","Search","Create post", "Profile"]
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        NavigationView {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    
                    UIViewControllerWrapperView(controller: HomeController(userId: ""))
                        //Text("home")
                            .tag("Home")
                    
                    UIViewControllerWrapperView(controller: UserSearchController())
                        //Text("search")
                            .tag("Search")

                    // UIViewControllerWrapperView(controller: CreatePostController(selectedImage: ))
                    Text("Create")
                        .tag("Create post")
                
                    //UIViewControllerWrapperView(controller: ProfileController(userId: ""))
                    Text("Profile")
                        .tag("Profile")
                    
            }
            
            HStack(alignment: .bottom) {
                    
                ForEach(tabs, id: \.self) { tab in
                    TabBarItem(tab: tab, selected: $selectedTab)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
            .background(Color("tabbar"))
        }
        }
        
    }
    
   
}

struct TabBarItem: View {
   
    let tab: String
    @Binding var selected: String
    var body: some View {
        
            ZStack{
                Button {
                    withAnimation(.spring()) {
                        selected = tab
                    }
                } label: {
                    HStack{
                        Image(tab)
                            .resizable()
                            .frame(width: 25, height: 25)
                        if selected == tab {
                            Text(tab)
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                 
                    }
                }

            }
            .opacity(selected == tab ? 1 : 0.7)
            .padding(.vertical, 5)
            .padding(.horizontal, 17)
            .background(selected == tab ? .white : Color("tabbar"))
            .clipShape(Capsule())
     //   }
       
    }
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
