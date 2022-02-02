//
//  SettingsView.swift
//  Todo App
//
//  Created by Frannck Villanueva on 14/01/22.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var iconSettings: IconNames
    
    let themes: [Theme] = themeData
    
    @ObservedObject var theme = ThemeSettings.shared
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                
                // FORM
                Form {
                    
                    // MARK: - SECTION 1
                    Section(header: Text("Choose the app icon"), content: {
                        Picker(
                            selection: $iconSettings.currentIndex,
                            label:
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .strokeBorder(Color.primary, lineWidth: 2)
                                        Image(systemName: "paintbrush")
                                            .font(.system(size: 28, weight: .regular, design: .default))
                                            .foregroundColor(Color.primary)
                                    } //: ZSTACK
                                    .frame(width: 44, height: 44)
                                    
                                    Text("App Icons".uppercased())
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.primary)
                                } //: LABEL
                            
                        ) {
                            ForEach(0..<iconSettings.iconNames.count) { index in
                                HStack {
                                    Image(uiImage: UIImage(named: iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(8)
                                    
                                    Spacer()
                                        .frame(width: 8)
                                    
                                    Text(iconSettings.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                    
                                } //: HSATCK
                                .padding(3)
                            }
                        } //: PICKER
                        .onReceive([iconSettings.currentIndex].publisher.first()) {
                            (value) in
                            let index = iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                            if index != value {
                                UIApplication.shared.setAlternateIconName(iconSettings.iconNames[value]) { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("Success! You have changed the app icon.")
                                    }
                                }
                            }
                        }
                    }) //: SECTION 1
                        .padding(.vertical, 3)
                    
                    // MARK: - SECTION 2
                    Section(
                        header:
                            HStack {
                                Text("Choose the app theme")
                                Image(systemName:"circle.fill")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(themes[theme.themeSettings].themeColor)
                            }
                    ) {
                        List {
                            ForEach(themes, id: \.id) { item in
                                Button(action: {
                                    theme.themeSettings = item.id
                                    UserDefaults.standard.set(theme.themeSettings, forKey: "Theme")
                                } , label: {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        Text(item.themeName)
                                    }
                                    
                                } ) //: BUTTON
                                    .accentColor(.primary)
                            }
                        }
                    } //: SECTION 2
                    .padding(.vertical, 3)
                    
                    // MARK: - SECTION 3
                    Section(header: Text("Follow us in social media")) {
                        FormRowLinkView(icon: "globe", color: .pink, text: "Website", link: "https://swiftuimasterclass.com")
                        FormRowLinkView(icon: "link", color: .blue, text: "LinkedIn", link: "https://linkedin.com/FrannckV")
                        FormRowLinkView(icon: "play.rectangle", color: .green, text: "Masterclass", link: "https://www.udemy.com/user/robert-petras")
                    } //: SECTION 3
                    .padding(.vertical, 3)
                    
                    // MARK: - SECTION 4
                    Section(header: Text("About the Application"), content: {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "ToDo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "FrannckV")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Robert Petras")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    }) //: SECTION 4
                    
                } //: FORM
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                // MARK: - FOOTER
                Text("Copyright © All rights reserved.\nBetter Apps ♡ Less Code")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(.secondary)
            } //: VSTACK
            .navigationBarItems(
                trailing:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    }))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("Background").edgesIgnoringSafeArea(.all))
        } //: NAVIGATION
        .accentColor(themes[theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}


// MARK: - PREVIEW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(IconNames())
    }
}
