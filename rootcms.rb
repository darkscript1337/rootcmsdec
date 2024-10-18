require 'net/http'
require 'uri'
require 'openssl'

def ascii_yazdir
  puts %q{
 ____             _                  _       _   _ _______________ 
 |  _ \  __ _ _ __| | _____  ___ _ __(_)_ __ | |_/ |___ /___ /___  |
 | | | |/ _` | '__| |/ / __|/ __| '__| | '_ \| __| | |_ \ |_ \  / / 
 | |_| | (_| | |  |   <\__ \ (__| |  | | |_) | |_| |___) |__) |/ /  
 |____/ \__,_|_|  |_|\_\___/\___|_|  |_| .__/ \__|_|____/____//_/   
                                       |_|                          
  }
  puts "\033[92mCoder By: RootAyyildiz Turkish Hacktivist\033[0m\n"
end

# Renk ve emoji için
def renkli_yaz(metin, renk)
  case renk
  when "yesil" then "\e[32m#{metin}\e[0m"
  when "kirmizi" then "\e[31m#{metin}\e[0m"
  when "mavi" then "\e[34m#{metin}\e[0m"
  when "sari" then "\e[33m#{metin}\e[0m"
  else metin
  end
end

def güvenli_istek(uri, tekrar_sayisi=3)
  begin
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
      request = Net::HTTP::Get.new(uri)
      response = http.request(request)
      return response
    end
  rescue => e
    if tekrar_sayisi > 0
      puts renkli_yaz("Bağlantı hatası, tekrar dene: #{uri} (#{tekrar_sayisi} kaldı)", "sari")
      güvenli_istek(uri, tekrar_sayisi - 1)
    else
      puts renkli_yaz("Bağlantı hatası: #{e.message}, işlem başarısız", "kirmizi")
      return nil
    end
  end
end

def cms_tespit(url)
  uri = URI.parse(url)
  response = güvenli_istek(uri)

  if response.nil?
    return "Bağlantı başarısız", "⚪"
  end

  if response.body.include?("wp-content")
    return "WordPress", "🟢"
  elsif response.body.include?("Joomla!")
    return "Joomla", "🔵"
  elsif response.body.include?("sites/default")
    return "Drupal", "🟡"
  elsif response.body.include?("catalog/view/theme")
    return "OpenCart", "🔴"
  elsif response.body.include?("prestashop")
    return "PrestaShop", "🟠"
  elsif response.body.include?("woocommerce")
    return "WooCommerce", "🟣"
  else
    return "CMS tespit edilemedi", "⚪"
  end
end

def cms_ayirici(dosya_yolu)
  basarili_sonuc = []

  linkler = File.readlines(dosya_yolu).map(&:chomp)

  linkler.each do |link|
    puts renkli_yaz("Kontrol ediliyor: #{link}...", "mavi")
    cms, emoji = cms_tespit(link)
    if cms != "CMS tespit edilemedi" && cms != "Bağlantı başarısız"
      basarili_sonuc << "#{link} - #{cms}"
      puts renkli_yaz("#{emoji} #{link} - #{cms} tespit edildi!", "yesil")
    else
      puts renkli_yaz("#{emoji} #{link} - #{cms}.", "kirmizi")
    end
  end

  if basarili_sonuc.any?
    File.open("cms_sonuclari.txt", "w") do |file|
      basarili_sonuc.each { |sonuc| file.puts(sonuc) }
    end
    puts renkli_yaz("Sonuçlar 'cms_sonuclari.txt' dosyasına kaydedildi.", "sari")
  else
    puts renkli_yaz("Herhangi bir CMS tespit edilemedi.", "kirmizi")
  end
end

ascii_yazdir
puts renkli_yaz("Lütfen linklerin bulunduğu .txt dosyasının yolunu girin:", "sari")
dosya_yolu = gets.chomp
cms_ayirici(dosya_yolu)
