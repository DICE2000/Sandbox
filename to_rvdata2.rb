# coding: utf-8
require 'jsonable'
require 'zlib'
require_relative 'rgss3'
[
  'Data/Actors.json',
#  'Data/Animations.json',
#  'Data/Armors.json',
#  'Data/Classes.json',
#  'Data/CommonEvents.json',
#  'Data/Enemies.json',
#  'Data/Items.json',
#  *Dir.glob('Data/Map[0-9][0-9][0-9].json'),
#  'Data/MapInfos.json',
#  'Data/Skills.json',
#  'Data/States.json',
#  'Data/System.json',
#  'Data/Tilesets.json',
#  'Data/Troops.json',
#  'Data/Weapons.json'
].each do |json|
  text = ''
  f = File.open(json, 'r:utf-8')
  f.each {|line|
  	text += line
  }
  data = JSON.parse(text)
  data_trans = []
  # 中身がハッシュになっている……
  if data.is_a?(Array)
	    data.each{ |d|
	    	if d == nil
	    		data_trans << d
	    	# この辺でメソッドがいる
	    	# まず先頭のjson_classを見てクラスを決定
	    	# ハッシュ内の値に応じてクラスの変数を初期化してオブジェクトを生成
	    	# 改めてそれを要素として返す
	    	else
	    		data_trans << d.restore_rvdata2
	    	end
	    }
  end
  File.open('Data/temp/'+File.basename(json,'.json')+'.rvdata2', 'wb') do |file|
    file.write(Marshal.dump(data_trans))
  end
  f.close
end
#data = YAML.load_file('Data/Scripts.yml')
#Dir.glob('Data/Scripts/*.rb') do |rb|
#  File.open(rb, 'rb') do |file|
#    file.read.gsub(/(\r\n|\r|\n)/, "\n").split("# -*- END_OF_SCRIPT -*-\n\n").map do |src|
#      head, lf, script = src.partition("\n")
#      id = /id: (\d+)/.match(head).to_a.at(1).to_i
#      name = File.basename(rb, '.rb')
#      name = '' if name == "( NONAME )"
#      data[data.index(id)] = [id, name, Zlib::Deflate.deflate(script.chop)]
#    end
#  end
#end
#File.open('Data/Scripts.rvdata2', 'wb') do |file|
#  file.write(Marshal.dump(data))
#end
