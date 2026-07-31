# coding: utf-8
require 'csv'

namespace :rbase do
  desc "import jigyosho zipcode."
  task :import_jigyosho_zipcode => :environment do
    puts "[import_jigyosho_zipcode]start..."
    csv_data = CSV.read("#{Rails.root}/tmp/JIGYOSYO.csv", headers: false)
    csv_data.each_with_index do |data, index|
      #data[0] 所在地JIS
      #data[1] 法人名カナ
      #data[2] 法人名
      #data[3] 住所1(都道府県)
      #data[4] 住所2(市区町村)
      #data[5] 住所3(町域名)
      #data[6] 住所4(丁番地)
      #data[7] 郵便番号
      #data[8] 旧郵便番号
      #data[9] 取扱局
      #data[10] 表示種別
      #data[11] 複数番号有無
      #data[12] 修正コード
      zip_record = KenAll::PostalCode.where(code: data[7]).first || KenAll::PostalCode.new
      zip_record.code = data[7]
      zip_record.address1 = data[3]
      zip_record.address2 = data[4]
      zip_record.address3 = "#{data[5]}#{data[6]}"
      zip_record.save!
      puts "[import_jigyosho_zipcode]#{index}/#{csv_data.size} --- #{zip_record.code} #{zip_record.address1} #{zip_record.address2} #{zip_record.address3}"
    end
    puts "[import_jigyosho_zipcode]finished..."
  end
end
