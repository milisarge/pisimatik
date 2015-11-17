# pisimatik
pisilinux iso türetme ve kurulum aracı

gerekliler

squashfs-toolsn
cdrkit
syslinux-utils
python-lxml

genel kullanım:

./pisimatik.sh  repo-dosyası  kurulacaklar-dosyası

ör: "./pisimatik.sh repo2 min_live"

ör: "./pisimatik.sh repo1 xfce4_live"


önemli not:
pisimatik.sh ı root kullanıcısıyla çalıştırın.pisimatik içindeki komutların root la çalıştığından emin olunuz.

elinizde reponun paketleri varsa pisimatik dizininde paket dizini oluşturun,içine atın veya pisilinux kullanıyorsanız pisi paket depolama dizinini kısayol gösterin. 
Her sefer internetten indirmesine gerek kalmaz. 

test aşamasındadır,hataları lütfen bildiriniz.
