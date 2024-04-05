//
//  OpenAIService.swift
//  vision-pro
//
//  Created by Benny Wu on 2024-04-04.
//

import Foundation
import Alamofire



class OpenAIService {
    private let endpointURL = "https://api.openai.com/v1/chat/completions"
    private let openAIApiKey = "<INSERT API KEY>" // too lazy so Imma expose for testing
    
    
    func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        
        let body = OpenAIChatBody(model: "gpt-4", messages: openAIMessages, stream: false)
        let headers: Alamofire.HTTPHeaders = [
            "Authorization": "Bearer \(openAIApiKey)"
        ]
        
        
        
        return try? await AF.request(endpointURL, method: .post, parameters: body, encoder: .json, headers: headers)
            .serializingDecodable(OpenAIChatResponse.self).value
    }
    
    func sendStreamNessage(messages: [Message]) -> DataStreamRequest {
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        
        let body = OpenAIChatBody(model: "gpt-4", messages: openAIMessages, stream: true)
        let headers: Alamofire.HTTPHeaders = [
            "Authorization": "Bearer \(openAIApiKey)"
        ]
        
        return AF.streamRequest(endpointURL, method: .post, parameters: body, encoder: .json, headers: headers)
        
    }
    
    func parseStreamData(_ data: String) -> [ChatStreamCompletionResponse] {
        let responseString = data.split(separator: "data:").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}).filter({!$0.isEmpty})
        let jsonDecoder = JSONDecoder()
        
        return responseString.compactMap { jsonString in
            let jsonData = jsonString.data(using: .utf8)
                    
            guard let streamResponse = try? jsonDecoder.decode(ChatStreamCompletionResponse.self, from: jsonData!) else {
                return nil
            }
            return streamResponse
        }
    }
}

struct Message: Decodable {
    let id: String
    let role: SenderRole
    let content: String
    let createAt: Date
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
    let stream: Bool
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
    
}

struct ChatStreamCompletionResponse: Decodable {
    let id: String
    let choices: [ChatStreamChoice]
}

struct ChatStreamChoice: Decodable {
    let delta: ChatStreamContent
}

struct ChatStreamContent: Decodable {
    let content: String
}
