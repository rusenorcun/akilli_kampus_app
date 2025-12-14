# Mobil Programlama Projesi -- Akıllı Kampüs Sağlık ve Güvenlik Bildirim Uygulaması
Cemre Balcı, Çağla Candan, Ruşen Orçun Koçer tarafından geliştirilen Atatürk Üniversitesi Mobil Programlama dersi dönem Projesi. (Eğitmen: Ferhat Bozkurt)

# Proje Tanımı 
Bu proje, kampüs içinde ortaya çıkan sağlık, güvenlik, çevre, kayıp-buluntu ve teknik 
arıza gibi olayların kullanıcılar tarafından mobil uygulama üzerinden hızlı biçimde 
raporlanmasını, harita üzerinde görüntülenmesini, durumlarının takip edilebilmesini ve 
yöneticiler tarafından güncellenmesini sağlayan bir sistemin geliştirilmesini amaçlar. 
Kullanıcılar basit bir arayüz aracılığıyla olayları bildirirken, Admin rolü bu bildirimleri yönetir, 
durum değişikliği yapar ve gerekli durumlarda acil duyurular yayınlayabilir. Uygulama, 
kampüs içinde güvenliği ve iletişimi artırmayı hedefleyen merkezi bir dijital bildirim platformu 
sunar. 

Roller 
Kullanıcı (User) 
• Olay bildirimi oluşturabilir. 
• Bildirimleri listeleyebilir, filtreleyebilir ve arayabilir. 
• Harita üzerinden bildirimleri konum bazlı inceleyebilir. 
• Bildirim detaylarını görüntüleyebilir. 
• Bildirimi takip edebilir veya takibi bırakabilir. 
• Bildirimin durum değişikliklerinde bildirim alır. 
• Profil ve bildirim ayarlarını yönetebilir. 
Yönetici (Admin) 
• Tüm kullanıcı bildirilerini görüntüler. 
• Bildirim durumlarını günceller (Açık → İnceleniyor → Çözüldü). 
• Gerekirse bildirim açıklamasını düzenler. 
• Yanlış veya uygunsuz bildirimi sonlandırabilir. 
• Acil durum uyarısı yayınlayarak tüm kullanıcılara anında bildirim gönderebilir. 

1. Giriş ve Kayıt Ekranı (15 Puan) 
Giriş Yap 
• E-posta ve şifre ile giriş yapılır. 
• Başarılı giriş sonrası kullanıcı rolü (User/Admin) otomatik atanır. 
• Hatalı girişlerde uygun hata mesajı görüntülenir. 
Kayıt Ol 
• Ad-soyad, e-posta, şifre ve birim bilgileri alınır. 
• Yeni kayıtların varsayılan rolü User’dır. 
Şifre Sıfırlama 
• E-postaya şifre sıfırlama bağlantısı gönderildiğini simüle eden bilgi ekranı bulunur. 

2. Ana Sayfa – Bildirim Akışı (20 Puan) 
Bildirim Listesi 
• Her bildirimin satırında tür ikonu, başlık, açıklama, oluşturulma zamanı ve durum 
(Açık/İnceleniyor/Çözüldü) bulunur. 
• Liste yukarıdan aşağıya kronolojik olarak sıralanabilir. 
Filtreleme 
• Tür bazlı filtreleme 
• Açık olanlar 
• Takip edilenler 
• (Admin için) kendi yetki alanına ait bildirimler 
Arama 
• Başlık ve açıklama içinde anahtar kelime araması yapılabilir. 

3. Harita Ekranı (20 Puan) 
Harita Üzerinde Pinler 
• Bildirimler türlerine göre farklı renk veya ikonlarla işaretlenir. 
• Kullanıcı harita üzerinde yakınlaştırma/uzaklaştırma yapabilir. 
Pin Bilgi Kartı 
• Pin tıklanınca tür, başlık ve bildirimin ne kadar önce oluşturulduğu bilgilerini içeren 
küçük kart görünür. 
• Kart üzerindeki “Detayı Gör” butonu bildirim detay ekranına yönlendirir. 

4. Bildirim Detay Ekranı (15 Puan) 
Bilgi Alanları 
• Başlık, tür, açıklama, oluşturulma zamanı, konum (mini harita bileşeni) ve isteğe bağlı 
fotoğraflar bulunur. 
Durum Yönetimi 
• User yalnızca görüntüleme yapabilir. 
• Admin bu ekrandan durumu güncelleyebilir: 
• Açık → İnceleniyor → Çözüldü 
Takip Et / Takipten Çık 
• User bildirimi takip listesine ekleyebilir. Takibi bıraktığında listeden çıkar. 

5. Yeni Bildirim Oluştur Ekranı (15 Puan) 
Form Alanları 
• Tür seçimi 
• Başlık 
• Açıklama 
• Konum seçimi (cihaz konumu veya harita üzerinden işaretleme) 
• Fotoğraf ekleme (opsiyonel) 
Gönderim 
• Form doğrulaması yapılır. 
• Bildirim başarıyla oluşturulduğunda kullanıcıya bilgilendirme mesajı gösterilir. 

6. Admin Paneli Ekranı (10 Puan) 
Bildirim Yönetimi 
• Admin tüm bildirimleri tek ekranda listeleyebilir. 
• Her bildirimin türü, başlığı, açıklaması, konumu ve kullanıcı bilgileri görüntülenir. 
Durum Güncelleme 
• Admin gerekli gördüğü bildirimin durumunu anlık olarak değiştirebilir: 
• Açık → İnceleniyor → Çözüldü 
Acil Durum Bildirimi Yayınlama 
• Admin özel bir modül üzerinden tüm kullanıcılara gidecek acil durum duyuruları 
yayınlayabilir. 

7. Profil ve Ayarlar Ekranı (5 Puan) 
Profil Bilgileri 
• Ad-soyad, e-posta, kullanıcı rolü ve birim bilgileri gösterilir. 
Bildirim Ayarları 
• Kullanıcı hangi tür bildirimleri almak istediğini seçebilir. 
Takip Edilen Bildirimler 
• User’ın takip ettiği tüm bildirimler listelenir. 
Çıkış Yap 
• Uygulamadan çıkışı sağlar. 

8. Bildirim ve Hatırlatma Sistemi (10 Puan) 
Durum Güncellemeleri 
• User takip ettiği bir bildirimin durumu değiştiğinde bildirim alır. 
Acil Bildirimler 
• Admin tarafından yayınlanan acil bildirimler tüm kullanıcılara gönderilir. 
Proje Teslimi 
• Projenin 2-3 kişilik gruplar halinde yapılması zorunludur. Gruptaki her öğrenci 
projeye eşit katkı sağlamalıdır. 
• Tüm öğrenciler projeyi DBS üzerinden belirtilen teslim bölümüne yüklemek 
zorundadır. 
• DBS’ye yüklenmesi gereken dosyalar: 
o Proje dosyası (Zip) 
o Teknik rapor (PDF) 
▪ Proje özeti 
▪ Ekran listesi ve ekran görüntüleri 
▪ Kullanılan teknolojiler 
Git Kullanımı  
• Git kullanımı zorunludur. 
• Git deposunda: 
o Düzenli commit geçmişi 
o Gelişim sürecini gösteren adım adım ilerleme 
bulunmalıdır. 
Yapay Zeka Kullanımı 
• Yapay zeka ile doğrudan kod üretmek yasaktır. Ekran, fonksiyon, sınıf, bileşen vb. 
komple kod bölümleri yapay zekadan alınamaz. 
• Yapay zekadan alınan kodu anlamadan projeye eklemek yasaktır. Sunum sırasında 
öğrenci eklediği tüm kodu açıklayabilmelidir. 
• Yapay zeka yalnızca danışma amaçlı kullanılabilir. Hata açıklaması, kavram öğrenme, 
fikir alma gibi kod üretmeyen destekler serbesttir. 
• Git geçmişi düzenli olmalı ve gelişim süreci görünür olmalıdır. Tek seferde yüklenmiş 
büyük kod blokları şüpheli kabul edilir. Gerekirse sunum sırasında küçük bir bölümü 
yeniden yazdırılabilir. 
• Yapay zeka kullanım ihlali tespit edilirse ilgili bölüm değerlendirmeye alınmaz. 
Gerekirse proje tamamen geçersiz sayılabilir.