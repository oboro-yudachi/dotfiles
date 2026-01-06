#!/bin/bash

set -e  # エラー時に停止

echo "======================================"
echo "  Doom Emacs 自動インストーラー"
echo "======================================"
echo ""

# 色付け用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 前提条件の確認
echo "${YELLOW}[確認]${NC} 前提条件を確認しています..."

if ! command -v brew &> /dev/null; then
    echo "${RED}[エラー]${NC} Homebrew がインストールされていません"
    echo "次のコマンドでインストールしてください:"
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

echo "${GREEN}[✓]${NC} Homebrew がインストールされています"

# 既存のインストールを確認
if [ -d "$HOME/.config/emacs" ] || [ -d "$HOME/.emacs.d" ]; then
    echo "${YELLOW}[警告]${NC} 既存の Emacs 設定が検出されました"
    echo "続行すると上書きされる可能性があります。続行しますか？ (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "${YELLOW}[キャンセル]${NC} インストールを中止しました"
        exit 0
    fi
fi

echo ""
echo "${GREEN}[1/6]${NC} emacs-plus をインストールしています..."
if ! brew tap | grep -q "d12frosted/emacs-plus"; then
    brew tap d12frosted/emacs-plus
fi

if ! brew list emacs-plus@30 &> /dev/null; then
    brew install emacs-plus@30 
else
    echo "${YELLOW}[スキップ]${NC} emacs-plus@30 は既にインストールされています"
fi

# /Applications にリンク
if [ ! -e "/Applications/Emacs.app" ]; then
    ln -s /opt/homebrew/opt/emacs-plus@30/Emacs.app /Applications 2>/dev/null || true
    echo "${GREEN}[✓]${NC} Emacs.app を /Applications にリンクしました"
fi

echo ""
echo "${GREEN}[2/6]${NC} 依存ツールをインストールしています..."
brew install git ripgrep fd jq pandoc shellcheck cmake libtool pkg-config tree-sitter coreutils 2>/dev/null || true

echo ""
echo "${GREEN}[3/6]${NC} フォントをインストールしています（任意）..."
if ! brew list --cask font-fira-code &> /dev/null; then
    brew tap homebrew/cask-fonts 2>/dev/null || true
    brew install --cask font-fira-code 2>/dev/null || echo "${YELLOW}[スキップ]${NC} フォントのインストールに失敗しました（オプションなので続行します）"
fi

echo ""
echo "${GREEN}[4/6]${NC} Doom Emacs をクローンしています..."
if [ -d "$HOME/.config/emacs" ]; then
    echo "${YELLOW}[スキップ]${NC} ~/.config/emacs は既に存在します"
else
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    echo "${GREEN}[✓]${NC} Doom Emacs をクローンしました"
fi

echo ""
echo "${GREEN}[5/6]${NC} Doom Emacs をインストールしています..."
echo "${YELLOW}[注意]${NC} 初回インストールは数分かかる可能性があります"
~/.config/emacs/bin/doom install --no-env --no-fonts

echo ""
echo "${GREEN}[6/6]${NC} パス設定と初期化を行っています..."

# doom コマンドを PATH に追加
mkdir -p ~/.local/bin
ln -sf ~/.config/emacs/bin/doom ~/.local/bin/doom 2>/dev/null || true

# ~/.zshrc に PATH を追加（まだない場合）
if ! grep -q '.local/bin' ~/.zshrc 2>/dev/null; then
    echo '' >> ~/.zshrc
    echo '# Doom Emacs' >> ~/.zshrc
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    echo "${GREEN}[✓]${NC} ~/.zshrc に PATH を追加しました"
fi

# coreutils の PATH を追加
if ! grep -q 'coreutils/libexec/gnubin' ~/.zshrc 2>/dev/null; then
    echo 'export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"' >> ~/.zshrc
    echo "${GREEN}[✓]${NC} coreutils (gls) を PATH に追加しました"
fi

# 初期同期
echo ""
echo "${YELLOW}[初期化]${NC} doom sync を実行しています..."
export PATH="$HOME/.local/bin:$PATH"
~/.config/emacs/bin/doom sync

echo ""
echo "======================================"
echo "${GREEN}  インストールが完了しました！${NC}"
echo "======================================"
echo ""
echo "次のステップ:"
echo "1. ターミナルを再起動するか、次のコマンドを実行:"
echo "   ${YELLOW}source ~/.zshrc${NC}"
echo ""
echo "2. Doom Emacs の状態を確認:"
echo "   ${YELLOW}doom doctor${NC}"
echo ""
echo "3. 設定をカスタマイズ:"
echo "   ${YELLOW}vim ~/.config/doom/init.el${NC}"
echo "   ${YELLOW}vim ~/.config/doom/config.el${NC}"
echo ""
echo "4. 設定変更後は同期を実行:"
echo "   ${YELLOW}doom sync${NC}"
echo ""
echo "5. Emacs を起動:"
echo "   ${YELLOW}open /Applications/Emacs.app${NC}"
echo ""
