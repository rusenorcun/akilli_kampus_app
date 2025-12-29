import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'services/api_service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

const String backendApiUrl = 'https://career-exception-bracelet-compact.trycloudflare.com'; //burası cloudflare ipsi yazılacak veya kullanıma göre localhost
                                                                                            //veya 127.0.0.1 ile çalıştırılacak.

final ApiService apiService = ApiService(backendApiUrl);

void main() {
  HttpOverrides.global = MyHttpOverrides();
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
        chipTheme: ChipThemeData(
          backgroundColor: Colors.blueGrey.shade100,
          side: BorderSide.none,
        ),
      ),
      home: const GirisEkrani(),
    );
  }
}

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final response = await apiService.post('/api/auth/login', {//login isteği atıyoruz.
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      apiService.setAuthToken(response['token']);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AnaSayfa()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text('Giriş başarısız: ${e.toString().replaceAll("Exception: ", "")}')),//hata almamız durumunda global exception controllerdan dönen hatayı alırırz
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color(0xFFE3F2FD), shape: BoxShape.circle),
                      child: const Text("🏛️", style: TextStyle(fontSize: 40)),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "KAMPÜS DESTEK",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "E-posta Adresi",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Şifre",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("SİSTEME GİRİŞ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const KayitEkrani()));
                      },
                      child: const Text("Hesabın yok mu? Kayıt Ol",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold)),
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

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _departmentController = TextEditingController();
  final _roleController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    try {
      await apiService.post('/api/auth/register', {//kayıt isteği atıyoruz.
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'department': _departmentController.text,
        'role': _roleController.text.toUpperCase(),
        'password': _passwordController.text,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Kayıt başarılı! Lütfen giriş yapın."),
            backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Kayıt başarısız: ${e.toString().replaceAll("Exception: ", "")}')));//exception contrroler dönüşü
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white)),
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
            padding:
            const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    const Text("YENİ KAYIT",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1565C0))),
                    const SizedBox(height: 25),
                    _kayitFormAlani(
                        "Ad Soyad", Icons.person_outline, _fullNameController),
                    _kayitFormAlani(
                        "E-posta", Icons.email_outlined, _emailController),
                    _kayitFormAlani("Bölüm", Icons.school_outlined,
                        _departmentController),
                    _kayitFormAlani("Rol (STUDENT/STAFF)",
                        Icons.admin_panel_settings_outlined, _roleController),
                    _kayitFormAlani("Şifre", Icons.lock_outline,
                        _passwordController,
                        sifreMi: true),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isLoading ? null : _register,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("KAYDI TAMAMLA",
                          style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _kayitFormAlani(
      String label, IconData icon, TextEditingController controller,
      {bool sifreMi = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
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

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  late Future<List<dynamic>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    _reportsFuture = _fetchReports();
  }

  Future<List<dynamic>> _fetchReports() async {
    try {
      return await apiService.get('/api/reports');//reporta isteği atıyoruz.
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Raporlar yüklenemedi: $e")));
      }
      return [];
    }
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('d MMMM yyyy, HH:mm', 'tr').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category.toUpperCase()) {
      case 'GÜVENLİK':
        return Colors.orange;
      case 'ALTYAPI':
        return Colors.brown;
      case 'TEMİZLİK':
        return Colors.cyan;
      case 'AYDINLATMA':
        return Colors.yellow.shade700;
      case 'BİLİŞİM':
        return Colors.indigo;
      case 'ULAŞIM':
        return Colors.purple;
      case 'YEMEKHANE':
        return Colors.lime;
      case 'AKADEMİK':
        return Colors.teal;
      case 'DİĞER':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
          title: const Text("Kampüs Bildirim Akışı",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {
          _reportsFuture = _fetchReports();
        }),
        child: FutureBuilder<List<dynamic>>(
          future: _reportsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Center(child: Text("Gösterilecek rapor bulunamadı."));//veritabanında rapor yoksa buraya giriyor.
            }

            final raporListesi = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: raporListesi.length,
              itemBuilder: (context, index) {
                final veri = raporListesi[index];
                final renk = _getColorForCategory(veri['category'] ?? '');
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: renk.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text(veri["category"]?[0] ?? '?',
                              style: TextStyle(
                                  color: renk,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20))),
                    ),
                    title: Text(veri["title"],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "${veri["location"]}\n${_formatDate(veri["createdAt"])}"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetayEkrani(bildirimId: veri['id']))).then((_) {
                        setState(() {
                          _reportsFuture = _fetchReports();
                        });
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const YeniRaporEkrani())).then((raporOlusturuldu) {
            if (raporOlusturuldu == true) {
              setState(() {
                _reportsFuture = _fetchReports();
              });
            }
          });
        },
        tooltip: 'Yeni Rapor Oluştur',
        elevation: 2.0,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBottomAppBarItem(
                icon: Icons.list_alt_rounded, text: "Raporlar", onPressed: () {}),
            _buildBottomAppBarItem(
                icon: Icons.map_outlined,
                text: "Harita",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HaritaEkrani()));
                }),
            const SizedBox(width: 48),
            _buildBottomAppBarItem(
                icon: Icons.person_outline,
                text: "Profil",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilEkrani()));
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAppBarItem(
      {required IconData icon,
        required String text,
        required VoidCallback onPressed}) {
    final color = (text == "Raporlar")
        ? Theme.of(context).colorScheme.primary
        : Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: Icon(icon, color: color), onPressed: onPressed, tooltip: text),
      ],
    );
  }
}

class YeniRaporEkrani extends StatefulWidget {
  const YeniRaporEkrani({super.key});

  @override
  State<YeniRaporEkrani> createState() => _YeniRaporEkraniState();
}

class _YeniRaporEkraniState extends State<YeniRaporEkrani> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedCategory;
  bool _isLoading = false;

  final List<String> _categories = [
    'Güvenlik',
    'Altyapı',
    'Temizlik',
    'Aydınlatma',
    'Bilişim',
    'Ulaşım',
    'Yemekhane',
    'Akademik',
    'Diğer'
  ];

  Future<void> _submitReport() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen tüm alanları doldurun.")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await apiService.post('/api/reports', {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'category': _selectedCategory,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Rapor başarıyla gönderildi!"),
            backgroundColor: Colors.green));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Rapor gönderilemedi: ${e.toString().replaceAll("Exception: ", "")}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yeni Rapor Oluştur")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  labelText: "Başlık", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  labelText: "Açıklama", border: OutlineInputBorder()),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                  labelText: "Konum (Örn: Mühendislik Fak. B Blok)",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text("Kategori Seçin"),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                    value: category, child: Text(category));
              }).toList(),
              onChanged: (newValue) {
                setState(() => _selectedCategory = newValue);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitReport,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("GÖNDER"),
            ),
          ],
        ),
      ),
    );
  }
}

class DetayEkrani extends StatefulWidget {
  final int bildirimId;
  const DetayEkrani({super.key, required this.bildirimId});
  @override
  State<DetayEkrani> createState() => _DetayEkraniState();
}

class _DetayEkraniState extends State<DetayEkrani> {
  late Future<Map<String, dynamic>> _reportFuture;

  @override
  void initState() {
    super.initState();
    _reportFuture = _fetchReportDetails();
  }

  Future<Map<String, dynamic>> _fetchReportDetails() async {
    final response = await apiService.get('/api/reports/${widget.bildirimId}');//detay isteği atıyoruz. rapor oluşup veri tabanına işleniyor
    return response as Map<String, dynamic>;
  }

  Future<void> _updateStatus(String newStatus) async {
    try {
      await apiService.put(
          '/api/reports/${widget.bildirimId}/status', {'status': newStatus.toUpperCase()});// oluşturulan raporların durum güncellemesi
      if (mounted) {                                                                       // yalnızca admin permine sahip kişiler yapabiliyor.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Durum güncellendi!"),
            backgroundColor: Colors.green));
        setState(() {
          _reportFuture = _fetchReportDetails();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Güncelleme başarısız: $e")));
      }
    }
  }

  Color _getColorForCategory(String category) {
    switch (category.toUpperCase()) {
      case 'GÜVENLİK':
        return Colors.orange;
      case 'ALTYAPI':
        return Colors.brown;
      case 'TEMİZLİK':
        return Colors.cyan;
      case 'AYDINLATMA':
        return Colors.yellow.shade700;
      case 'BİLİŞİM':
        return Colors.indigo;
      case 'ULAŞIM':
        return Colors.purple;
      case 'YEMEKHANE':
        return Colors.lime;
      case 'AKADEMİK':
        return Colors.teal;
      case 'DİĞER':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rapor Detayları")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Rapor detayı yüklenemedi."));
          }

          final bildirim = snapshot.data!;
          final renk = _getColorForCategory(bildirim['category'] ?? '');

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: renk.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                      child: Icon(Icons.image_outlined,
                          size: 50, color: Colors.grey)),
                ),
                const SizedBox(height: 20),
                Text(bildirim["title"],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(bildirim["description"] ?? "Açıklama bulunmuyor.",
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey.shade700)),
                const Divider(height: 40),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionChip(
                          label: const Text("İncelemeye Al"),
                          onPressed: () => _updateStatus('IN_PROGRESS')),
                      ActionChip(
                          label: const Text("Çözüldü"),
                          onPressed: () => _updateStatus('RESOLVED')),
                    ]),
                const Spacer(),
                Center(
                    child: Text("GÜNCEL DURUM: ${bildirim['status']}",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: renk))),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HaritaEkrani extends StatefulWidget {
  const HaritaEkrani({super.key});
  @override
  State<HaritaEkrani> createState() => _HaritaEkraniState();
}

class _HaritaEkraniState extends State<HaritaEkrani> {
  static const LatLng _atauniMuhendislik = LatLng(39.9082, 41.2435);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Atauni Kampüs Haritası")),
      body: GoogleMap(
          initialCameraPosition:
          const CameraPosition(target: _atauniMuhendislik, zoom: 16.0)),
    );
  }
}

class ProfilEkrani extends StatefulWidget {
  const ProfilEkrani({super.key});

  @override
  State<ProfilEkrani> createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  late Future<Map<String, dynamic>> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserProfile();
  }

  Future<Map<String, dynamic>> _fetchUserProfile() async {
    final response = await apiService.get('/api/users/me');//profil isteği atıyoruz.
    return response as Map<String, dynamic>;
  }

  void _logout() {
    apiService.setAuthToken(null);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const GirisEkrani()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profilim")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Profil bilgileri yüklenemedi."));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                const SizedBox(height: 20),
                Text(user['fullName'] ?? 'İsim Yok',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text(user['email'] ?? 'E-posta Yok',
                    style:
                    TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                const Divider(height: 40),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.school),
                    title: const Text('Bölüm'),
                    subtitle: Text(user['department'] ?? 'Belirtilmemiş'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text('Rol'),
                    subtitle: Text(user['role'] ?? 'Belirtilmemiş'),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Oturumu Kapat"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
