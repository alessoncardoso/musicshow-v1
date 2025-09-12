package br.com.ifs.musicshow.websocket;

import org.springframework.stereotype.Service;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.util.List;

@Service
public class WebSocketSessionService {
    private WebSocketSessionRepository repository = WebSocketSessionRepository.getInstance();

    public void save(WebSocketSession session) {
        repository.save(session);
    }

    public void sendMessageToAll(String message) {
        List<WebSocketSession> sessions = repository.getAll();
        for (WebSocketSession session : sessions) {
            try {
                session.sendMessage(new TextMessage(message));
            } catch (Exception e) {
                e.printStackTrace();
                repository.removeById(session.getId());
            }
        }
    }

    public void remove(WebSocketSession session) {
        repository.removeById(session.getId());
    }
}