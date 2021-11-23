import options, os, times, strutils, sequtils
import halonium

{.experimental: "codeReordering".}

main()
move_downloads(getHomeDir() & "Desktop/CurrentCSV")

proc main() =
  var session = createSession(Chrome)
  for w in session.windows:
    w.maximize()
  session.navigate("https://clarity.dexcom.jp/professional/")
  sleep(2000)
  # ログイン処理
  let userName = "input[name=\"username\"]"
  let element = session.waitForElement(userName).get()
  element.sendKeys("", Key.Tab)

  let password = "input[name=\"password\"]"
  let element2 = session.waitForElement(password).get()
  element2.sendKeys("", Key.Enter)

  sleep(10000)

  var elements = session.findElements("patient-list-row", LocationStrategy.ClassNameSelector)
  echo "要素数", elements.len
  let count = elements.len-1

  # CSVダウンロード
  for i in 0..count:
    #var tElements = session.findElements("patient-list-row", LocationStrategy.ClassNameSelector)
    elements = session.findElements("patient-list-row", LocationStrategy.ClassNameSelector)
    elements[i].click()
    sleep(3000)
    let pElements = session.findElements("patient-view-data__button", LocationStrategy.ClassNameSelector)
    pElements[0].click()
    sleep(30000)
    let p2Element = session.waitForElement(".date-range-picker__icon").get()
    p2Element.click()
    sleep(5000)
    let p3Element = session.waitForElement(".btn:nth-child(3)").get()
    p3Element.click()
    sleep(10000)
    let okButton = session.waitForElement(".report-icon-bar__export-icon-button").get()
    okButton.click()
    sleep(20000)
    let okButton2 = session.waitForElement(".btn-3d").get()
    okButton2.click()
    sleep(20000)
    let closeButton = session.waitForElement(".btn-3d").get()
    closeButton.click()
    sleep(10000)
    let backButton = session.waitForElement(".clarity-sidebar-info-patient-list-link").get()
    backButton.click()
    #move_downloads(getHomeDir() & "Desktop/CurrentCSV/Dexcomエクセル")
    sleep(10000)

# 患者ページに遷移してからの処理
proc csv_download(session: Session) =
  let button30 = session.waitForElement("#r-data-button-30").get()
  button30.click()
  let dlCsvButton = session.waitForElement("#r-button-data-export-csv").get()
  dlCsvButton.click()
  sleep(3000)
  session.navigate("https://carelink.medtronic.eu/secured/clinicDashboard.html#/home")

# ダウンロード後のファイルを特定フォルダへ移動
proc move_downloads(path: string) =
  # 移動先のフォルダが無ければ作成する
  if not existsDir(path):
    os.createDir(path)

  let dl_path = os.getHomeDir() & "Downloads"
  for f in walkFiles(dl_path & "/*.csv"):
    if getLastModificationTime(f) > (now() - minutes(60)).toTime:
      #echo f
      #echo extractFilename(f)
      let file_names = extractFilename(f).replace(".csv", "").split(" ")
      let now_dir = file_names[0] & " " & file_names[1]
      if not existsDir(path & "/" & now_dir):
        os.createDir(path & "/" & now_dir)
      let new_path = path & "/" & now_dir & "/" & extractFilename(f)
      os.moveFile(f, new_path)
