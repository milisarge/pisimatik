# pisimatik
pisilinux2.0 iso türetme ve kurulum aracı

gerekliler

squashfs-toolsn
cdrkit
syslinux-utils
python-lxml

genel kullanım:

./pisimatik.sh repo-ayar-dosyası

ör: "./pisimatik.sh repo2.0.ayar" komutuyla minimal bir pisi2.0 iso imakı oluşur.


önemli not:
pisimatik.sh ı root kullanıcısıyla çalıştırın.pisimatik içindeki komutların root la çalıştığından emin olunuz.

elinizde reponun paketleri varsa pisimatik dizininde paket dizini oluşturun,içine atın veya pisi 2.0 kullanıyorsanız pisi paket depolama dizinini kısayol gösterin. 
Her sefer internetten indirmesine gerek kalmaz. 
