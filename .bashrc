cdd() {
  local prev target repo

  # 直前のコマンドを取得
  prev="$(fc -ln -1 | sed 's/^[[:space:]]*//')"

  # 直前が cdd 自身になる場合は，さらに1つ前を見る
  if [[ "$prev" == "cdd" ]]; then
    prev="$(fc -ln -2 -2 | sed 's/^[[:space:]]*//')"
  fi

  case "$prev" in
    git\ clone* )
      repo="$(printf '%s\n' "$prev" | awk '{print $NF}')"
      target="${repo##*/}"
      target="${target%.git}"
      ;;

    mkdir* )
      # mkdir の最後の引数を取得
      target="$(printf '%s\n' "$prev" | awk '{print $NF}')"
      ;;

    * )
      echo "cdd: 直前のコマンドが git clone または mkdir ではありません"
      echo "prev: $prev"
      return 1
      ;;
  esac

  if [[ -d "$target" ]]; then
    cd "$target" || return 1
  else
    echo "cdd: directory not found: $target"
    echo "prev: $prev"
    return 1
  fi
}



pwdd() {
  if [ -z "$1" ]; then
    echo "usage: pwdd <prefix>"
    return 1
  fi

  find "$(pwd)" -name "$1*" -print
}
