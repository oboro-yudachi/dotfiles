#!/bin/bash

echo "⚠️  Doom Emacs を完全にアンインストールします"
echo "続行しますか？ (y/N)"
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "キャンセルしました"
    exit 0
fi

echo "🔄 Emacs を終了しています..."
osascript -e 'tell application "Emacs" to quit' 2>/dev/null || true
pkill -x Emacs 2>/dev/null || true
pkill -x emacs 2>/dev/null || true
sleep 2

echo "🗑️  Doom Emacs を削除しています..."
rm -rf ~/.config/emacs
rm -rf ~/.config/doom
rm -rf ~/.emacs.d
rm -rf ~/.doom.d
rm -rf ~/.local/share/doom
rm -rf ~/.local/share/straight
rm -f ~/.local/bin/doom
rm -f /usr/local/bin/doom

echo "🗑️  Emacs.app を削除しています..."
rm -f /Applications/Emacs.app
rm -rf "/Applications/Emacs.app"

echo "🗑️  emacs-plus をアンインストールしています..."
brew uninstall emacs-plus emacs-plus@29 emacs-plus@30 --force 2>/dev/null || true
brew cleanup emacs-plus 2>/dev/null || true

echo "🧹 シェルキャッシュをクリアしています..."
hash -r

echo "✅ アンインストールが完了しました"
echo "⚠️  ~/.zshrc の PATH 設定を手動で確認してください"
