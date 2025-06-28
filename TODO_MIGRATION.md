# 🚀 Atomic Flutter Migration Plan

Bu dosya `/atomic` dizininden `atomic_flutter` paketine taşınacak tüm komponentlerin migration planını içerir.

## 📊 Migration İstatistikleri

- **Toplam Dosya**: 58 dosya
- **Geçirilmiş**: 30 dosya ✅ 
- **Kalan**: 28 dosya 🚧
- **Tamamlanma**: %52

---

## 🎯 Phase 1: Critical Atomic Components (Öncelik: YÜKSEK)

### 🧱 Atoms - Container Components

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/atomic/component/box/animated_container.dart` | `atomic_flutter/lib/atoms/containers/atomic_animated_container.dart` | ✅ DONE | Animasyonlu container komponenti |
| `atomic/lib/src/atomic/component/box/icon_box.dart` | `atomic_flutter/lib/atoms/containers/atomic_icon_box.dart` | ✅ DONE | Icon box komponenti |
| `atomic/lib/src/atomic/component/box/svg_provider.dart` | `atomic_flutter/lib/utils/svg_provider.dart` | ✅ DONE | SVG provider utility |

### 🧱 Atoms - Markable Components

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/atomic/component/markable/button_check.dart` | `atomic_flutter/lib/atoms/inputs/atomic_button_check.dart` | ✅ DONE | Button checkbox komponenti |

### 🧱 Atoms - Feedback Components

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/atomic/component/shimmer/dot_loading.dart` | `atomic_flutter/lib/atoms/feedback/atomic_dot_loading.dart` | ✅ DONE | Dot loading animasyonu |

### 🧩 Molecules - Layout Components

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/atomic/partials/custom_sheet_body.dart` | `atomic_flutter/lib/molecules/sheets/atomic_custom_sheet_body.dart` | ✅ DONE | Custom sheet body |
| `atomic/lib/src/atomic/partials/sheet_builder.dart` | `atomic_flutter/lib/molecules/sheets/atomic_sheet_builder.dart` | ✅ DONE | Sheet builder utility |
| `atomic/lib/src/atomic/partials/stacked_body.dart` | `atomic_flutter/lib/molecules/layouts/atomic_stacked_body.dart` | ✅ DONE | Stacked body layout |

---

## 🔧 Phase 2: Utilities & Extensions (Öncelik: ORTA)

### 🛠️ Utilities

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/extensions/debouncer.dart` | `atomic_flutter/lib/utilities/atomic_debouncer.dart` | ✅ DONE | Debouncer utility (mevcut) |
| `atomic/lib/src/extensions/bool_api_extension.dart` | `atomic_flutter/lib/utils/extensions/bool_extension.dart` | ⏳ TODO | Bool API extension |
| `atomic/lib/src/extensions/clone_extension.dart` | `atomic_flutter/lib/utils/extensions/clone_extension.dart` | ⏳ TODO | Clone extension |
| `atomic/lib/src/extensions/contains_map_extension.dart` | `atomic_flutter/lib/utils/extensions/map_extension.dart` | ⏳ TODO | Map contains extension |
| `atomic/lib/src/extensions/pluck_extension.dart` | `atomic_flutter/lib/utils/extensions/list_extension.dart` | ⏳ TODO | List pluck extension |

### 🎨 Design Tokens & Config

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/config/colors.dart` | `atomic_flutter/lib/tokens/colors/legacy_colors.dart` | ⏳ TODO | Legacy renk paleti (referans) |
| `atomic/lib/src/config/dimensions.dart` | `atomic_flutter/lib/tokens/spacing/legacy_spacing.dart` | ⏳ TODO | Legacy spacing (referans) |
| `atomic/lib/src/config/icons.dart` | `atomic_flutter/lib/tokens/icons/custom_icons.dart` | ⏳ TODO | Custom icon set |

---

## 🏗️ Phase 3: Data & Models (Öncelik: DÜŞÜK)

### 📊 Data Models

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/data/models/base/action_list_item.dart` | `atomic_flutter/lib/models/action_list_item.dart` | ✅ DONE | Action list model → AtomicActionListItem |
| `atomic/lib/src/data/models/base/bottom_bar_item.dart` | `atomic_flutter/lib/models/bottom_bar_item.dart` | ✅ DONE | Bottom bar model → AtomicBottomBarItem |
| `atomic/lib/src/data/models/base/icon_list_item.dart` | `atomic_flutter/lib/models/icon_list_item.dart` | ✅ DONE | Icon list model → AtomicIconListItemModel |
| `atomic/lib/src/data/models/base/select_list_item.dart` | `atomic_flutter/lib/models/select_list_item.dart` | ✅ DONE | Select list model → AtomicSelectListItem |
| `atomic/lib/src/data/models/base/text_list_item.dart` | `atomic_flutter/lib/models/text_list_item.dart` | ✅ DONE | Text list model → AtomicTextListItem |

### 🎮 Controllers

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/data/controllers/sheet_select_list_controller.dart` | `atomic_flutter/lib/providers/sheet_select_controller.dart` | ⏳ TODO | Sheet select controller |
| `atomic/lib/src/data/controllers/value_controller.dart` | `atomic_flutter/lib/providers/value_controller.dart` | ⏳ TODO | Value controller |

### 📝 Enums

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/data/enums/loading_enum.dart` | `atomic_flutter/lib/models/enums/loading_state.dart` | ⏳ TODO | Loading state enum |
| `atomic/lib/src/data/enums/status_enum.dart` | `atomic_flutter/lib/models/enums/component_status.dart` | ⏳ TODO | Component status enum |
| `atomic/lib/src/data/enums/gender_enum.dart` | `atomic_flutter/lib/models/enums/gender.dart` | ⏳ TODO | Gender enum |

---

## 🌐 Phase 4: Network & Services (Öncelik: DÜŞÜK)

### 🔗 Network Infrastructure

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/system/network/requester.dart` | `atomic_flutter/lib/services/network/atomic_requester.dart` | ⏳ TODO | HTTP requester |
| `atomic/lib/src/system/network/app_interceptor.dart` | `atomic_flutter/lib/services/network/atomic_interceptor.dart` | ⏳ TODO | Network interceptor |
| `atomic/lib/src/system/network/exceptions/base_exceptions.dart` | `atomic_flutter/lib/services/network/exceptions.dart` | ⏳ TODO | Network exceptions |
| `atomic/lib/src/system/network/endpoint.dart` | `atomic_flutter/lib/services/network/endpoint.dart` | ⏳ TODO | Endpoint model |

### 🛠️ Services

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/data/services/notification_service.dart` | `atomic_flutter/lib/services/atomic_notification_service.dart` | ⏳ TODO | Notification service |
| `atomic/lib/src/data/services/vibrate.dart` | `atomic_flutter/lib/services/atomic_haptic_service.dart` | ⏳ TODO | Haptic feedback service |
| `atomic/lib/src/helpers/notification_helper.dart` | `atomic_flutter/lib/services/helpers/notification_helper.dart` | ⏳ TODO | Notification helper |

### 💾 Storage

| Dosya | Hedef Lokasyon | Durum | Açıklama |
|-------|----------------|-------|----------|
| `atomic/lib/src/data/storage/storage.dart` | `atomic_flutter/lib/services/storage/atomic_storage.dart` | ⏳ TODO | Base storage |
| `atomic/lib/src/data/storage/app_storage.dart` | `atomic_flutter/lib/services/storage/app_storage.dart` | ⏳ TODO | App storage implementation |

---

## 🗂️ Migration Öncelikleri

### 🚨 Phase 1 - Acil (Bu Sprint) ✅ TAMAMLANDI!
- [x] `atomic_animated_container.dart` - Animasyonlu container ✅
- [x] `atomic_icon_box.dart` - Icon box komponenti ✅
- [x] `atomic_button_check.dart` - Button checkbox ✅
- [x] `atomic_dot_loading.dart` - Dot loading ✅
- [x] `atomic_custom_sheet_body.dart` - Custom sheet body ✅
- [x] `atomic_sheet_builder.dart` - Sheet builder utility ✅
- [x] `atomic_stacked_body.dart` - Stacked body layout ✅
- [x] `svg_provider.dart` - SVG provider utility ✅

### ⚡ Phase 2 - Yakın Gelecek (Gelecek Sprint)
- [ ] Modal komponentleri (custom_sheet, sheet_builder)
- [ ] Layout komponentleri (stacked_layout)
- [ ] Extension'lar ve utilities

### 📅 Phase 3 - Orta Vadeli (1-2 Sprint)
- [ ] Data models ve controller'lar
- [ ] Enum'lar ve type definitions

### 🔮 Phase 4 - Uzun Vadeli (Opsiyonel)
- [ ] Network infrastructure (package dışı bırakılabilir)
- [ ] Services (app-specific, package dışı kalmalı)

---

## 🚧 Migration Kuralları

### ✅ DO - Yapılacaklar
- Komponent isimlendirmesinde `Atomic` prefix kullan
- Material Design 3 standartlarına uygun hale getir  
- Theme system ile entegre et
- Accessibility özellikleri ekle
- Comprehensive test coverage ekle
- Documentation ve usage örnekleri yaz

### ❌ DON'T - Yapılmayacaklar
- App-specific business logic'i package'e ekleme
- Hard-coded API endpoints ekleme
- Platform-specific kod (Firebase, vb.) ekleme
- External service dependencies ekleme

---

## 📋 Migration Checklist (Her Component İçin)

### Pre-Migration
- [ ] Mevcut component'i analiz et
- [ ] Dependencies'leri belirle
- [ ] Target location'ı belirle
- [ ] Breaking changes'leri identifiy et

### During Migration  
- [ ] Atomic naming convention uygula
- [ ] Theme integration ekle
- [ ] Material Design 3 compliance sağla
- [ ] Error handling iyileştir
- [ ] Accessibility features ekle

### Post-Migration
- [ ] Unit test'ler yaz
- [ ] Widget test'ler ekle
- [ ] Documentation güncelne
- [ ] Usage örneği oluştur
- [ ] CHANGELOG.md güncelle
- [ ] Export barrel'a ekle

---

## 🎯 Başarı Kriterleri

- [ ] Tüm atomic component'ler atomic_flutter'da
- [ ] Zero breaking changes existing API
- [ ] %100 test coverage critical components
- [ ] Comprehensive documentation
- [ ] Real-world usage examples
- [ ] Performance optimization
- [ ] Bundle size optimization

---

**Son Güncelleme**: 2024-12-21  
**Sorumlu**: Atomic Flutter Team  
**Review**: Weekly Sprint Planning 