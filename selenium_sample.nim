discard """
Zennからデータを自動でCSVに保存する自動操作プログラム
"""

import options, os, osproc, times, strutils, sequtils
import halonium

# 関数の呼び出しを定義順に依らず可能にするプラグマ
{.experimental: "codeReordering".}

#main()
download_chrome_driver()

proc main() =
  # セッション単位で操作
  var session = createSession(Chrome)

  # デフォルトではブラウザウィンドウが縮小状態で起動するため、画面サイズに拡大する
  for w in session.windows:
    w.maximize()

  # 特定のURLへ移動
  session.navigate("https://zenn.dev/")

  # リンクを開くのを待機
  sleep(2000)

  discard """
  ログイン処理サンプル
    let userName = "input[name=\'username\']"
    let element = session.waitForElement(userName).get()
    elelement.sendKeys("", Key.Tab)

    let password = "input[name=\'password\']"
    let element2 = session.waitForElement(password).get()
    element2.sendKeys("", Key.Enter)
  """

  # ログイン処理を待機する必要あり（waitForElementでもいいかも？）
  sleep(10000)

# https://chromedriver.chromium.org/downloads
proc download_chrome_driver() =
  #let test = execCmdEx("echo test")
  let res = execCmdEx("/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --version")
  echo res[0].split(" ")[2]
