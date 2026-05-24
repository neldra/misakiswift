# MisakiSwiftLite

iOS 16-compatible fork of [`mlalma/MisakiSwift`](https://github.com/mlalma/MisakiSwift) with the MLX-Swift neural fallback stripped.

## What's removed vs upstream

- `Sources/MisakiSwift/English/FallbackNetwork/` — BART neural OOV G2P (requires MLX, iOS 18+).
- `Extensions/MLXArray+DebugPrint.swift` — MLX debug helper.
- `MLXUtilsLibrary` dependency — `MToken` is vendored directly.
- `mlx-swift` dependency.
- en-GB lexicon/BART resources (en-US only for v1).

## What remains

- en-US lexicon (`us_gold.json`, `us_silver.json`).
- Apple `NaturalLanguage`-based POS disambiguation.
- `EnglishG2P` public entry point.
- Number expansion, token context, sentence splitting.

OOV words (lexicon miss) return `nil` for their `phonemes` field. Callers handle
OOV themselves (typically by routing the word to a separate G2P backend, e.g.
FluidAudio's BART model).

## Licence

Apache 2.0, retained from upstream. See `LICENSE`.

## Used by

- [Aidoku](https://github.com/Aidoku/Aidoku) — text-to-speech for text-based
  series via the FluidAudio Kokoro neural TTS path.
