# RPGツクール2000のマップデータをRubyオブジェクトに変換する(1)
# テスト環境はRPGツクールVX Ace
# RPGツクール2000の正規ユーザー以外の人が使うと怒られると思います
#
# 16進文字列とバイト列を相互変換する(ruby)
# http://techracho.bpsinc.jp/baba/2011_08_23/4403
# バイナリから配列番号を見るために使っているクラスです
# 値を評価する際には使えないので注意
#
class String
  def hex2bin
    s = self
    raise "Not a valid hex string" unless(s =~ /^[\da-fA-F]+$/)
    s = '0' + s if((s.length & 1) != 0)
    s.scan(/../).map{ |b| b.to_i(16) }.pack('C*')
  end
 
  def bin2hex
    self.unpack('C*').map{ |b| "%02X" % b }.join('')
  end
  
  # 以下はおまけ 十進法に直したい時（そのまんま）
  def bin2dec
    self.unpack('C*').join
  end
  # リトルエンディアンの場合
  def bin2dec2
    self.unpack("S*").join
  end
end
#
# 2000のマップデータのクラス
# 大いに参考にしたもの
# RPG2000/マップデータ
# http://rpg2kdev.sue445.net/?RPG2000%2F%A5%DE%A5%C3%A5%D7%A5%C7%A1%BC%A5%BF
# 
class Lmu
  
  attr_reader :header
  attr_reader :chipset_id
  attr_reader :width
  attr_reader :height
  attr_reader :ary_map1
  attr_reader :ary_map2

  def initialize(filename)
    @f = File.open(filename, "rb")
    # ヘッダ 0x0A("LcfMapUnit"の文字列長) + "LcfMapUnit"
    # LMUを正しく読む限りは11バイト固定だが応用のためにこうしようね！
    @index = @f.read(1).bin2dec
    @header = @f.read(@index.to_i)
    # @indexに配列番号を入れる
    @index = @f.read(1).bin2hex
    # どんどんデータ入れる
    @chipset_id = set_chipset(@index)
    @width = set_width(@index)
    @height = set_height(@index)
    @scrolltype = set_scrolltype(@index)
    @index = @f.read(1).bin2hex
    set_parallax(@index) if @index == "IF"
    # 下層マップ
    @ary_map1 = set_map(@width * @height)
    # 上層マップ
    @index = @f.read(1).bin2hex
    @ary_map2 = set_map(@width * @height)
    # あとは面倒なのでおしまい
    @f.close
    p "Lmu正常終了"
  end
  
  #
  # バイナリの先頭からBER整数を取得する
  # 

  def get_ber_int(f)
    j = f.read(1).bin2dec.to_i
    i = f.read(j).unpack("w").join
    return i
  end
  
  def set_chipset(index)
    if index == "01"
      get_ber_int(@f)
      @index = @f.read(1).bin2hex
      return i.to_i
    else
      return 1
    end
  end
  
  def set_width(index)
    if index == "02"
      i = get_ber_int(@f)
      @index = @f.read(1).bin2hex
      return i.to_i
    else
      return 20
    end
  end
  
  def set_height(index)
    if index == "03"
      i = get_ber_int(@f)
      @index = @f.read(1).bin2hex
      return i.to_i
    else
      return 15
    end
  end
  
  def set_scrolltype(index)
    if index == "0B"
      i = get_ber_int(@f)
      return i.to_i
    else
      p @index
      p "スクロールタイプ：解析エラー"
      return 0
    end
  end
  
  def set_parallax(index)
    # ここで遠景処理書く
  end
  
  def set_map(length)
    ary_map = []
    if @index == "47" || @index == "48"
      i = [@width * @height * 2].pack("w").length
      @f.read(i)
      for i in 0...(length)
        str = @f.read(2)
        ary_map.push str
      end
    else
      p @index
      p "マップ構造：解析エラー"
    end
    return ary_map
  end
end
