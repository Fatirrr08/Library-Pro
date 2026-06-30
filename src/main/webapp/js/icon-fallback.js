/* =====================================================
   icon-fallback.js — FontAwesome load detection + fallback
   Replaces <i> content with Unicode when FA fails
   ===================================================== */

(function () {
    var FALLBACK_DELAY = 3000; // 3s grace period for CDN

    var fallbackMap = {
        'fa-book-open-reader': '\uF5DA',
        'fa-user-plus': '\uF234',
        'fa-circle-exclamation': '\uF06A',
        'fa-circle-check': '\uF058',
        'fa-arrow-right': '\uF061',
        'fa-arrow-right-to-bracket': '\uF090',
        'fa-user': '\uF007',
        'fa-lock': '\uF023',
        'fa-id-card': '\uF2C2',
        'fa-envelope': '\uF0E0',
        'fa-location-dot': '\uF3C5',
        'fa-location-crosshairs': '\uF601',
        'fa-moon': '\uF186',
        'fa-sun': '\uF185',
        'fa-magnifying-glass': '\uF002',
        'fa-book': '\uF02D',
        'fa-chart-line': '\uF201',
        'fa-layer-group': '\uF5FD',
        'fa-users': '\uF0C0',
        'fa-arrow-right-arrow-left': '\uF0EC',
        'fa-comments': '\uF086',
        'fa-star': '\uF005',
        'fa-heart': '\uF004',
        'fa-clock-rotate-left': '\uF1DA',
        'fa-bars': '\uF0C9',
        'fa-chevron-down': '\uF078',
        'fa-right-from-bracket': '\uF2F5',
        'fa-user-gear': '\uF4FE',
        'fa-triangle-exclamation': '\uF071',
        'fa-book-open': '\uF518',
        'fa-book-reader': '\uF5DA',
        'fa-feather': '\uF52D',
        'fa-building': '\uF1AD',
        'fa-calendar': '\uF133',
        'fa-calendar-days': '\uF073',
        'fa-barcode': '\uF02A',
        'fa-align-left': '\uF036',
        'fa-pen-to-square': '\uF044',
        'fa-trash': '\uF1F8',
        'fa-trash-can': '\uF2ED',
        'fa-floppy-disk': '\uF0C7',
        'fa-ban': '\uF05E',
        'fa-bell': '\uF0F3',
        'fa-hourglass-half': '\uF252',
        'fa-hourglass-start': '\uF251',
        'fa-clipboard-check': '\uF46C',
        'fa-circle-user': '\uF2BD',
        'fa-circle-xmark': '\uF057',
        'fa-paper-plane': '\uF1D8',
        'fa-money-bill-wave': '\uF53A',
        'fa-rotate-right': '\uF2F9',
        'fa-camera': '\uF030',
        'fa-crop': '\uF125',
        'fa-folder-minus': '\uF65D',
        'fa-user-edit': '\uF4FF',
        'fa-arrow-left': '\uF060',
        'fa-arrow-left-long': '\uF177',
        'fa-list': '\uF03A',
        'fa-box': '\uF466',
        'fa-check': '\uF00C'
    };

    function isFALoaded() {
        if (typeof window.FontAwesome === 'object' && window.FontAwesome.config) {
            return true;
        }
        var test = document.createElement('i');
        test.className = 'fa-solid fa-user';
        test.style.cssText = 'position:absolute;visibility:hidden;font-size:0';
        document.body.appendChild(test);
        var loaded = window.getComputedStyle(test).fontFamily !== '';
        document.body.removeChild(test);
        return loaded;
    }

    function applyFallback() {
        var icons = document.querySelectorAll('i[class*="fa-"]');
        icons.forEach(function (el) {
            var classes = el.className.split(/\s+/);
            for (var i = 0; i < classes.length; i++) {
                var cls = classes[i];
                if (cls.startsWith('fa-') && cls !== 'fa-solid' && cls !== 'fa-regular' && cls !== 'fa-brands') {
                    var unicode = fallbackMap[cls];
                    if (unicode) {
                        el.className = 'fa-fallback';
                        el.setAttribute('data-fa-icon', cls);
                        el.textContent = unicode;
                    }
                    break;
                }
            }
        });
    }

    function checkAndFallback() {
        if (!isFALoaded()) {
            applyFallback();
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () {
            setTimeout(checkAndFallback, FALLBACK_DELAY);
        });
    } else {
        setTimeout(checkAndFallback, FALLBACK_DELAY);
    }
})();
