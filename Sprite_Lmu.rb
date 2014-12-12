# RPGツクール2000のマップデータをRubyオブジェクトに変換する(2)
# テスト環境はRPGツクールVX Ace
# RPGツクール2000の正規ユーザー以外の人が使うと怒られると思います
#
# Lmuクラスからマップの描画が行えるかどうかのテストコード
class Map_Lmu
  
  attr_reader :tiles1
  attr_reader :tiles2  
  
  def initialize(mapdata, filename)
    @tiles1 = Sprite.new
    @tiles1.z = 0
    @tiles1.bitmap = Bitmap.new(16 * mapdata.width, 16 * mapdata.height)
    @tiles2 = Sprite.new
    @tiles2.z = 200
    @tiles2.bitmap = Bitmap.new(16 * mapdata.width, 16 * mapdata.height)
    pos = {:x => 0, :y => 0}
    # チップセットのビットマップを指定する
    bitmap_chipset = Bitmap.new(filename)
    # 転送用にRectを確保しておく
    @rect_transport = Rect.new(0, 0, 16, 16)
    
    mapdata.ary_map1.each{|m|
      get_mapid_btm(m.bin2dec2)
      @tiles1.bitmap.blt(pos[:x], pos[:y], bitmap_chipset, @rect_transport)
      pos[:x] += 16
      if pos[:x] == (16 * mapdata.width)
        pos[:x] = 0
        pos[:y] += 16
      end      
    }

    pos[:x] = 0
    pos[:y] = 0

    mapdata.ary_map2.each{|m|
      get_mapid_up(m.bin2dec2)
      @tiles2.bitmap.blt(pos[:x], pos[:y], bitmap_chipset, @rect_transport)
      pos[:x] += 16
      if pos[:x] == (16 * mapdata.width)
        pos[:x] = 0
        pos[:y] += 16
      end      
    }    
  end
  
  def get_mapid_btm(index_str)
    index = index_str.to_i
    if index >= 5096
      @rect_transport.x = 16 * 18 + 16 * ( (index - 5096) % 6 )
      @rect_transport.y = 16 * ( (index - 5096) / 6 )
    elsif index >= 5000
      @rect_transport.x = 16 * 12 + 16 * ( (index - 5000) % 6 )
      @rect_transport.y = 16 * ( (index - 5000) / 6 )
    elsif index == 4000
      @rect_transport.x = 16 * 1
      @rect_transport.y = 16 * 8      
    else
      @rect_transport.x = 16 * 1
      @rect_transport.y = 16 * 4
    end
  end
  
  # 上層マップの座標吸い出し
  # これは使い回しできるかも……
  def get_mapid_up(index_str)
    index = index_str.to_i
    if index >= 10048
      @rect_transport.x = 16 * 24 + 16 * ( (index - 10048) % 6 )
      @rect_transport.y = 16 * ( (index - 10048) / 6 )    
    else
      @rect_transport.x = 16 * 18 + 16 * ( (index - 10000) % 6 )
      @rect_transport.y = 16 * 8 + 16 * ( (index - 10000) / 6 )  
    end
  end
end

