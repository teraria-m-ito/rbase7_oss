# 日時ピッカーの他プロジェクトへの展開

基準実装は rbase7_canvas_admin（このリポジトリ）です。eport、ldi、cdi、mnb_import などは `rbase_common.js`、simple_form、`forms.css.scss` をプロジェクトごとに持っています。`rbase_lti_module` へ画面固有のパスやクエリを足さず、各プロジェクトのコアへ次を写します。

表示と保存する文字列は `2024/10/28 00:00:00` です。`Time.zone.parse` と `Time.parse` はこの形を受け取れます。

## 写すもの

1. `app/javascript/application.js`
   - `window.moment` と `moment/locale/ja` のあと `moment.locale("en")` とし、そのあと `tempusdominus-bootstrap/build/js/tempusdominus-bootstrap` を読む。
   - Tempus Dominus はグローバルな `jQuery` と `moment` を参照する。`rbase_common.js` の読み込み時に `window.moment` を触らない。貼り付け処理の中だけで使う。
2. `app/javascript/rbase_common.js`
   - `datetimePickerClickTimes` と `initDatetimePickers` を写し、`module.exports` に `initDatetimePickers` を足す。
3. `app/javascript/rbase_stimulus.js`
   - `RbaseController.connect` で、既存の `$('.datepicker').datepicker(...)` の直後に `Rbase.initDatetimePickers()` を置く。Turbo の preview では connect が先に return するので、そこには置かない。
4. `config/initializers/simple_form_custom.rb`
   - `DatetimePickerInput` を足す。`DatetimeLocalInput` は置かない。
   - `StringInput#input` の先頭で、`type` が `datetime` または `datetime-local` のときは `DatetimePickerInput` に渡す。ネイティブの日時入力は出さない。
   - `DateTimeInput` は `input_type == :datetime` のときだけピッカーにする。`:date` と `:time` は `super` のまま。ラベルの `for` は `attribute_name` にする（年月日セレクトの `_1i` にしない）。
5. `config/initializers/simple_form_bootstrap.rb`
   - `wrapper_mappings` に `datetime_picker: :default_input_form` を足す。
6. `app/assets/stylesheets/application.bootstrap.scss`
   - `tempusdominus-bootstrap/build/css/tempusdominus-bootstrap.min.css` を、`rbase/forms.css.scss` より前に import する。
7. `app/assets/stylesheets/rbase/forms.css.scss`
   - `.rbase-datetimepicker` のブロックを写す。閉じた入力の幅、枠内のカレンダーアイコン、カレンダーと時刻の横並び、下端の今日・削除・OK、時刻マスの高さはここにある。
8. `app/helpers/application_helper.rb`
   - カスタム項目の `date_time` は、入力と検索条件の両方で `as: :datetime_picker` にする。`date` は従来の datepicker のまま。
9. `app/models/concerns/calendar_datetime_range.rb`
   - 開始日時・終了日時を持つモデルが `include CalendarDatetimeRange` する。存在しない日付は保存せず、開始が終了より後のときは終了日時をエラーにする。
   - エラー文は `activerecord.errors.messages.invalid_date` と `before_start_at`。`config/locales/ja.yml` の同キーを写す。項目名は各モデルの `activerecord.attributes` に置く。

`package.json` に `moment`、`tempusdominus-bootstrap`、`bootstrap-icons` があること。アイコンクラスは `bi bi-*` にする。Font Awesome のクラスは Tempus Dominus が作る span では文字化けする。

## 画面での使い方

```erb
<%= form.input :start_at, as: :datetime_picker, date_click_time: :start %>
<%= form.input :end_at, as: :datetime_picker, date_click_time: :end %>
```

`date_click_time` を省略したときは項目名で決まる。

- `start_at`、`_from`、`_start` は開始。空欄で日付をクリックしたとき、または `yyyy/MM/dd` だけを貼り付けたとき、時刻は `00:00:00`。
- `end_at`、`_to`、`_end` は終了。同じ操作で時刻は `23:59:59`。
- それ以外は、日付を選んでも入っている時刻を変えない。

すでに入っている時刻がこの初期値と違うときは、日付を変えても時刻はそのまま。

`2026/11/31` のように存在しない日付は、翌月へ繰り上げない。ピッカーは `useStrict: true` と `keepInvalid: true` で、入力した文字列を残す。保存側はコアの `CalendarDatetimeRange` を include する。ActiveRecord の datetime 型は不正な日付を 12 月 1 日のように解釈して保存する。開始日時が終了日時より後のときは、終了日時だけをエラーにする。再表示は `invalid_calendar_datetime(:start_at)` を入力値の先頭に置く。このリポジトリでは `CanvasEnrollmentTerm`、`CanvasCourse`、`CanvasIntegrationRequestStopPeriod` が include している。

画面は `as: :datetime_picker` に書く。`as: :datetime_local` は使わない。`type: "datetime-local"` や `type: "datetime"` が残った文字列入力と、カラム型 datetime の `form.input` も、同じピッカーになる。

`rbase_lti_module` の操作ログ・取込履歴も `as: :datetime_picker` である。このモジュールを使うプロジェクトは、上のピッカー一式をコアへ写してから動かす。

## 行を後から足す画面

`initDatetimePickers` は、その時点で DOM にある `.rbase-datetimepicker` だけを初期化する。`<script type="text/template">` の中は対象外。行を append した直後に `Rbase.initDatetimePickers()` を呼ぶ。初期化済みの部品は `data("datetimepicker")` があるので、再呼び出ししても二重には作らない。

表の `.table-responsive` は `overflow` でポップアップを切る。その表だけ `overflow: visible` にする。この指定は画面側の CSS に置き、`forms.css.scss` には入れない。

## 反映

- simple_form の initializer を変えたあとは Rails を再起動する。
- `yarn build` と `yarn build:css` を実行する。`forms.css.scss` は `application.css` に取り込まれる。gem の `custom.css` は別ファイルの `@import` なので、画面専用の上書きだけなら CSS の再ビルドは不要。

## 写さないもの

履修期間の Canvas 側日時の併記、停止期間テーブルの overflow 解除、コース一覧の列幅などは画面固有。`node_modules` の Tempus Dominus は編集しない。
