#!/usr/bin/env bash
# tmux開発環境セットアップスクリプト

set -e

echo "=========================================="
echo "tmux開発環境セットアップ"
echo "=========================================="

# 色設定
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ステップ1: TPMインストール
echo -e "\n${BLUE}[1/5]${NC} TPM (tmux Plugin Manager) インストール中..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo -e "${GREEN}✓${NC} TPMインストール完了"
else
    echo -e "${YELLOW}⚠${NC} TPMは既にインストール済み"
fi

# ステップ2: dotfilesリンク
echo -e "\n${BLUE}[2/5]${NC} dotfilesリンク作成中..."

# .tmux.conf
if [ ! -f "$HOME/.tmux.conf" ]; then
    ln -sf ~/rudra/dotfiles/.tmux.conf ~/.tmux.conf
    echo -e "${GREEN}✓${NC} .tmux.conf リンク作成完了"
elif [ ! -L "$HOME/.tmux.conf" ]; then
    echo -e "${YELLOW}⚠${NC} .tmux.confが既に存在します（バックアップ作成中...）"
    mv ~/.tmux.conf ~/.tmux.conf.backup
    ln -sf ~/rudra/dotfiles/.tmux.conf ~/.tmux.conf
    echo -e "${GREEN}✓${NC} .tmux.conf リンク作成完了（古いファイルは~/.tmux.conf.backupに保存）"
else
    echo -e "${YELLOW}⚠${NC} .tmux.confは既にリンク済み"
fi

# Neovim設定
if [ ! -d "$HOME/.config/nvim" ]; then
    mkdir -p ~/.config
    ln -sf ~/rudra/dotfiles/.config/nvim ~/.config/nvim
    echo -e "${GREEN}✓${NC} Neovim設定リンク作成完了"
elif [ -L "$HOME/.config/nvim" ]; then
    echo -e "${YELLOW}⚠${NC} Neovim設定は既にリンク済み"
else
    echo -e "${YELLOW}⚠${NC} Neovim設定が既に存在します（スキップ）"
fi

# zsh設定
if [ ! -f "$HOME/.zshrc" ]; then
    ln -sf ~/rudra/dotfiles/.zshrc ~/.zshrc
    echo -e "${GREEN}✓${NC} .zshrc リンク作成完了"
elif [ -L "$HOME/.zshrc" ]; then
    echo -e "${YELLOW}⚠${NC} .zshrcは既にリンク済み"
else
    echo -e "${YELLOW}⚠${NC} .zshrcが既に存在します（手動で確認してください）"
fi

# ステップ3: スクリプト実行権限確認
echo -e "\n${BLUE}[3/5]${NC} スクリプト実行権限確認中..."
chmod +x ~/rudra/scripts/tmux-dev-layout.sh
echo -e "${GREEN}✓${NC} tmux-dev-layout.sh 実行権限設定完了"

# ステップ4: NixOS再構築確認
echo -e "\n${BLUE}[4/5]${NC} NixOS設定確認"
echo -e "tmuxパッケージがconfiguration.nixに追加されました。"
echo -e "システムを再構築しますか？ (y/N)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}システム再構築中...${NC}"
    sudo nixos-rebuild switch --flake ~/rudra/.#summerpockets
    echo -e "${GREEN}✓${NC} システム再構築完了"
else
    echo -e "${YELLOW}⚠${NC} 後で以下のコマンドでシステムを再構築してください："
    echo "  sudo nixos-rebuild switch --flake ~/rudra/.#summerpockets"
fi

# ステップ5: 完了メッセージ
echo -e "\n${BLUE}[5/5]${NC} セットアップ完了！"
echo ""
echo "=========================================="
echo -e "${GREEN}✓ tmux開発環境セットアップ完了！${NC}"
echo "=========================================="
echo ""
echo "次のステップ："
echo ""
echo "1. tmuxプラグインインストール："
echo "   tmuxを起動して、Ctrl+a, I を押してください"
echo ""
echo "2. zsh設定を再読み込み："
echo "   source ~/.zshrc"
echo ""
echo "3. 開発環境起動："
echo "   - キーボード: Super + Shift + Enter"
echo "   - ターミナル: dev または nixdev"
echo ""
echo "詳細は TMUX_SETUP.md を参照してください。"
echo ""
