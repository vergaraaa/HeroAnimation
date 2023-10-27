//
//  DetailView.swift
//  HeroAnimation
//
//  Created by Edgar Ernesto Vergara Montiel on 27/10/23.
//

import SwiftUI

struct DetailView: View {
    let item: Today
    
    @Binding var currentItem: Today?
    @Binding var showDetailPage: Bool
    
    @Binding var animateView: Bool
    @Binding var animateContent: Bool
    @Binding var scrollOffset: CGFloat
    
    var animation: Namespace.ID
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack {
                    CardView(item: item, currentItem: currentItem, showDetailPage: showDetailPage, animateView: animateView, animation: animation)
                        .scaleEffect(animateView ? 1 : 0.93)
                    
                    VStack(spacing: 15) {
                        Text(dummyText)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(10)
                            .padding(.bottom, 20)
                        
                        Divider()
                        
                        Button {
                            
                        } label: {
                            Label(
                                title: { Text("Share Story") },
                                icon: { Image(systemName: "square.and.arrow.up.fill") }
                            )
                            .foregroundStyle(.primary)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            }
                        }
                    }
                    .padding()
                    .offset(y: scrollOffset > 0 ? scrollOffset : 0)
                    .opacity(animateContent ? 1 : 0)
                    .scaleEffect(animateView ? 1: 0, anchor: .top)
                }
            }
            .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
            .offset(offset: $scrollOffset)
        }
        .overlay(alignment: .topTrailing, content: {
            Button {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                    animateView = false
                    animateContent = false
                }
                
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                    currentItem = nil
                    showDetailPage = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
            }
            .padding()
            .padding(.top, safeArea().top)
            .offset(y: -10)
            .opacity(animateView ? 1 : 0)
        })
        .onAppear {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                animateView = true
            }
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.1)) {
                animateContent = true
            }
        }
        .transition(.identity)
    }
}

#Preview {
    @Namespace var animation
    
    return DetailView(item: todayItems[0], currentItem: .constant(todayItems[0]), showDetailPage: .constant(true), animateView: .constant(false), animateContent: .constant(false), scrollOffset: .constant(0), animation: animation)
}
