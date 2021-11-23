# nim_selenium_sample
https://img.shields.io/badge/nim-v1.4.0-ff7964.svg?style=for-the-badge
NimでSeleniumをするサンプルコード

### 事前準備
Chromeを自動操作するためにChrome Web Driverを下記からインストールしてください。
動作させるPCのChromeバージョンと合わせたバージョンのドライバーが必要になります。
（今後自動ダウンロードさせたい）

https://chromedriver.chromium.org/downloads

### ビルド

```Shell
$ nim c --threads:on selenium_sample.nim
```
