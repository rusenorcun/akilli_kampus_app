package com.mobil.kampusapp.incident;

import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Stream;

@Component
public class IncidentStore {

  private final AtomicLong seq = new AtomicLong(1);
  private final Map<Long, Incident> incidents = new ConcurrentHashMap<>();
  // incidentId -> followers (emails)
  private final Map<Long, Set<String>> followersByIncident = new ConcurrentHashMap<>();
  // userEmail -> followed incident ids
  private final Map<String, Set<Long>> followsByUser = new ConcurrentHashMap<>();

  public IncidentStore() {
    saveNew("Kırık merdiven", "Müh. Fak. girişte kırık basamak var", 39.90, 41.27, IncidentType.SAFETY, "admin@kampus.local");
    saveNew("Acil ilkyardım", "Spor salonunda öğrenci düştü", 39.91, 41.28, IncidentType.HEALTH, "user@kampus.local");
  }

  public Incident saveNew(String title, String desc, Double lat, Double lon, IncidentType type, String createdBy){
    var now = Instant.now();
    var inc = new Incident(seq.getAndIncrement(), title, desc, lat, lon, type, IncidentStatus.OPEN, createdBy, now, now);
    incidents.put(inc.id(), inc);
    followersByIncident.putIfAbsent(inc.id(), ConcurrentHashMap.newKeySet());
    return inc;
  }

  public Optional<Incident> findById(Long id){ return Optional.ofNullable(incidents.get(id)); }

  public Incident updateStatus(Long id, IncidentStatus status){
    var cur = incidents.get(id);
    var updated = new Incident(cur.id(), cur.title(), cur.description(), cur.lat(), cur.lon(),
        cur.type(), status, cur.createdBy(), cur.createdAt(), Instant.now());
    incidents.put(id, updated);
    return updated;
  }

  public Incident updateDescription(Long id, String description){
    var cur = incidents.get(id);
    var updated = new Incident(cur.id(), cur.title(), description, cur.lat(), cur.lon(),
        cur.type(), cur.status(), cur.createdBy(), cur.createdAt(), Instant.now());
    incidents.put(id, updated);
    return updated;
  }

  public Incident close(Long id){
    return updateStatus(id, IncidentStatus.RESOLVED);
  }

  public void follow(Long incidentId, String email){
    followersByIncident.computeIfAbsent(incidentId, k -> ConcurrentHashMap.newKeySet()).add(email);
    followsByUser.computeIfAbsent(email, k -> ConcurrentHashMap.newKeySet()).add(incidentId);
  }

  public void unfollow(Long incidentId, String email){
    followersByIncident.computeIfAbsent(incidentId, k -> ConcurrentHashMap.newKeySet()).remove(email);
    followsByUser.computeIfAbsent(email, k -> ConcurrentHashMap.newKeySet()).remove(incidentId);
  }

  public boolean isFollowing(Long incidentId, String email){
    return followersByIncident.getOrDefault(incidentId, Set.of()).contains(email);
  }

  public Set<Long> followedByUser(String email){
    return Set.copyOf(followsByUser.getOrDefault(email, Set.of()));
  }

  public List<Incident> findAllFiltered(String q, IncidentType type, IncidentStatus status,
                                        Boolean followedOnly, String forUserEmail,
                                        String sort, boolean desc, int page, int size) {

    Stream<Incident> s = incidents.values().stream();

    if (q != null && !q.isBlank()) {
      var ql = q.toLowerCase();
      s = s.filter(i -> (i.title()+" "+i.description()).toLowerCase().contains(ql));
    }
    if (type != null)   s = s.filter(i -> i.type() == type);
    if (status != null) s = s.filter(i -> i.status() == status);

    if (Boolean.TRUE.equals(followedOnly) && forUserEmail != null) {
      var my = followedByUser(forUserEmail);
      s = s.filter(i -> my.contains(i.id()));
    }

    Comparator<Incident> cmp = switch (sort == null ? "createdAt" : sort) {
      case "title" -> Comparator.comparing(Incident::title, String.CASE_INSENSITIVE_ORDER);
      case "type"  -> Comparator.comparing(Incident::type);
      case "status"-> Comparator.comparing(Incident::status);
      default      -> Comparator.comparing(Incident::createdAt);
    };
    if (desc) cmp = cmp.reversed();

    var list = s.sorted(cmp).toList();
    int from = Math.min(page * size, list.size());
    int to   = Math.min(from + size, list.size());
    return list.subList(from, to);
  }

  public long countFiltered(String q, IncidentType type, IncidentStatus status, Boolean followedOnly, String forUser){
    return incidents.values().stream()
        .filter(i -> q == null || (i.title()+" "+i.description()).toLowerCase().contains(q.toLowerCase()))
        .filter(i -> type == null || i.type() == type)
        .filter(i -> status == null || i.status() == status)
        .filter(i -> !Boolean.TRUE.equals(followedOnly) || (forUser != null && followedByUser(forUser).contains(i.id())))
        .count();
  }
}
