package com.mobil.kampusapp.notify;

import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

@Component
public class NotificationCenter {

  private static final int MAX_PER_USER = 100;

  private final AtomicLong seq = new AtomicLong(1);
  private final Map<String, Deque<Notification>> userQueues = new ConcurrentHashMap<>();

  public void pushToUser(String email, String type, String title, String message){
    var q = userQueues.computeIfAbsent(email, k -> new ArrayDeque<>());
    q.addFirst(new Notification(seq.getAndIncrement(), type, title, message, Instant.now()));
    while(q.size() > MAX_PER_USER) q.removeLast();
  }

  public List<Notification> listForUser(String email){
    var q = userQueues.getOrDefault(email, new ArrayDeque<>());
    return List.copyOf(q);
  }
}
