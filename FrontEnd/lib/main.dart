import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const AkilliKampusApp());
}

class AkilliKampusApp extends StatelessWidget {
  const AkilliKampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Akıllı Kampüs Destek',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const GirisEkrani(),
    );
  }
}

// --- GİRİŞ EKRANI ---
class GirisEkrani extends StatelessWidget {
  const GirisEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(color: Color(0xFFE3F2FD), shape: BoxShape.circle),
                      child: const Text("🏛️", style: TextStyle(fontSize: 40)),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "KAMPÜS DESTEK",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "E-posta Adresi",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Şifre",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AnaSayfa()));
                      },
                      child: const Text("SİSTEME GİRİŞ", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const KayitEkrani()));
                      },
                      child: const Text("Hesabın yok mu? Kayıt Ol", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- KAYIT EKRANI ---
class KayitEkrani extends StatelessWidget {
  const KayitEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    const Text("YENİ KAYIT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1565C0))),
                    const SizedBox(height: 25),
                    _kayitFormAlanlari("Ad Soyad", Icons.person_outline),
                    _kayitFormAlanlari("E-posta", Icons.email_outlined),
                    _kayitFormAlanlari("Bölüm", Icons.school_outlined),
                    _kayitFormAlanlari("Rol", Icons.admin_panel_settings_outlined),
                    _kayitFormAlanlari("Şifre", Icons.lock_outline, sifreMi: true),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kayıt işlemi tamamlandı!")));
                      },
                      child: const Text("KAYDI TAMAMLA", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _kayitFormAlanlari(String label, IconData icon, {bool sifreMi = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        obscureText: sifreMi,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

// --- ANA SAYFA ---
class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  // GÜNCELLENEN LİSTE: Sokak Hayvanı Yardımı eklendi
  final List<Map<String, dynamic>> sikayetListesi = const [
    {"id": 1, "baslik": "Asansör Arızası", "kategori": "Teknik", "durum": "Açık", "renk": Colors.red, "tarih": "25.12.2025", "konum": "Mühendislik Fakültesi"},
    {"id": 2, "baslik": "Şüpheli Paket", "kategori": "Güvenlik", "durum": "İnceleniyor", "renk": Colors.orange, "tarih": "25.12.2025", "konum": "Kütüphane"},
    {"id": 3, "baslik": "Sokak Hayvanı Yardımı", "kategori": "Çevre", "durum": "Çözüldü", "renk": Colors.green, "tarih": "24.12.2025", "konum": "Öğrenci Tesisi"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text("Kampüs Bildirim Akışı", style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sikayetListesi.length,
        itemBuilder: (context, index) {
          final veri = sikayetListesi[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 50, height: 50,
                decoration: BoxDecoration(color: (veri["renk"] as Color).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(veri["kategori"][0], style: TextStyle(color: veri["renk"], fontWeight: FontWeight.bold, fontSize: 20))),
              ),
              title: Text(veri["baslik"], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${veri["konum"]}\n${veri["tarih"]}"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetayEkrani(bildirim: veri)));
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => const HaritaEkrani()));
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilEkrani()));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: "Raporlar"),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: "Harita"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profil"),
        ],
      ),
    );
  }
}

// --- DETAY EKRANI ---
class DetayEkrani extends StatefulWidget {
  final Map<String, dynamic> bildirim;
  const DetayEkrani({super.key, required this.bildirim});

  @override
  State<DetayEkrani> createState() => _DetayEkraniState();
}

class _DetayEkraniState extends State<DetayEkrani> {
  late String guncelDurum;

  @override
  void initState() {
    super.initState();
    guncelDurum = widget.bildirim["durum"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rapor Detayları")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              height: 180, width: double.infinity,
              decoration: BoxDecoration(color: (widget.bildirim["renk"] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: const Center(child: Icon(Icons.image_outlined, size: 50, color: Colors.grey)),
            ),
            const SizedBox(height: 20),
            Text(widget.bildirim["baslik"], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Divider(height: 40),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ActionChip(label: const Text("İncele"), onPressed: () => setState(() => guncelDurum = "İncelemede")),
              ActionChip(label: const Text("Çözüldü"), onPressed: () => setState(() => guncelDurum = "Çözüldü")),
            ]),
            const Spacer(),
            Text("GÜNCEL DURUM: $guncelDurum", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: widget.bildirim["renk"])),
          ],
        ),
      ),
    );
  }
}

// --- HARİTA EKRANI (ATAUNİ MÜHENDİSLİK) ---
class HaritaEkrani extends StatefulWidget {
  const HaritaEkrani({super.key});

  @override
  State<HaritaEkrani> createState() => _HaritaEkraniState();
}

class _HaritaEkraniState extends State<HaritaEkrani> {
  static LatLng _atauniMuhendislik = const LatLng(39.9082, 41.2435);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Atauni Kampüs Haritası")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _atauniMuhendislik,
          zoom: 16.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('muh'),
            position: _atauniMuhendislik,
            infoWindow: const InfoWindow(title: "Mühendislik Fakültesi", snippet: "Kampüs Destek Merkezi"),
          ),
          Marker(
            markerId: const MarkerId('lib'),
            position: const LatLng(39.9075, 41.2450),
            infoWindow: const InfoWindow(title: "Merkez Kütüphane", snippet: "Aydınlatma Bildirimi"),
          ),
          // GÜNCELLEME: Sokak Hayvanı Marker eklendi
          Marker(
            markerId: const MarkerId('animal'),
            position: const LatLng(39.9065, 41.2425),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: "Sokak Hayvanı Yardımı", snippet: "Öğrenci Tesisi Yakını"),
          ),
        },
      ),
    );
  }
}

// --- PROFİL EKRANI ---
class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Bilgileri")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 55, backgroundColor: Color(0xFF1E88E5), child: Text("CC", style: TextStyle(color: Colors.white, fontSize: 32))),
            const SizedBox(height: 30),
            _bilgiSatiri("Ad Soyad", "Çağla Candan"),
            _bilgiSatiri("E-posta", "cagla@atauni.edu.tr"),
            _bilgiSatiri("Bölüm", "Bilgisayar Mühendisliği"),
            const Spacer(),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 55), side: const BorderSide(color: Colors.red), foregroundColor: Colors.red),
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GirisEkrani())),
              child: const Text("OTURUMU KAPAT"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bilgiSatiri(String baslik, String icerik) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(baslik, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      Text(icerik, style: const TextStyle(fontSize: 17)),
      const Divider()
    ]);
  }
}