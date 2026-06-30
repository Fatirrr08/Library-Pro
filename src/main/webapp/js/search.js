/* =====================================================
   search.js — Fuzzy Search Library
   Levenshtein-based fuzzy matching with scoring
   ===================================================== */

var FuzzySearch = (function () {

    // ── Levenshtein Distance ──
    function levenshtein(a, b) {
        var an = a.length, bn = b.length;
        var matrix = [];
        for (var i = 0; i <= bn; i++) matrix[i] = [i];
        for (var j = 0; j <= an; j++) matrix[0][j] = j;
        for (i = 1; i <= bn; i++) {
            for (j = 1; j <= an; j++) {
                var cost = a[j - 1] === b[i - 1] ? 0 : 1;
                matrix[i][j] = Math.min(
                    matrix[i - 1][j] + 1,
                    matrix[i][j - 1] + 1,
                    matrix[i - 1][j - 1] + cost
                );
            }
        }
        return matrix[bn][an];
    }

    // ── Tokenize + normalize ──
    function tokenize(str) {
        return str.toLowerCase()
            .replace(/[^a-z0-9\s]/g, '')
            .split(/\s+/)
            .filter(Boolean);
    }

    // ── Score a single field against query tokens ──
    function scoreField(fieldValue, queryTokens) {
        fieldValue = fieldValue.toLowerCase();
        var totalScore = 0;
        for (var t = 0; t < queryTokens.length; t++) {
            var qt = queryTokens[t];
            // Exact match = best
            if (fieldValue === qt) { totalScore += 100; continue; }
            // Starts with
            if (fieldValue.indexOf(qt) === 0) { totalScore += 50; continue; }
            // Contains word
            if (fieldValue.indexOf(' ' + qt) !== -1 || fieldValue.indexOf(qt + ' ') !== -1) { totalScore += 30; continue; }
            // Contains substring
            if (fieldValue.indexOf(qt) !== -1) { totalScore += 20; continue; }
            // Fuzzy (Levenshtein) — only for tokens >= 3 chars
            if (qt.length >= 3) {
                var fieldTokens = tokenize(fieldValue);
                for (var f = 0; f < fieldTokens.length; f++) {
                    var dist = levenshtein(qt, fieldTokens[f]);
                    var maxLen = Math.max(qt.length, fieldTokens[f].length);
                    if (dist <= 1) { totalScore += 40; break; }
                    if (dist <= Math.ceil(maxLen * 0.3)) { totalScore += 15; break; }
                }
            }
        }
        return totalScore;
    }

    // ── Main search function ──
    function search(query, items, fields) {
        if (!query || !query.trim()) return items;

        var queryTokens = tokenize(query);
        if (queryTokens.length === 0) return items;

        var scored = [];
        for (var i = 0; i < items.length; i++) {
            var total = 0;
            for (var f = 0; f < fields.length; f++) {
                var val = items[i][fields[f]];
                if (val) total += scoreField(String(val), queryTokens);
            }
            if (total > 0) {
                scored.push({ index: i, score: total, item: items[i] });
            }
        }

        scored.sort(function (a, b) { return b.score - a.score; });
        return scored.map(function (s) { return s.item; });
    }

    // ── Debounce ──
    function debounce(fn, delay) {
        var timer = null;
        return function () {
            var context = this, args = arguments;
            clearTimeout(timer);
            timer = setTimeout(function () { fn.apply(context, args); }, delay);
        };
    }

    return {
        search: search,
        debounce: debounce,
        levenshtein: levenshtein
    };

})();
