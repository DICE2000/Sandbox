# RPGツクール2000のマップデータをRubyオブジェクトに変換する(3)
# テスト環境はRPGツクールVX Ace
# RPGツクール2000の正規ユーザー以外の人が使うと怒られると思います
#
# Lmu.rb, Sprite_Lmu.rbとこのスクリプトを導入して
# Lmuフォルダにマップデータとチップセットを入れてください
# 適宜自分の良いようにフォルダ構造とファイルネームを変えてね
#
mapdata = Lmu.new("Lmu\\Map0001.lmu")
p mapdata.chipset_id
p mapdata.width
p mapdata.height
p mapdata.ary_map1.length
p mapdata.ary_map2.length

Graphics.freeze
test = Map_Lmu.new(mapdata, "Lmu\\ChipSet\\基本.png")
text = Sprite.new
text.z = 1000
text.bitmap = Bitmap.new(Graphics.width, Graphics.height)

Graphics.transition
rgss_stop