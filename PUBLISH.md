# Flutter Paketini `pub.dev` Üzerinde Yayınlama Rehberi

Bu doküman, `atomic_flutter` paketini `pub.dev` platformunda nasıl yayınlayacağınızı ve genel kullanıma açacağınızı adım adım açıklar.

## 1. Yayınlama Öncesi Kontrol Listesi

Paketinizi yayınlamadan önce aşağıdaki adımların eksiksiz olduğundan emin olun. Bu adımlar, `pub.dev`'in paket kabul standartları için gereklidir.

### a. `pubspec.yaml` Dosyasını Gözden Geçirin

Bu dosya, paketinizin kimliğidir. Aşağıdaki alanların doğru ve eksiksiz doldurulduğundan emin olun:

- `name`: `atomic_flutter` (Paketinizin adı).
- `version`: Paketinizin versiyon numarası (örn: `1.0.0`). Her yeni yayınlamada bu versiyonu **mutlaka** artırmanız gerekir (Semantik Versiyonlama'ya uyun: `MAJOR.MINOR.PATCH`).
- `description`: Paketin ne yaptığını açıklayan net ve anlamlı bir metin.
- `homepage`: (Opsiyonel ama önerilir) Paketinizin ana sayfası, genellikle bir GitHub deposu linki.
- `repository`: (Opsiyonel ama önerilir) Paketinizin kaynak kodlarının bulunduğu Git deposu linki.
- `issue_tracker`: (Opsiyonel ama önerilir) Kullanıcıların hata bildirebileceği link.

**ÖNEMLİ:** `dependencies` veya `dev_dependencies` altında `path:` ile belirtilmiş yerel bir bağımlılık kalmadığından emin olun. Tüm bağımlılıklar `pub.dev` üzerinden çekilmelidir.

### b. `LICENSE` Dosyası

Her `pub.dev` paketinin bir lisansı olmalıdır. Projenizde `LICENSE` dosyası zaten mevcut. Bu, kullanıcıların paketinizi hangi koşullar altında kullanabileceğini belirtir. Genellikle `MIT`, `BSD`, `Apache` gibi standart lisanslar kullanılır.

### c. `README.md` Dosyası

Paketinizin `pub.dev` sayfasında görünecek olan ana dokümandır. Paketinizin ne işe yaradığını, nasıl kurulduğunu ve temel kullanım örneklerini içermelidir. İyi bir `README`, kullanıcıların paketinizi benimsemesi için kritiktir.

### d. `CHANGELOG.md` Dosyası

Bu dosya, paket versiyonları arasındaki değişiklikleri listeler. `pub.dev` için zorunludur. Her yeni versiyon için bir bölüm eklemelisiniz.

Örnek format:

```markdown
## 1.0.1
- Hata düzeltmesi: Butonlardaki gölge sorunu giderildi.
- Yeni özellik: `AtomicCard` widget'ına `onTap` eklendi.

## 1.0.0
- İlk sürüm.
```

### e. Kod Analizi ve Testler

Paketinizde herhangi bir hata veya uyarı olmadığından emin olmak için aşağıdaki komutu çalıştırın:

```bash
flutter analyze
```

Eğer varsa, testlerinizi çalıştırarak her şeyin yolunda olduğunu kontrol edin:

```bash
flutter test
```

`analyze` komutundan gelen kritik hatalar, paketi yayınlamanızı engelleyecektir.

## 2. Yayınlama İşlemi

Yukarıdaki tüm adımlar tamamsa, paketinizi yayınlamaya hazırsınız.

### Adım 1: Test Yayını (Dry Run)

Bu komut, paketinizi gerçekten yayınlamadan tüm kontrolleri yapar ve olası hataları size bildirir. Bu, yayınlama öncesi son bir güvenlik kontrolüdür.

```bash
dart pub publish --dry-run
```

Eğer çıktıda "Package has 0 warnings." (veya benzeri başarılı bir mesaj) görüyorsanız, bir sonraki adıma geçebilirsiniz. Aksi takdirde, belirtilen hataları veya uyarıları düzeltin.

### Adım 2: Gerçek Yayınlama

Artık paketinizi `pub.dev`'e gönderebilirsiniz. Aşağıdaki komutu çalıştırın:

```bash
dart pub publish
```

Bu komutu çalıştırdığınızda:
1.  Terminal, size paketi yayınlamak istediğinizden emin olup olmadığınızı soracaktır (`y/n`).
2.  `y` ile onayladıktan sonra, tarayıcınızda bir Google ile giriş yapma sayfası açılacaktır. `pub.dev`, yayıncıları Google hesapları üzerinden doğrular.
3.  Giriş yaptıktan sonra, `pub.dev` size gerekli izinleri vermenizi isteyecektir. Onaylayın.
4.  Bu adımdan sonra terminaldeki yayınlama işlemi devam edecek ve paketiniz `pub.dev`'e yüklenecektir.

**DİKKAT:** Bir paketin belirli bir versiyonu bir kez yayınlandıktan sonra **geri alınamaz** veya **üzerine yazılamaz**. Bir hata yaparsanız, versiyon numarasını artırarak yeni bir sürüm yayınlamanız gerekir.

## 3. Yayınlama Sonrası

### a. `pub.dev`'de Kontrol Edin

Birkaç dakika içinde paketiniz `pub.dev/packages/atomic_flutter` adresinde görünür olacaktır. Sayfayı kontrol ederek her şeyin doğru göründüğünden emin olun.

### b. Projelerde Kullanım

Artık paketinizi yerel `path` kullanmadan, herhangi bir Flutter projesine ekleyebilirsiniz. Projenizin `pubspec.yaml` dosyasına gidin ve `dependencies` altına aşağıdaki gibi ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  atomic_flutter: ^1.0.0 # Yayınladığınız versiyon numarasını yazın
```

Ardından projenizin terminalinde `flutter pub get` komutunu çalıştırın ve paketinizi `import` ederek kullanmaya başlayın:

```dart
import 'package:atomic_flutter/atomic_flutter.dart';
```

### c. Git Sürüm Etiketleme (Önerilir)

Yayınladığınız her sürüm için Git'te bir etiket (tag) oluşturmak iyi bir pratiktir. Bu, kod tabanınızdaki hangi noktanın hangi `pub.dev` sürümüne karşılık geldiğini takip etmeyi kolaylaştırır.

```bash
# Önce son değişiklikleri commit'lediğinizden emin olun
git tag v1.0.0
git push origin v1.0.0
```
