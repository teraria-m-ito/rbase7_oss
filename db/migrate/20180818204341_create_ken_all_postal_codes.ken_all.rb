# This migration comes from ken_all (originally 20121028092517)
class CreateKenAllPostalCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :ken_all_postal_codes do |t|
      t.string :code, index: true
      t.text :address1
      t.text :address2
      t.text :address3
      t.text :address_kana1
      t.text :address_kana2
      t.text :address_kana3
      t.timestamps
    end

  end
end
