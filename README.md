# CMS Tespit Aracı

# Projenin Amacı
Bu proje, web sitelerinin hangi içerik yönetim sistemi (CMS) üzerinde çalıştığını otomatik olarak tespit eden bir araçtır. Kullanıcıdan alınan bir .txt dosyası içerisindeki linkleri tarayarak, sitelerin WordPress, Joomla, Drupal, OpenCart, PrestaShop, ve WooCommerce kullanıp kullanmadığını analiz eder. Tespit edilen sonuçlar terminalde renkli ve emojili bir şekilde gösterilir ve ayrıca cms_sonuclari.txt dosyasına kaydedilir.

# Çalışma Mantığı
Kullanıcıdan .txt dosyası girişi: Program, içerisinde sitelerin linklerinin bulunduğu bir .txt dosyasını kullanıcıdan ister.
Her bir siteyi kontrol etme: Her bir link için HTTP isteği yaparak sitenin kaynak kodu taranır ve belirli CMS işaretleri aranır (örneğin, "wp-content" WordPress'e işaret eder).
Sonuçları kaydetme: Tespit edilen CMS'ler, aynı dizinde cms_sonuclari.txt dosyasına kaydedilir.

# Kullanılan Kütüphaneler
Bu proje Ruby dilinde yazılmıştır ve aşağıdaki yerleşik Ruby kütüphanelerini kullanır:

- **net/http**: HTTP ve HTTPS istekleri göndermek ve sitelerin kaynak kodlarını almak için kullanılır.
- **uri**: URL'leri doğru bir şekilde çözümlemek ve analiz etmek için kullanılır.
- **openssl**: HTTPS bağlantıları için SSL sertifika doğrulamalarını yönetmek amacıyla kullanılır. Bu projede, doğrulama kapalıdır.

## net/http
Bu kütüphane, HTTP/HTTPS istekleri yapmamıza olanak tanır. CMS tespiti için her siteye yapılan isteklerde, `Net::HTTP.get_response` veya `Net::HTTP.start` kullanılarak kaynak kodu alınır ve bu kaynak kodu üzerinden CMS tespiti yapılır.

## uri
`URI.parse` kullanılarak verilen her link doğru formatta çözülür ve isteği yapabilmek için kullanılır.

## openssl
HTTPS bağlantılarında SSL sertifikalarını doğrulamak için kullanılır. Ancak bazı sitelerde SSL hatalarını atlamak amacıyla `OpenSSL::SSL::VERIFY_NONE` ile doğrulama işlemi devre dışı bırakılmıştır.
