//
//  ContentView.swift
//  GeminiFirebaseSwiftUI
//
//  Created by Anup D'Souza on 01/05/24.
//  🕸️ https://www.anupdsouza.com
//  🔗 https://twitter.com/swift_odyssey
//  👨🏻‍💻 https://github.com/anupdsouza
//  ☕️ https://www.buymeacoffee.com/anupdsouza
//

import SwiftUI

struct ContentView: View {
    @State private var textInput = ""
    @State private var chatService = ChatService()
    
    var body: some View {
        VStack {
            titleView()
            chatListView()
            inputView()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .background {
            Color.black.ignoresSafeArea()
        }
        .onAppear(perform: {
            // MARK: Fetch messages
            chatService.fetchMessages()
        })
    }
    
    // MARK: Title view
    @ViewBuilder private func titleView() -> some View {
        VStack(alignment: .center, content: {
            HStack(alignment: .center, content: {
                Image("gemini")
                    .resizable()
                    .scaledToFit()
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .bold()
                    .frame(height: 20)
                Image("firebase")
                    .resizable()
                    .scaledToFit()
            })
            .frame(height: 50)
        })
    }
    
    // MARK: Chat list view
    @ViewBuilder private func chatListView() -> some View {
        ScrollViewReader(content: { proxy in
            ScrollView {
                ForEach(chatService.messages, id: \.self) { chatMessage in
                    chatMessageView(chatMessage)
                        .id(chatMessage.id)
                }
            }
            .onChange(of: chatService.messages) { oldValue, newValue in
                guard let recentMessage = chatService.messages.last else { return }
                DispatchQueue.main.async {
                    withAnimation {
                        proxy.scrollTo(recentMessage.id, anchor: .bottom)
                    }
                }
            }
        })
    }
    
    // MARK: Input view
    @ViewBuilder private func inputView() -> some View {
        HStack {
            TextField("Enter a message...", text: $textInput)
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(.black)
            Button(action: sendMessage, label: {
                Image(systemName: "paperplane.fill")
            })
        }
    }
    
    // MARK: Chat message view
    @ViewBuilder private func chatMessageView(_ chat: Chat) -> some View {
        ChatBubble(direction: chat.isUser ? .right : .left) {
            Text(chat.message)
                .font(.title3)
                .padding(.all, 20)
                .foregroundStyle(.white)
                .background {
                    chat.isUser ? Color.blue : Color.green
                }
        }
    }
    
    // MARK: Send message
    private func sendMessage() {
        chatService.sendMessage(textInput)
        textInput = ""
    }
}

#Preview {
    ContentView()
}
