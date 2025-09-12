package br.com.ifs.musicshow.websocket;

import org.springframework.web.socket.WebSocketSession;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

public class WebSocketSessionRepository {
    private static WebSocketSessionRepository instance;
    private Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();

    private WebSocketSessionRepository() {}

    public static synchronized WebSocketSessionRepository getInstance() {
        if (instance == null) {
            instance = new WebSocketSessionRepository();
        }
        return instance;
    }

    public void save(WebSocketSession session) {
        sessions.put(session.getId(), session);
    }

    public WebSocketSession getById(String id) {
        return sessions.get(id);
    }

    public void removeById(String id) {
        sessions.remove(id);
    }

    public List<WebSocketSession> getAll() {
        return new ArrayList<>(sessions.values());
    }
}