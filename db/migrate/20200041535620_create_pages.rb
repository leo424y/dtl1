class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.uuid :uid
      t.string :pid
      t.string :ptitle
      t.string :ptype
      t.string :pdescription
      t.string :ptime
      t.string :mtime
      t.string :url
      t.string :platform
      t.string :score
      t.timestamps
    end
    [:uid, :uname, :pid, :ptitle, :ptype, :ptime, :mtime, :url, :platform, :score].each do |a|
      add_index :pages, a 
    end

  end
end