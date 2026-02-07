# CS2 1280x960 Stretched 設定

## Steam起動オプション

以下をCS2のSteam起動オプションに設定：

```
gamescope -w 1280 -h 960 -f --force-grab-cursor -- %command% -w 1280 -h 960 -fullscreen
```

## 説明

- **-w 1280 -h 960**: 解像度を1280x960に設定
- **-f**: フルスクリーン
- **--force-grab-cursor**: マウスキャプチャを強制
- **%command%**: CS2の実行コマンド
- **-w 1280 -h 960 -fullscreen**: CS2側の解像度設定

## 代替オプション

### スムーズなストレッチ（推奨）
```
gamescope -w 1920 -h 1080 -W 1280 -H 960 -f -- %command% -w 1280 -h 960 -fullscreen -nojoy -novid -nopause
```

- **-W 1280 -H 960**: 内部解像度（4:3）
- **-w 1920 -h 1080**: ディスプレイ解像度（16:9へストレッチ）

### NVIDIA最適化
```
gamescope -w 1920 -h 1080 -W 1280 -H 960 -f --force-grab-cursor --rt -- %command% -w 1280 -h 960 -fullscreen -nojoy -novid
```

- **--rt**: NVIDIAのReal-time scheduler

## 設定手順

1. Steamを開く
2. ライブラリ → Counter-Strike 2
3. プロパティ → 起動オプション
4. 上記のコマンドを貼り付け

## Windowrules.confの修正

windowrules.confのCS2設定は削除してもOK（gamescopeが処理するため）
