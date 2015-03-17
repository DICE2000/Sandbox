# encoding: utf-8
# to_json2.rb
# author: dice2000
# original author: aoitaku
# https://gist.github.com/aoitaku/7822424
# 
# to_yaml.rbをjsonに対応させたもの
# デバッグ途中
#
require 'jsonable'
require 'zlib'
require_relative 'rgss3'
[
  'Data/Actors.rvdata2',
  'Data/Animations.rvdata2',
#  'Data/Areas.rvdata2',
  'Data/Armors.rvdata2',
  'Data/Classes.rvdata2',
  'Data/CommonEvents.rvdata2',
  'Data/Enemies.rvdata2',
  'Data/Items.rvdata2',
  *Dir.glob('Data/Map[0-9][0-9][0-9].rvdata2'),
#  'Data/MapInfos.rvdata2',
  'Data/Skills.rvdata2',
  'Data/States.rvdata2',
  'Data/System.rvdata2',
  'Data/Tilesets.rvdata2',
  'Data/Troops.rvdata2',
  'Data/Weapons.rvdata2'
].each do |rvdata|
  data = ''
  File.open(rvdata, 'rb') do |file|
    data = Marshal.load(file.read)
    if data.is_a?(Array)
	    data.each{ |d|
	    	d.force_encording if d != nil
	    }
	elsif data.is_a?(Hash)
		data.force_encording if data.size != 0
	else
		data.force_encording
    end
  end
  File.open('Data/'+File.basename(rvdata,'.rvdata2')+'.json', 'w') do |file|
    file.write(data.to_json)
  end
end
