class MyoujiMaster < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  def self.is_myouji(str)
    self.where(myouji: str).first
  end
  
  def self.include_myouji?(str)
    self.where("myouji like '%#{str}%'").first
  end
  
  def self.sei_mei(v)
    sei = nil
    mei = nil
    tmp_myouji = v.strip
    
    #名になり得ないものは除外する
    return nil,nil if tmp_myouji.to_s.include?("工場")
    return nil,nil if tmp_myouji.to_s.include?("連携")
    return nil,nil if tmp_myouji.to_s.include?("戦績")
    return nil,nil if tmp_myouji.to_s.include?("電話")
    return nil,nil if tmp_myouji.to_s.include?("開発")
    return nil,nil if tmp_myouji.to_s.include?("設備")

    
    tmp_myouji = tmp_myouji.gsub(/ニ/, "二")
    [3,2,1,0].each do |i|
      myouji = tmp_myouji[0..i]
      next if myouji.blank?
      if ::MyoujiMaster.where(myouji: myouji).first
        name_last = myouji
        name_first = tmp_myouji[(myouji.size)..(tmp_myouji.size-1)] if myouji.size < tmp_myouji.size
            
        if !name_first.blank? && name_first.size <= 3 and name_first.size >= 1
          sei =myouji
          mei = name_first.gsub(/-/, "一")
          break
        end
      end
    end
    
    return sei, mei
  end
end