//
//  FormRowLinkView.swift
//  Todo App
//
//  Created by Frannck Villanueva on 14/01/22.
//

import SwiftUI

struct FormRowLinkView: View {
    
    // MARK: - PROPERTIES
    
    var icon: String
    var color: Color
    var text: String
    var link: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
            ZStack {
                
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                Image(systemName: icon)
                    .imageScale(.large)
                    .foregroundColor(.white)
                
            } //: ZSTACK
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(text)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button(action: {
                // OPEN LINK
                guard let url = URL(string: link), UIApplication.shared.canOpenURL(url) else {
                    return
                }
                UIApplication.shared.open(url as URL)
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .accentColor(Color(.systemGray2))
            })
            
        } //: HSTACK
    }
}


// MARK: - PREVIEW
struct FormRowLinkView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowLinkView(icon: "globe", color: .pink, text: "Website", link: "https://swiftuimasterclass.com")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
