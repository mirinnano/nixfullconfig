# CS2 1280x960 Stretched 設定（黒い縁なし）

## ✅ 推奨設定（黒い縁なし）

### Steam起動オプション
```
gamescope -w 1920 -h 1080 -W 1280 -H 960 -f --force-grab-cursor --rt --expose-wayland -- %command% -w 1280 -h 960 -fullscreen -nojoy -novid -stretch -aspect-ratio 4:3
```

### 重要なオプション説明
- `-w 1920 -h 1080`: 出力解像度（モニターのネイティブ）
- `-W 1280 -H 960`: 内部レンダリング解像度（4:3）
- `-f`: フルスクリーン
- `--force-grab-cursor`: マウスキャプチャ
- `--rt`: NVIDIA Real-time scheduler
- `--expose-wayland`: Waylandサポート
- `-aspect-ratio 4:3`: アスペクト比を4:3に固定

## 🎮 CS2内の設定（重要）

### ビデオ設定
1. **解像度**: `1280x960` または `1280x1024`
2. **ディスプレイモード**: `フルスクリーン` または `ボーダレス`
3. **アスペクト比**: `16:9` に設定（重要！）

### なぜ16:9にするか
- CS2は16:9に設定 → 4:3解像度を表示 → Gamescopeが16:9にストレッチ
- これで黒い縁が出ず、完全にストレッチされる

## 🔧 代替設定

### 方法1: シンプルな設定
```
gamescope -w 1920 -h 1080 -W 1280 -H 960 -f -- %command% -w 1280 -h 960 -fullscreen
```
CS2内でアスペクト比を16:9に設定すること。

### 方法2: NVIDIA最適化
```
gamescope -w 1920 -h 1080 -W 1280 -H 960 -f --force-grab-cursor --rt -- %command% -w 1280 -h 960 -fullscreen -nojoy -novid
```

### 方法3: Matsuo方式（プロ使用）
```
gamescope -w 1920 -h 1080 -W 1280 -H 960 -f --force-grab-cursor --rt --mangoapp -- %command% -w 1280 -h 960 -fullscreen -nojoy -novid -stretch -freq 0 -refresh 240 -tickrate 128
```

## ⚠️ 黒い縁が出る場合のチェックリスト

1. **CS2内のアスペクト比**が16:9になっているか？
   - 4:3に設定すると黒い縁が出る
   - 必ず16:9に設定

2. **モニター設定**を確認
   - NVIDIA設定 → ディスプレイ → 「GPUでスケーリング」を選択
   - 「オーバースキャン」を0%に

3. **解像度**が正しいか
   - 内部: 1280x960 (4:3)
   - 出力: 1920x1080 (16:9)

4. **Hyprlandの設定**
   - windowrules.confのCS2設定を削除済み（Gamescopeが処理）

## 🚀 設定手順

1. Steamを開く
2. ライブラリ → Counter-Strike 2
3. プロパティ → 起動オプション
4. 上記のコマンドを貼り付け
5. CS2を起動
6. **設定 → ビデオ → アスペクト比 → `16:9` に変更**
7. 解像度を `1280x960` に設定

## 🎯 確認事項

- [ ] Steam起動オプションに `-aspect-ratio 4:3` を含む
- [ ] CS2内のアスペクト比は `16:9`
- [ ] CS2内の解像度は `1280x960`
- [ ] ディスプレイモードは `フルスクリーン`
- [ ] NVIDIA設定でGPUスケーリングが有効
