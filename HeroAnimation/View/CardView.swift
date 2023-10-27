//
//  CardView.swift
//  HeroAnimation
//
//  Created by Edgar Ernesto Vergara Montiel on 27/10/23.
//

import SwiftUI

struct CardView: View {
    let item: Today
    
    let currentItem: Today?
    let showDetailPage: Bool
    let animateView: Bool
    
    let animation: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ZStack(alignment: .topLeading) {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    Image(item.artwork)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height)
                        .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 15))
                }
                .frame(height: 400)
                
                LinearGradient(colors: [
                    .black.opacity(0.5),
                    .black.opacity(0.2),
                    .clear
                ], startPoint: .top, endPoint: .bottom)
                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text(item.platformTitle.uppercased())
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Text(item.bannerTitle)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.leading)
                })
                .foregroundStyle(.white)
                .padding()
                .offset(y: currentItem?.id == item.id && animateView ? safeArea().top : 0)
            }
            
            HStack(spacing: 12) {
                Image(item.appLogo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.platformTitle.uppercased())
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    Text(item.appName)
                        .bold()
                    
                    Text(item.platformTitle.uppercased())
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    
                } label: {
                    Text("GET")
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background {
                            Capsule()
                                .fill(.ultraThinMaterial)
                        }
                }
            }
            .padding([.horizontal, .bottom])
        }
        .background {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color(.systemGray6))
        }
        .matchedGeometryEffect(id: item.id, in: animation, anchor: .leading)
    }
}

#Preview {
    @Namespace var animation
    
    return CardView(
        item: todayItems[0],
        currentItem: todayItems[0], 
        showDetailPage: false,
        animateView: false,
        animation: animation
    )
}
