package br.com.ifs.musicshow.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;

@Component
public class SocketTextHandler extends TextWebSocketHandler {

    @Autowired
    private WebSocketSessionService webSocketSessionService;

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws IOException {
        String payload = message.getPayload();
        System.out.println("Mensagem Recebida: " + payload);
        webSocketSessionService.sendMessageToAll(payload);
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        webSocketSessionService.save(session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status) {
        webSocketSessionService.remove(session);
    }
}