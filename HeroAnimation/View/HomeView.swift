//
//  HomeView.swift
//  HeroAnimation
//
//  Created by Edgar Ernesto Vergara Montiel on 26/10/23.
//

import SwiftUI

struct HomeView: View {
    @State var currentItem: Today?
    @State var showDetailPage = false
    
    @Namespace var animation
    
    @State var animateView: Bool = false
    @State var animateContent: Bool = false
    @State var scrollOffset: CGFloat = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("MONDAY 4 APRIL")
                            .font(.callout)
                            .foregroundStyle(.gray)
                        
                        Text("Today")
                            .font(.largeTitle.bold())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .opacity(showDetailPage ? 0 : 1)
                
                ForEach(todayItems) { item in
                    Button {
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            currentItem = item
                            showDetailPage = true
                        }
                    } label: {
                        CardView(
                            item: item,
                            currentItem: currentItem,
                            showDetailPage: showDetailPage,
                            animateView: animateView,
                            animation: animation
                        )
                        .scaleEffect(currentItem?.id == item.id && showDetailPage ? 1 : 0.93)
                    }
                    .buttonStyle(ScaledButtonStyle())
                    .opacity(showDetailPage ? (currentItem?.id == item.id ? 1 : 0) : 1)
                }
            }
            .padding(.vertical)
        }
        .overlay {
            if let item = currentItem, showDetailPage {
                DetailView(
                    item: item,
                    currentItem: $currentItem, 
                    showDetailPage: $showDetailPage,
                    animateView: $animateView,
                    animateContent: $animateContent,
                    scrollOffset: $scrollOffset,
                    animation: animation
                )
                .ignoresSafeArea(.container, edges: .top)
            }
        }
        .background(alignment: .top) {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(colorScheme == .light ? .white : .black)
                .frame(height: animateView ? nil : 350, alignment: .top)
                .scaleEffect(animateView ? 1 : 0.93)
                .opacity(animateView ? 1 : 0)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}

struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

extension View {
    func safeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        
        return safeArea
    }
    
    func offset(offset: Binding<CGFloat>) -> some View {
        return self
            .overlay {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                }
                .onPreferenceChange(OffsetKey.self) { value in
                    offset.wrappedValue = value
                }
            }
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
