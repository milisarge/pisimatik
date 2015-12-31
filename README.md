# pisimatik
pisilinux iso türetme ve kurulum aracı.

Pisimatik Mekanizma 

1-Sıfırdan kaynak kodlar kullanılarak temel sistem oluşturma.

2-Hazır derlenmiş paketleri kullanarak sistem oluşturma.

3-Belli bir ayar dosyasını kullanarak veya kurulu sistemi kullanarak iso türetme.

4-Kurulan ve çalışan iso türetme.

5-Hedef diske hızlı sistem kurulumu

gerekliler

squashfs-toolsn
cdrkit
syslinux-utils
python-lxml

genel kullanım:

./pisimatik.sh  repo-dosyası  kurulacaklar-dosyası

ör: "./pisimatik.sh repo2 min_live"  masaüstüsüz minimal bir ortam oluşur.

ör: "./pisimatik.sh repo1 xfce4_live_min"  hafif bir xfce4 ortamı oluşmaktadır.


önemli not:
pisimatik.sh ı root kullanıcısıyla çalıştırın.pisimatik içindeki komutların root la çalıştığından emin olunuz.

elinizde reponun paketleri varsa pisimatik dizininde paket dizini oluşturun,içine atın veya pisilinux kullanıyorsanız pisi paket depolama dizinini kısayol gösterin. 
Her sefer internetten indirmesine gerek kalmaz. 

qemuda test etmek için qemu-system-x86_64  veya qemu-kvm ile live isoyu çalıştırın.

qemuda fare gözükmemesi durumunda qemuyu --show-cursor parametresiyle çalıştırın

test aşamasındadır,hataları lütfen bildiriniz.
