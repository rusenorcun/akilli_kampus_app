Proje yapısı Frontend ve Backend olarak ikiye ayırıldı.

Backend Yapısı Spring Boot (Maven) ile çalışmakta ve local bir sunucu oluşturmaktadır. Bu sunucu GET, PUT ve POST methotları ile HTTP protokolü ile UI tarafı olan Flutter ile haberlerşmektedir. Yapılan haberlerşme sonucu MSSQL tarafından oluşturulan veritabanına gerekli verileri çekmekte ver gerekeli verileri yazdırmaktadır.

Frontend Tarafında ise Dart tabanlı flutter dili kullanılmıştır. Gerekli SDK seviyeleri Frontend yapısı içerisinde belirtilmiştir. 

Backendin çalışması için Spring Boot ve JDK21  kurulu olması yeterlidir. Frontend için ise flutter doctor komutu sorunsuz çalışmalı ve sürümm uyuşmazlığına dikkat edilmelidir.

Hazırlayanlar: 

Backend: 
Ruşen Orçun Koçer
220707065

Frontend:
Çağla Candan
210707040